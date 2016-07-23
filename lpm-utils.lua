local function read_file(filename)
  local f = io.open(filename)
  local contents = f:read('*a')
  f:close()
  return contents
end

local function write_file(filename, s)
  local f = io.open(filename, 'w+')
  f:write(s)
  f:close()
end

local function file_to_table(filename)
  local s = read_file(filename)
  local t = {}
  load(s, '', 't', t)()
  return t
end

local function exec(command)
  local f = io.popen(command, 'r')
  local output = f:read('*a')
  f:close()
  return output
end

local function file_exists(filename)
  local f = io.open(filename, 'r')
  local exists = f ~= nil
  if exists then f:close() end
  return exists
end

local function create_rockspec(package, destination, production)
  local quoted_dependencies = {}

  for _, dependency in ipairs(package.dependencies) do
    table.insert(quoted_dependencies, "'" .. dependency .. "'")
  end

  if not production then
    for _, dependency in ipairs(package.dev_dependencies) do
      table.insert(quoted_dependencies, "'" .. dependency .. "'")
    end
  end

  local s = [[
package = 'package'
version = 'lpm-0'
source = {
  url = '.'
}
dependencies = {]]
..
  table.concat(quoted_dependencies, ', ')
..
[[}
build = {
  type = 'builtin',
  modules = {}
}
]]

  write_file(destination, s)
end

return {
  exec = exec,
  file_to_table = file_to_table,
  file_exists = file_exists,
  create_rockspec = create_rockspec
}
