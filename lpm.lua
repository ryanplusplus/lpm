package.path = debug.getinfo(1, 'S').source:match([[^@?(.*[\/])[^\/]-$]]) .. '?.lua;' .. package.path

local lpm_version = '0.1'

local utils = require 'lpm-utils'

local command = arg[1]
local args = (function(command, ...) return table.pack(...) end)(table.unpack(arg))

local function with_package(thunk)
  return function(args)
    local package = utils.file_to_table('package.lua')
    local home = utils.exec('echo $HOME'):match('([^\n]*)')
    local version = package.lua
    local short_version = version:match('(%d.%d)')
    local bin = home .. '/.lenv/lua/' .. version .. '/bin'
    local lua = bin .. '/lua'
    local luarocks = bin .. '/luarocks'

    if not utils.file_exists(lua) then
      os.execute('lenv fetch')
      os.execute('lenv install ' .. version)
    end

    thunk(args, {
      bin = bin,
      luarocks = luarocks,
      package = package,
      short_version = short_version
    })
  end
end

local exec = function(args, env)
  local cmd =
    [[export PATH="]] .. env.bin .. [[:./lua_modules/bin:$PATH";]] ..
    [[export LUA_PATH='./?.lua;./lua_modules/share/lua/]] .. env.short_version .. [[/?.lua;./lua_modules/share/lua/]] .. env.short_version .. [[/?/init.lua';]] ..
    [[export LUA_CPATH='./?.so;./lua_modules/lib/lua/]] .. env.short_version .. [[/?.so;./lua_modules/lib/lua/]] .. env.short_version .. [[/loadall.so;./?.so;';]] ..
    table.concat(args, ' ')
  os.execute(cmd)
end

(setmetatable({
  install = with_package(function(args, env)
    os.execute('mkdir -p lua_modules')
    utils.create_rockspec(env.package, 'lua_modules/package-lpm-0.rockspec', args[1] == '--production')
    os.execute('export PATH=' .. env.bin .. ':$PATH; ' .. env.luarocks .. ' install lua_modules/package-lpm-0.rockspec --tree=./lua_modules')
  end),

  clean = function()
    os.execute('rm -rf lua_modules')
  end,

  exec = with_package(exec),

  run = function(args)
    with_package(function(args, env)
      args[1] = env.package.scripts[args[1]]
      exec(args, env)
    end)(args)
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

lpm exec
  Execute commands in the context of the project in the current directory.

lpm run
  Run scripts in the context of the project in the current directory.
]])
  end
}, { __index = function(t) return t.help end }))[command](args)
