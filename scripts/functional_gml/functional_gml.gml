#macro fun function

enum FType {
	Array,
	Buffer,
	__size
}


global._it_create = array_create(FType.__size);
global._it_create[FType.Array] = function(_size, _value) { return array_create(_size, _value); }

global._it_get = array_create(FType.__size);
global._it_get[FType.Array] = function(_iterable, _pos) { return _iterable[_pos]; }

global._it_set = array_create(FType.__size);
global._it_set[FType.Array] = function(_iterable, _pos, _val) { _iterable[@ _pos] = _val; }

global._it_size = array_create(FType.__size);
global._it_size[FType.Array] = function(_iterable) { return array_length(_iterable); }

global._it_resize = array_create(FType.__size);
global._it_resize[FType.Array] = function(_iterable, _size) { array_resize(_iterable, _size); }


function Iterator(_iterable, _type) constructor {
	iterable = _iterable;
	type = _type;
	pos = 0;
	
	// methods
	__f_get = global._it_get[type];
	__f_set = global._it_set[type];
	__f_size = global._it_size[type];
	__f_resize = global._it_resize[type];
	
	static next = function() {
		pos++;
		return __f_get(iterable, pos-1);
	}
	
	static write = function(_val) {
		__f_set(iterable, pos, _val);
		pos++;
	}
	
	static map = function(_fun) {
		__f_set(iterable, pos, _fun(__f_get(iterable, pos)));
		pos++;
	}
	
	static has_next = function() {
		return pos < __f_size(iterable) - 1;
	}
	
	static size = function() {
		return __f_size(iterable);
	}
	
	static reset = function() {
		pos = 0; 
	}
	
	static seek = function(_pos) {
		pos = _pos;
	}
	
	static tell = function() {
		return pos;
	}
	
	static data = function() {
		return iterable;
	}
	
	static resize = function(_size) {
		__f_resize(iterable, _size);
		pos = min(pos, _size-1);
	}
}


function pipe(_data, _type) {
	return new Pipe(new Iterator(_data, _type));
}


