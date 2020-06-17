# functional-gml
Functional stuff for Game Maker Studio 2.3. Early work in progress. 
This is an attempt to add functional pipes to game maker, abstract 
iterators and common functional programming functions for all data
structures (reduce, map, filter, for_each, flatten, group_by etc).

Also, reactive streams are planned.

### Example pipe
```JavaScript
var _map = pipe(buffer_create(64, buffer_fixed, 4), FType.Buffer)
  .map(function(v, i){ return i; })
  .extend(new Iterator([1, 2, 3], FType.Array))
  .map_type(function(v){ return {id: v, name: "name"}; }, FType.Array)
  .filter(function(v){ return v.id%3 != 0; })
  .group_by(function(v){ return v.id%2 == 0; });
```

### implemented functions

Arrays
* array_for_each
* array_map
* array_flatten
* array_flat_map
* array_reduce
* array_sum
* array_mean
* array_zip
* array_group_by
* array_filter
* array_min
* array_max
