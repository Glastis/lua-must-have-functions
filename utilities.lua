--
-- User: glastis
-- Date: 01/11/17
-- Time: 14:51
--

local file = require('common.file')

local utilities = {}

--[[
---- Remove spaces from string (before first and after last word)
--]]
local function trim(str)
    return str:gsub("^%s+", ""):gsub("%s+$", "")
end
utilities.trim = trim


--[[
----  Return the index of the first elem found in array
--]]
local function get_elem_in_table(table, elem)
    local i

    i = 1
    while i <= #table do
        if table[i] == elem then
            return i
        end
        i = i + 1
    end
    return false
end
utilities.get_elem_in_table = get_elem_in_table

--[[
---- Concatenate two arrays, add t2 elems after t1 ones, at same depth.
--]]
local function concatenate_arrays(t1, t2)
    local i

    i = 1
    while i <= #t2 do
        t1[#t1 + 1] = t2[i]
        i = i + 1
    end
    return t1
end
utilities.concatenate_arrays = concatenate_arrays

--[[
---- Split a string into a table of elements, in a same way as bash awk
--]]
local function split(str, separator)
    local t = {}
    local i

    i = 1
    for line in string.gmatch(str, "([^" .. separator .. "]+)") do
        t[i] = line
        i = i + 1
    end
    return t
end
utilities.split = split

--[[
---- Execute a table of functions with parameters provided. Params must have the same index that actions, params can be nil.
----
---- Args:  `actions`       table (eg: actions[1] = print).
----        `args`          table (eg: args[1] = "Hello world"), can be nil, and can contain nil elems.
--]]
local function exec_function_table(actions, param)
    local i

    i = 1
    if not param then
        param = {}
    end
    while i <= #actions do
        actions[i](param[i])
        i = i + 1
    end
end
utilities.exec_function_table = exec_function_table

--[[
---- Same as before but begins by the end of function table.
--]]
local function exec_function_table_revert(actions, param)
    local i

    i = #actions
    if not param then
        param = {}
    end
    while i > 0 do
        actions[i](param[i])
        i = i - 1
    end
end
utilities.exec_function_table_revert = exec_function_table_revert

--[[
---- Write calltrace into a log file
----
---- Args:  `more`          string (eg: "in buggy_function main loop"), can be nil.
----        `calltrace`     boolean, if true will write the calltrace to the file.
--]]
local function debug_info(more, calltrace)
    if not more then
        more = " "
    end
    if calltrace then
        local trace

        trace = split(split(debug.traceback(), '\n')[3], '/')
        file.write("trace.log", '\n' .. trace[#trace] .. '\n' .. more .. '\n')
    else
        file.write("trace.log", more .. '\n')
    end
end
utilities.debug_info = debug_info

local function var_dump_indent(depth)
    local ret

    ret = ''
    while depth > 0 do
        ret = ret .. '  '
        depth = depth - 1
    end
    return ret
end

--[[
---- Like the php var_dump, it returns a variable (table, number, string...) in string.
----
---- Args:  `var`           variable to be dumped.
----        `printval`      boolean, if the dump should be printed, can be nil.
----        `max_depth`     integer, if provided, limit the exploration of sub-tables (in case of recursive or huge tables).
----        `cur_depth`     used by var_dump itself, leave it nil.
--]]
local function var_dump(var, printval, max_depth, cur_depth)
    if max_depth == nil then
        max_depth = 1000
    end
    if not cur_depth then
        cur_depth = 0
    end
    if type(var) == 'table' then
        local s

        s = '{ '
        for k,v in pairs(var) do
            if type(k) ~= 'number' then
                k = '"' .. k .. '"'
            end
            if max_depth > 0 then
                s = s .. '\n' .. var_dump_indent(cur_depth) .. '[' .. k .. '] = ' .. var_dump(v, false, max_depth - 1, cur_depth + 1) .. ','
            else
                s = s .. '\n' .. var_dump_indent(cur_depth) .. '[' .. k .. '] = ' .. tostring(v) .. ','
            end
        end
        if printval then
            print(tostring(s .. '\n}'))
        end
        return s .. '\n' .. var_dump_indent(cur_depth - 1) .. '} '
    end
    if printval then
        print(tostring(var))
    end
    return tostring(var)
end
utilities.var_dump = var_dump

--[[
---- Round number
----
---- Args:  `number`        number to round.
----        `decimals`      amount of digits after the decimal point.
----        `ext_abs`       if true, 0.5 will be rounded to 1, otherwise, it will be rounded to 0.
--]]
local function round(number, decimals, ext_abs)
    if ext_abs then
        ext_abs = math.floor
    else
        ext_abs = math.ceil
    end
    if not decimals then
        return ext_abs(number)
    end
    decimals = 10 ^ decimals
    return ext_abs(number * decimals) / decimals
end
utilities.round = round

return utilities