local flag = require("flag")

local version = "0.0.2"

local cli = { _version = version }

function cli.newFlag(name, alias, usage, value, required)
	return {
		name = name,
		alias = alias,
		usage = usage,
		value = value,
		required = required,
	}
end

function cli.newCommand(name, alias, usage, flags, action)
	return {
		name = name,
		alias = alias,
		usage = usage,
		flags = flags,
		action = action
	}
end

function cli.app(name, ver, author, description)
	local app = {
		name = name,
		version = ver,
		author = author,
		description = description,
		commands = {},
		flags = {}
	}

	function app.addCommands(self, ...)
		for _, v in ipairs {...} do
			if not self.commands[v.name] then
				self.commands[v.name] = v
			else
				error(string.format("duplicate command: %s", v.name))
			end
		end
	end

	function app.addFlags(self, ...)
		for _, v in ipairs {...} do
			table.insert(self.flags, v)
		end
	end

	function app.setAction(self, action)
		self.action = action
	end

	function app.run(self, args)
		local flagMap = flag.parse(self.flags, self.commands, args)

		local foundCommand
		for k, v in pairs(flagMap.commands) do
			foundCommand = true
			if self.commands[k] then
				self.commands[k].action(flagMap.flags, v)
			else
				error(string.format("unknown command: %s", k))
			end
		end

		if not foundCommand then
			if self.action then
				self.action(flagMap.flags)
			else
				self.help()
			end
		end
	end

	function app.help(self)
		local help = ""
		local lines = {}
		local longest = 0

		help = help..string.format("NAME:\n  %s", self.name or "")
		help = help..string.format("\n\nDESCRIPTION:\n  %s", self.description or "")
		help = help..string.format("\n\nVERSION:\n  %s", self.version or "")
		help = help..string.format("\n\nAUTHOR:\n  %s", self.author or "")

		help = help.."\n\nCOMMANDS:\n"


		for _, v in pairs(self.commands) do
			local l = {a = nil, b = nil}

			if v.name then
				l.a = string.format("  %s", v.name)
			end

			if v.alias then
				l.a = l.a..string.format(", %s", v.alias)
			end

			if v.usage then
				l.b = v.usage
			end

			table.insert(lines, l)
		end

		for _, line in ipairs(lines) do
				if line.a and #line.a > longest then
					longest = #line.a
			end
		end

		for _, line in ipairs(lines) do
			if line.a then
				help = help..string.format("%-"..longest.."s\t%s\n", line.a, line.b or "")
			end
		end

		help = help.."\nGLOBAL OPTIONS:\n"

		lines = {}

		for _, v in ipairs(self.flags) do
			local l = {a = nil, b = nil}

			if v.name then
				l.a = string.format("  --%s", v.name)

				if v.alias then
						l.a = l.a..string.format(', -%s', v.alias)
				end

				if v.usage then
						l.b = v.usage
				end

				if v.value then
						l.b = l.b..string.format(" (default: %s)", v.value)
				end

				table.insert(lines, l)
			end
		end

		longest = 0
		for _, line in ipairs(lines) do
				if line.a and #line.a > longest then
					longest = #line.a
			end
		end

		for _, line in ipairs(lines) do
			if line.a then
				help = help..string.format("%-"..longest.."s\t%s\n", line.a, line.b or "")
			end
		end

		print(help)
	end

	return app
end

return cli
