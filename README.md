# lpm
Lua application management in an `npm` style. Goals are to (easily) maintain locally-scoped dependencies and automatically select the correct Lua version. Requires [`lenv`](https://github.com/mah0x211/lenv) to be installed and on the path.

## Installation
To install, copy `lpm`, `lpm.lua`, and `lpm-utils.lua` to your favorite folder and add that folder to your path.

## Commands
### install
Install the version of Lua, the dependencies, and the dev dependencies listed in [`package.lua`](#package-definition). To omit dev dependencies, pass `--production`. Installs all dependencies in `./lua_modules`.

```shell
lpm install [--production]
```

```shell
lpm i [--production]
```

### clean
Remove all installed dependencies by deleting `./lua_modules`.

```shell
lpm clean
```

```shell
lpm c
```

### exec
Execute commands in the project context.

```shell
lpm exec <command> [arguments]
```

```shell
lpm e <command> [arguments]
```

### run
Run scripts defined in [`package.lua`](#package-definition) in project context.

```shell
lpm run <script name> [arguments]
```

```shell
lpm r <script name> [arguments]
```

### test
Alias for `lpm run test`.

```shell
lpm test
```

```shell
lpm t
```

### version
Show the version.

```shell
lpm version
```

```shell
lpm v
```

## Package Definition
The package file (`package.lua`) includes a specification for your package and instructions for `lpm`:

```lua
-- The package's name
name = 'cool-test-project'

-- Version of Lua installed via `lenv` during package installation
lua = '5.3.2'

-- LuaRocks modules required by the package during runtime
dependencies = {
  'lua == 5.3',
  'chain == 1.0-1'
}

-- LuaRocks modules required for development of the package
-- These are omitted when installed with `--production`
dev_dependencies = {
  'mach >= 4.4-1',
  'busted >= 2.0.rc11-0'
}

-- Scripts that can be run with `lpm run`
scripts = {
  test = 'busted',
  demo = [[lua -e "require 'src.test'(print)"]]
}
```

## Sample Project
Install and run automated tests for the sample project with:

```shell
./lpm i; ./lpm t
```