function Pipe(_iterator) constructor {
	it = _iterator;
	
	static map = function(_fun) {
		it.reset();
		for(var i = 0; i < it.size(); i++) {
			it.map(_fun);
		}
		return self
	}
	
	static map_type = function(_fun, _type) {
		var _f_create = global._it_create[it.type];
		var _it_new = _f_create(it.size(), _type);
		
		it.reset();
		for(var i = 0; i < it.size(); i++){
			_it_new.write(it.next());
		}
		
		it = _it_new;
		return self;
	}
	
	static flatten = function() {
		var _f_create = global._it_create[it.type];
		var _f_size = global._it_size[it.type];
		var _f_get = global._it_get[it.type];
		
		var _flat_size = 0;
		
		// calculate size
		it.reset();
		repeat(it.size()){
			_flat_size += _f_size(it.next());
		}
		
		var _new_it = new Iterator(_f_create(_flat_size, 0), it.type);
		
		// fill iterable with values
		it.reset();
		for(var i = 0; i < it.size(); i++){
			var _val = it.next();
			
			for(var n = 0; n < _f_size(_val); n++){
				_new_it.write(_f_get(_val, n));
			}
		}
		it = _new_it;
		return self;
	}
	
	static flat_map = function(_fun) {
		var _f_create = global._it_create[it.type];
		var _f_size = global._it_size[it.type];
		var _f_get = global._it_get[it.type];
		
		var _flat_size = 0;
		
		// calculate size
		it.reset();
		repeat(it.size()){
			_flat_size += _f_size(it.next());
		}
		
		var _new_it = new Iterator(_f_create(_flat_size, 0), it.type);
		
		// fill iterable with values
		it.reset();
		for(var i = 0; i < it.size(); i++){
			var _val = it.next();
			
			for(var n = 0; n < _f_size(_val); n++){
				_new_it.write(_fun(_f_get(_val, n)));
			}
		}
		it = _new_it;
		return self;
	}
	
	
	static for_each = function(_fun) {
		it.reset();
		repeat(it.size()) {
			_fun(it.next());
		}
		return self
	}
	
	
	static reduce = function(_fun, _initial) {
		if(is_undefined(_initial)){
			_initial = 0;
		}
		
		it.reset();
		var _val = _initial;
		for(var i = 0; i < it.size(); i++){
			var _next = it.next();
			_val = _fun(_val, _next, i);
		}
		return _val;
	}
	
	
	static sum = function() {
		var _val = 0;
		it.reset();
		for(var i = 0; i < it.size(); i++){
			_val += it.next();
		}
		return _val;
	}
	
	
	static mean = function() {
		return sum() / it.size();
	}
	
	
	static group_by = function(_key_selector) {
		var _f_create = global._it_create[it.type];
		var _f_resize = global._it_resize[it.type];
		var _map = ds_map_create();
		var _keys = ds_list_create();
		var _chunk_size = min(1024, max(4, round(sqrt(it.size()))));
		
		// write data to chunked iterators corresponding to each key
		it.reset();
		for(var i = 0; i < it.size(); i++){
			var _val = it.next();
			var _key = _key_selector(_val, i);
			var _it;
			if(!ds_map_exists(_map, _key)){
				_it = new Iterator(_f_create(_chunk_size, 0), it.type);
				_map[? _key ] = _it;
				ds_list_add(_keys, _key);
			} else {
				_it = _map[? _key ];
				if(_it.tell() >= _it.size()){
					_it.resize(_it.size() + _chunk_size);
				}
			}
			_it.write(_val);
		}
		
		// resize chunked iterators that are too large
		for(var i = 0; i < ds_list_size(_keys); i++){
			var _key = _keys[| i];
			var _it = _map[? _key];
			if(_it.size() != _it.tell()){
				_it.resize(_it.tell());
			}
		}
		
		ds_list_destroy(_keys);
		
		return _map;
	}
	
	
	static filter = function(_fun) {
		var _f_create = global._it_create[it.type];
		var _nit = new Iterator(_f_create(it.size(), 0), it.type);
		it.reset();
		for(var i = 0; i < it.size(); i++) {
			var _val = it.next();
			if(_fun(_val)) {
				_nit.write(_val);
			}
		}
		_nit.resize(_nit.tell());
		it = _nit;
		return self;
	}
	
	static min = function() {
		it.reset();
		var _val = it.next();
		for(var i = 1; i < it.size(); i++){
			_val = min(_val, it.next());
		}
		return _val;
	}
	
	static max = function() {
		it.reset();
		var _val = it.next();
		for(var i = 1; i < it.size(); i++){
			_val = max(_val, it.next());
		}
		return _val;
	}
	
	static extend = function(_it_ext) {
		var _new_size = it.size() + _it_ext.size();
		it.seek(it.size());
		it.resize(_new_size);
		
		// handle write positions
		var _pos_prev = it.tell();
		_it_ext.reset();
		
		
		// write
		for(var i = 0; i < _it_ext.size(); i++){
			it.write(_it_ext.next());
		}
		
		_it_ext.seek(_pos_prev); // reset pos
		return self;
	}
	
	static data = function() {
		return it.iterable;
	}
}

function iterator_zip(it1, it2) {
	it1.reset();
	it2.reset();
	
	var _size = min(it1.size(), it2.size());
	
	var _out, _f_set, _f_create;
	
	//if same type, keep the type, else output an array iterator
	var _type = (it1.type == it2.type ? it1.type : FType.Array)
	
	_f_create = global._it_create[_type];
	_f_set = global._it_set[_type];
	_out = new Iterator(_f_create(_type, 0), _type);
	
	for(var i = 0; i < _size; i++){
		var tuple = _f_create(2, 0);
		_f_set(tuple, 0, it1.next());
		_f_set(tuple, 1, it2.next());
		_out.write(tuple);
	}
	
	return _out;
}




