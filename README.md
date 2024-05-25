# lua-cli

lua-cli is a simple module to build command line interfaces in Lua.

It is heavily inspired by the amazing [urfave/cli](https://github.com/urfave/cli) golang package.

# Usage

Here is a minimal working example:

```lua
-- kitchen.lua

-- import the cli module
local cli = require("cli")

-- create the app
local app = cli.app("kitchen", "1.0.0", "gordon ramsay", "cook in the kitchen")

-- add global flags
app:addFlags(cli.newFlag("verbose", "v", "be verbose", false, false))

-- add commands
app:addCommands(
	cli.newCommand(
		"cook",
		"c",
		"cook something",
		{cli.newFlag("dish", "d", "dish to cook", "beef wellington", false)},
		function(globalFlags, localFlags)
			if globalFlags.verbose then
				print("[INFO]: cooking " .. localFlags.dish)
			end

			print("here is your " .. localFlags.dish .. '!')

			if globalFlags.verbose then
				print("[INFO]: enjoy!")
			end
		end
	)
)

-- run the app
app:run({"-v", "true", "cook", "-d", "ramen"})

-- in practice, you'd pass the arg table to the run function,
-- and then run it like so: lua kitchen.lua -v true cook -d ramen
app:run(arg)

print('\n')

-- print help
app:help()

--[[
NAME:
  kitchen

DESCRIPTION:
  cook in the kitchen

VERSION:
  1.0.0

AUTHOR:
  gordon ramsay

COMMANDS:
  cook, c	cook something

GLOBAL OPTIONS:
  --verbose, -v	be verbose
]]--
```

> you can also check the test directory for more examples.

# Author

vanillaiice

# License

GPLv3
