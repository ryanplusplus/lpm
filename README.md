# lpm
Fiddling around with Lua application management in an `npm`-style. Goals are to (easily) maintain locally-scoped dependencies and automatically select the correct Lua version. Requires [`lenv`](https://github.com/mah0x211/lenv) to be installed and on the path.

## Installation
To install, copy `lpm`, `lpm.lua`, and `lpm-utils.lua` to your favorite folder and add that folder to your path.

## Commands
### install
Install the version of Lua, the dependencies, and the dev dependencies listed in [`package.lua`](#package-definition). To omit dev dependencies, pass `--production`. Installs all dependencies in `./lua_modules`.

```shell
lpm install [--production]
```

### clean
Remove all installed dependencies by deleting `./lua_modules`.

```shell
lpm clean
```

### exec
Execute commands in the project context.

```shell
lpm exec <command> [arguments]
```

### run
Run scripts defined in [`package.lua`](#package-definition) in project context.

```shell
lpm run <script name> [arguments]
```

### test
Alias for `lpm run test`

```shell
lpm test
```

## Package Definition
The package file (`package.lua`) includes the project name, Lua version, project scripts, and a list of Luarocks dependencies.

```lua
name = 'cool-test-project'
lua = '5.3.2'
dependencies = {
  'lua == 5.3',
  'chain >= 1.0-1'
}
dev_dependencies = {
  'mach >= 4.4-1',
  'busted >= 2.0.rc11-0'
}
scripts = {
  test = 'busted'
}
```

## Sample Project
Install and run automated tests for the sample project with:

```shell
./lpm install; ./lpm run test
```
