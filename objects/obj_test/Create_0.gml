
log()
log("RUNNING TESTS:")

function assert(_bool, _message) {
	if(is_undefined(_message)){
		_message = "assertion failed";
	}
	if(!_bool) { throw(_message); }
}

var tests = [

	// PIPE TESTS
	[
		function() {
			var _pipe = pipe([], FType.Array);
			delete _pipe;
		}, 
		true, 
		"simple pipe array successfully created", 
		"couldnt create simple pipe array"
	],
	[
		function() {
			var _pipe = pipe([1, 2, 3], FType.Array).map(function(v){return v + 1;});
			assert(array_equals(_pipe.data(), [2, 3, 4]));
			delete _pipe;
		}, 
		true, 
		"pipe map successful", 
		"failed to map pipe"
	],
	[
		function() {
			var _pipe = pipe([[1, 2], [3, 4]], FType.Array).flat_map(function(v){ return v + 1; });
			assert(array_equals(_pipe.data(), [2, 3, 4, 5]));
			delete _pipe;
		}, 
		true, 
		"pipe flatmap successful", 
		"failed to flatmap pipe"
	],
	[
		function() {
			var _pipe = pipe([[1, 2], [3, 4]], FType.Array).flatten();
			assert(array_equals(_pipe.data(), [1, 2, 3, 4]));
			delete _pipe;
		}, 
		true, 
		"pipe flatten successful", 
		"failed to flatten pipe"
	],
	[
		function() {
			var v = pipe([1, 2, 3, 4], FType.Array).reduce(function(l, r){return l + r;}, 0);
			assert(v == 10);
		}, 
		true, 
		"pipe reduce sum successful", 
		"failed to get sum of pipe using reduce"
	],
	[
		function() {
			var i1 = new Iterator([1, 2], FType.Array);
			var i2 = new Iterator(["a", "b", "c"], FType.Array);
			var _result = iterator_zip(i1, i2);
			
			assert(array_equals(_result.data(), [[1, "a"], [2, "b"]]));
		}, 
		true, 
		"iterator zip successful", 
		"failed to zip iterators"
	],
	[
		function() {
			var _pipe = pipe([1, 2], FType.Array);
			var _it = new Iterator([2, 3], FType.Array);
			_pipe.extend(_it);
			assert(array_equals(
				_pipe.data(),
				[1, 2, 2, 3]
			), "found " + string(_pipe.data()));
		}, 
		true, 
		"pipe extend successful", 
		"pipe extend failed"
	],
	[
		function() {
			var _pipe = pipe([1, 2, 3, 4], FType.Array).filter(function(v){return v%2 == 0;});
			assert(array_equals(
				_pipe.data(),
				[2, 4]
			));
		}, 
		true, 
		"pipe filter successful", 
		"pipe filter failed"
	],
	[
		function() {
			var _map = pipe([1, 2, 3, 4], FType.Array).group_by(function(v){return v%2 == 0;});
			assert(array_equals(_map[? 0 ].data(), [1, 3]));
			assert(array_equals(_map[? 1 ].data(), [2, 4]));
		}, 
		true, 
		"pipe group by successful", 
		"pipe group by failed"
	],
	[
		function() {
			
			/*Buffer support not yet implemented! To-DO*/
			/*var _map = pipe(buffer_create(64, buffer_fixed, 4), FType.Buffer)
				.map(function(v, i){ return i; })
				.extend(new Iterator([64, 65, 66], FType.Array))
				.map_type(function(v){ return {id: v, name: "name"}; }, FType.Array)
				.filter(function(v){ return v.id%3 != 0; })
				.group_by(function(v){ return v.id%2 == 0; });*/
			
		},
		true, 
		"pipe complex successful", 
		"pipe complex failed"
	],
	[function() {}, true, "", ""],
	
	
	
	
	
	// ARRAY TESTS
	[
		function() {
			assert(array_equals(
				array_map([1, 2], function(v){ return v + 1; }),
				[2, 3]
			));
		}, 
		true, 
		"array_map successful", 
		"array_map failed"
	],
	[
		function() {
			assert(array_equals(
				array_flatten([[1, 2], [3, 4]]),
				[1, 2, 3, 4]
			));
		}, 
		true, 
		"array_flatten successful", 
		"array_flatten failed"
	],
	[
		function() {
			assert(array_equals(
				array_flat_map([[1, 2], [3, 4]], function(v){return v+1;}),
				[2, 3, 4, 5]
			));
		}, 
		true, 
		"array_flat_map successful", 
		"array_flat_map failed"
	],
	[
		function() {
			assert(
				array_reduce([1, 2, 3], function(l, r){return l+r;}, 0) == 6
			);
		}, 
		true, 
		"array_reduce successful", 
		"array_reduce failed"
	],
	[
		function() {
			assert(array_sum([2, 3]) == 5);
		}, 
		true, 
		"array_sum successful", 
		"array_sum failed"
	],
	[
		function() {
			assert(array_equals(
				array_zip([1, 2], ["a", "b"]),
				[[1, "a"], [2, "b"]]
			));
		}, 
		true, 
		"array_zip with two arrays successful", 
		"array_zip with two arrays failed"
	],
	[
		function() {
			assert(array_equals(
				array_zip([1, 2], ["a", "b"], ["x", "y"]),
				[[1, "a", "x"], [2, "b", "y"]]
			));
		}, 
		true, 
		"array_zip with three arrays successful", 
		"array_zip with three arrays failed"
	],
	[
		function() {
			var _map = array_group_by([{a: 0}, {a: 1}, {a: 0}, {a: 1}], function(item){return item.a; })
			assert(ds_map_size(_map) == 2, "groupby map size must be 2!");
			assert(ds_map_exists(_map, 0), "key 0 not found in map");
			assert(ds_map_exists(_map, 1), "key 1 not found in map");
		}, 
		true, 
		"array_group_by successful", 
		"array_group_by failed"
	],
	[
		function() {
			assert(array_equals(
				array_filter([1,2,3,4], function(v){return v%2 == 0;}),
				[2, 4]
			));
		}, 
		true, 
		"array_filter successful", 
		"array_filter failed"
	],
	[
		function() {
			assert(array_min([3, 1, 2]) == 1);
		}, 
		true, 
		"array_min successful", 
		"array_min failed"
	],
	[
		function() {
			assert(array_max([3, 1, 2]) == 3);
		}, 
		true, 
		"array_max successful", 
		"array_max failed"
	],
]




