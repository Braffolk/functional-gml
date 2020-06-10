function array_for_each(_array, _function) {
	for(var i = 0; i < array_length(_array); i++) {
		_function(_array[i], i);
	}
}


function array_map(_array, _function) {
	for(var i = 0; i < array_length(_array); i++) {
		_array[i] = _function(_array[i], i);
	}
	return _array;
}


function array_flatten(_array) {
	var _flat_size = 0;
	for(var i = 0; i < array_length(_array); i++){
		_flat_size += array_length(_array[i]);
	}
	
	var _flattened = array_create(_flat_size);
	var j = 0;
	for(var i = 0; i < array_length(_array); i++){
		var _sub_array = _array[i];
		for(var n = 0; n < array_length(_sub_array); n++) {
			_flattened[j++] = _sub_array[n];
		}
	}
	return _flattened;
}


function array_flat_map(_array, _fun) {
	var _flat_size = 0;
	for(var i = 0; i < array_length(_array); i++){
		_flat_size += array_length(_array[i]);
	}
	
	var _flattened = array_create(_flat_size);
	var j = 0;
	for(var i = 0; i < array_length(_array); i++){
		var _sub_array = _array[i];
		for(var n = 0; n < array_length(_sub_array); n++) {
			_flattened[j++] = _fun(_sub_array[n]);
		}
	}
	return _flattened;
}


function array_reduce(_array, _function, _initial_value) {
	var _val = _initial_value;
	for(var i = 0; i < array_length(_array); i++) {
		var _next_val = _array[i];
		
		var _val = _function(_val, _next_val, i);
	}
	return _val;
}


function array_sum(_array) {
	var _val = 0;
	for(var i = 0; i < array_length(_array); i++) {
		_val += _array[i];
	}
	return _val;
}


function array_mean(_array) {
	var _val = 0;
	for(var i = 0; i < array_length(_array); i++) {
		_val += _array[i];
	}
	return _val/max(1, array_length(_array));
}


function array_zip() {
	var _size = array_length(argument0);
	for(var n = 1; n < argument_count; n++){
		_size = min(_size, array_length(argument[n]));
	}
	
	var _zipped_array = array_create(_size);
	for(var i = 0; i < _size; i++){
		var _tuple = array_create(argument_count);
		for(var n = 0; n < argument_count; n++){
			_tuple[n] = array_get(argument[n], i);
		}
		_zipped_array[i] = _tuple;
	}
	return _zipped_array;
}


function array_group_by(_array, _key_selector) {
	/*
	returns a ds_map where each group key is associated with a list of corresponding elements
	*/
	
	var _map = ds_map_create();
	
	for(var i = 0; i < array_length(_array); i++){
		var _key = _key_selector(_array[i]);
		if(!ds_map_exists(_map, _key)){
			ds_map_add_list(_map, _key, ds_list_create());
		}
		ds_list_add(_map[?_key], _array[i]);
	}
	return _map;
}


function array_filter(_array, _fun) {
	var _out = array_create(array_length(_array));
	var n = 0;
	for(var i = 0; i < array_length(_array); i++){
		if(_fun(_array[i])){
			_out[n++] = _array[i];
		}
	}
	array_resize(_out, n);
	return _out;
}


function array_min(_array) {
	var _min = _array[0];
	for(var i = 1; i < array_length(_array); i++){
		_min = min(_array[i], _min);
	}
	return _min;
}


function array_max(_array) {
	var _min = _array[0];
	for(var i = 1; i < array_length(_array); i++){
		_min = max(_array[i], _min);
	}
	return _min;
}


