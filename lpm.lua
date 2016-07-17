package.path = debug.getinfo(1, 'S').source:match([[^@?(.*[\/])[^\/]-$]]) .. '?.lua;' .. package.path

local lpm_version = '0.1'

local utils = require 'lpm-utils'

local command = arg[1]
local args = (function(command, ...) return table.pack(...) end)(table.unpack(arg))

local package = utils.file_to_table('package.lua')
local home = utils.exec('echo $HOME'):match('([^\n]*)')
local version = package.lua
local short_version = version:match('(%d.%d)')
local bin = home .. '/.lenv/lua/' .. version .. '/bin'
local lua = bin .. '/lua'
local luarocks = bin .. '/luarocks'

if not utils.file_exists(lua) then
  os.execute('lenv install ' .. version)
end

(setmetatable({
  install = function()
    os.execute('mkdir -p lua_modules')
    utils.create_rockspec(package, 'lua_modules/package-lpm-0.rockspec')
    os.execute('export PATH=' .. bin .. ':$PATH; ' .. luarocks .. ' install lua_modules/package-lpm-0.rockspec --tree=./lua_modules')
  end,

  clean = function()
    os.execute('rm -rf lua_modules')
  end,

  run = function(args)
    local cmd =
      [[export PATH="]] .. bin .. [[:./lua_modules/bin:$PATH";]] ..
      [[export LUA_PATH='./lua_modules/share/lua/]] .. short_version .. [[/?.lua;./lua_modules/share/lua/]] .. short_version .. [[/?/init.lua';]] ..
      [[export LUA_CPATH='./lua_modules/lib/lua/]] .. short_version .. [[/?.so;./lua_modules/lib/lua/]] .. short_version .. [[/loadall.so;./?.so;';]] ..
      table.concat(args, ' ')
    os.execute(cmd)
  end,

  version = function()
    print(lpm_version)
  end,

  help = function()
    print([[

lpm ]] .. lpm_version .. [[


lpm install
  Install Lua and all dependencies for the project in the current directory.

lpm clean
  Uninstall all dependencies for the project in the current directory.

lpm run
  Run a commands in the context of the project in the current directory.
]])
  end
}, { __index = function(t) return t.help end }))[command](args)
