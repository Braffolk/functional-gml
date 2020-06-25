function PerformanceTest(_title, _methods) constructor {
	
	title	= _title;
	methods	= _methods;
	
	static run = function(_steps) {
		
		var _results = array_create(array_length(methods), 0);
		var _baseline_function = function() {}
		
		for(var i = 0; i < _steps; i++) {
			for(var j = 0; j < array_length(methods); j++) {
				var _time, _time_baseline;
				var _method = methods[j];
				
				// establish baseline
				_time = get_timer();
				_baseline_function();
				_time_baseline = get_timer() - _time;
				
				// calculate function time
				_time = get_timer();
				_method();
				_time = get_timer() - _time - _time_baseline;
				_results[j] += _time;
			}
		}
		
		for(var j = 0; j < array_length(methods); j++) {
			_results[j] /= _steps;
		}
		
		return _results;
	}
}

function log() {
	var out = "";
	for(var i = 0; i < argument_count; i++){
		out += string(argument[i]) + " ";
	}
	show_debug_message(out);
}

function array_to_list(_array) {
	var l = ds_list_create();
	for(var i = 0; i < array_length(_array); i++){
		ds_list_add(l,  _array[ i ]);
	}
	return l;
}

function list_to_array(_list) {
	var _ar = array_create(ds_list_size(_list));
	for(var i = 0; i < ds_list_size(_list); i++){
		_ar[i] = _list[| i ];
	}
	return _ar;
}