--
-- User: Glastis
-- Date: 21/11/2017
-- Time: 06:47
--

local file = {}

--[[
---- Return true if file exists, false otherwise.
----
---- Args:  `filepath`      string, path to file, eg: /home/glastis/foo.txt
--]]
local function is_existing(filepath)
    local f

    f = io.open(filepath,"r")
    if f then
        io.close(f)
        return true
    end
    return false
end
file.is_existing = is_existing

--[[
---- Read and return all file content
----
---- Args:  `filepath`      string, path to file, eg: /home/glastis/foo.txt
--]]
local function read(filepath)
    local f
    local str

    f = io.open(filepath, 'rb')
    str = f:read('*all')
    f:close()
    return str
end
file.read = read

--[[
---- Write and string in file
----
---- Args:  `filepath`      string, path to file, eg: /home/glastis/foo.txt
----        `str`           string, content to write
----        `mode`          string, "a" to append, "w" to overwrite file or "w+" to delete and write to file. Default is "a".
--]]
local function write(filepath, str, mode)
    local f

    if not mode then
        mode = "a"
    end
    f = io.open(filepath, mode)
    f:write(str)
    f:close()
end
file.write = write

--[[
---- Read and return one line from a file
----
---- Args:  `filepath`      string, path to file, eg: /home/glastis/foo.txt
----        `file`          file, if nil, will open filepath.
----
---- Example:
----
---- local file, line = read_line('/home/glastis/foo.txt')
---- while file do
----    print(line)
----    file, line = read_line('/home/glastis/foo.txt')
---- end
--]]
local function read_line(filepath, file)
    local line

    if not file then
        file = io.open(filepath, 'rb')
    end
    line = file:read()
    if line then
        return file, line
    end
    file:close()
    return nil
end
file.read_line = read_line

return file