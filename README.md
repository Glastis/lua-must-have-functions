# Lua must have functions

Bundle of functions that are useful in many cases.

## Json

Got here, https://gist.github.com/tylerneylon/59f4bcf316be525b30ab

Used to convert a json string to a table or a table to string.

```lua
local json = require 'json'

json.parse(my_string) -- will return a table containing all objects
json.stringify(my_table) -- will return a printable string
```

## Utilities

Use this by adding `utilities = require 'utilities'`.

### Trim

Remove spaces from string (before first and after last word)

```lua
utilities.trim(str)
```

### Get elem in table

Return the index of the first elem found in array.

```lua
utilities.get_elem_in_table(table, elem)
```

### Concatenate arrays

Concatenate two arrays, add t2 elems after t1 ones, at same depth.

```lua
local t1 = {1, 2}
local t2 = {3, 4}

utilities.concatenate_arrays(t1, t2) -- return {1, 2, 3, 4}
```

### Split

Split a string into a table of elements, in a same way as bash awk or php explode.

```lua
local str = 'Hello world'
local separator = ' '

utilities.split(str, separator) -- return {'Hello', 'world'} 
```

### Exec function table

Execute a table of functions with parameters provided. Params must have the same index that actions, params can be nil.

Arguments:
- `actions`       table (eg: actions[1] = print).
- `args`          table (eg: args[1] = "Hello world"), can be nil, and can contain nil elems.

```lua
local actions = {print, print}
local param = {'glastis > guigur', 'Hi'}

utilities.exec_function_table(actions, param) -- will print 'glastis > guigur' and 'Hi'
utilities.exec_function_table_revert(actions, param) -- will print 'Hi' and 'glastis > guigur' 
```

### Debug info

Write calltrace into a log file, with a custom text to see which debug_info function is called.

Arguments:
- `more`          string (eg: "in buggy_function main loop"), can be nil.
- `calltrace`     boolean, if true will write the calltrace to the file.

```lua
local more = 'We are inside buggy_function, with parametter test, before the infinite loop'
local calltrace = true

utilities.debug_info(more, calltrace)
```

### Var dump
Like the php var_dump, it returns a variable (table, number, string...) in string.

Arguments:
- `var`           variable to be dumped.
- `printval`      boolean, if the dump should be printed, can be nil.
- `max_depth`     integer, if provided, limit the exploration of sub-tables (in case of recursive or huge tables).
- `cur_depth`     used by var_dump itself, leave it nil.


```lua
local var = {1, 'DooM', {'asdasd'}}

utilities.var_dump(var, true)
```

### Round

Args:
- `number`        number to round.
- `decimals`      amount of digits after the decimal point.
- `ext_abs`       if true, 0.5 will be rounded to 1, otherwise, it will be rounded to 0.

```lua
local numer = 1.1234
local decimals = 2
local ext_abs = true

utilities.round(number, decimals) -- return 1.12
utilities.round(number, decimals, ext_abs) -- return 1.12
```

## File

Use this by adding `utilities = require 'utilities'`.

### Is existing

Return true if file exists, false otherwise.

```lua
local filepath = '/home/glastis/foo.txt'

file.is_existing(filepath)
```

### Read

Read and return all file content.

```lua
local filepath = '/home/glastis/foo.txt'

file.read(filepath)
```

### Write

Write and string in file

Args:
- `filepath`      string, path to file, eg: `/home/glastis/foo.txt`
- `str`           string, content to write
- `mode`          string, `"a"` to append, `"w"` to overwrite file or `"w+"` to delete and write to file. Default is `"a"`.

```lua
file.write(filepath, str, mode)
```

### Read line

Read and return one line from a file

Args:
- `filepath`      string, path to file, eg: /home/glastis/foo.txt
- `file`          file, if nil, will open filepath.

```lua
local file, line = file.read_line('/home/glastis/foo.txt')

while file do
    print(line)
    file, line = file.read_line('/home/glastis/foo.txt')
end
```