successful_tests = 0;

for(var i = 0; i < array_length(tests); i++){
	var _args = tests[i]
	var _fun = _args[0];
	var _error_not_expected = _args[1];
	var _success_message = _args[2];
	var _failure_message = _args[3];
	
	try {
		_fun()
		if(!_error_not_expected) {
			log("FAILURE:", _failure_message)
		} else {
			log("SUCCESS:", _success_message)
			successful_tests += 1;
		}
	} catch( _ex) {
		if(_error_not_expected) {
			log("FAILURE:", _failure_message, "exception:", string(_ex))
		} else {
			log("SUCCESS:", _success_message, "exception:", string(_ex))
			successful_tests += 1;
		}
	}
	
}

log(successful_tests, "/", array_length(tests), "TESTS WERE SUCCESSFUL");
log();






// performance tests
log("RUNNING PERFORMANCE TESTS")


global.ar = array_create(100, 0);
global.it = pipe(array_create(100, 0), FType.Array);


var _performance_tests = [
	new PerformanceTest(
		"iterate array vs iterate array pipe of length 100",
		[
			function() {
				for(var i = 0; i < array_length(global.ar); i++){
					var _ = global.ar[i];
				}
			},
			function() {
				global.it.for_each(function(v){var _ = v;})
			}
		]
	),
	new PerformanceTest(
		"map array vs map array pipe of length 100",
		[
			function() {
				for(var i = 0; i < array_length(global.ar); i++;){
					global.ar[i] = 0;
				}
			},
			function() {
				global.it.map(function(v){return 0;})
			}
		]
	)
];


array_for_each(_performance_tests, function(_test) {
	var _steps = 10000;
	var _results = _test.run(_steps);
	
	log("TEST:", _test.title, ", running", _steps, "times");
	
	array_for_each(_results, function(_result, i) {
		log(i, "took", (_result), "microseconds per one run, ops/sec:", 1000000/_result);
	});
	
	log();
});