# lpm
Fiddling around with Lua application management in an `npm`-style. Goals are to (easily) maintain locally-scoped dependencies and automatically select the correct Lua version. Requires [`lenv`](https://github.com/mah0x211/lenv) to be installed and on the path.

## Installation
To install, copy `lpm`, `lpm.lua`, and `lpm-utils.lua` to your favorite folder and add that folder to your path.

## Commands
### Install
Install the version of Lua and the dependencies listed in [`package.lua`](#package-definition). Installs all dependencies in `./lua_modules`.

```shell
lpm install
```

### Clean
Remove all installed dependencies by deleting `./lua_modules`.

```shell
lpm clean
```

### Run
Run commands in the project context.

```shell
lpm run <command>
```

## Package Definition
The package file (`package.lua`) includes the project name, Lua version, and a list of Luarocks dependencies.

```
name = 'cool-test-project'
lua = '5.3.2'
dependencies = {
  'lua == 5.3',
  'mach >= 3.0-1',
  'busted >= 2.0.rc11-0'
}
```

## Sample Project
Install and run automated tests for the sample project with:

```shell
./lpm install; ./lpm run busted
```
