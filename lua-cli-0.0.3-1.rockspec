rockspec_format = "3.0"
package = "lua-cli"
version = "0.0.3-1"
source = {
   url = "git+https://github.com/vanillaiice/lua-cli",
	 tag = "v0.0.3"
}
description = {
   summary = "lua-cli is a simple module to build command line interfaces in Lua.",
   homepage = "https://github.com/vanillaiice/lua-cli",
   license = "GPLv3"
}
dependencies = {
  "lua >= 5.1, < 5.5"
}
build = {
   type = "builtin",
   modules = {
      cli = "cli.lua",
      ["test.cli_test"] = "test/cli_test.lua",
   }
}
