local flag = {}

local isFlag = function (fl)
	if not fl then
		return nil, false
	end

  local _, i = string.find(fl, "^%-%-")

	if i then
		return i, i > 0
	else
		_, i = string.find(fl, "^%-")
		if i then
			return i, i > 0
		else
			return nil, false
		end
	end
end

local getFlag = function (fl)
	if not fl then
		return nil, false
	end

	local i, is = isFlag(fl)
	if is then
		return string.sub(fl, i + 1)
	else
		return nil
	end
end

local checkFlag = function (fl, flags)
	local match
	if #fl == 1 then
		for _, v in pairs(flags) do
			if v.alias == fl then
				return v.name, true
			end
		end
	else
		for _, v in pairs(flags) do
			if v.name == fl then
				return fl, true
			end
		end
	end

	if not match then
		return nil, false
	end
end

local getArg = function (arg)
	local _, is = isFlag(arg)
	if is then
		return nil
	end

	if string.find(arg, ",") then
		local args = {}

		for a in arg:gmatch("([^,]+)") do
			table.insert(args, a)
		end

		return args
	else
		return arg
	end
end

function flag.parse(flags, commands, args)
	local flagMap = {flags = {}, commands = {}}

	local foundFirstCommand, match
	local currentCmd
	local idx = 1

	while idx <= #args do
		local _, is = isFlag(args[idx])
		if is then
			local fl, arg = getFlag(args[idx]), getArg(args[idx+1])

			if not foundFirstCommand then
				if fl and arg then
					fl, match = checkFlag(fl, flags)
					if not match then
						error(string.format("unknown flag: %s", args[idx]))
					end

					if fl then
						flagMap.flags[fl] = arg
					end
				else
					error(string.format("error parsing: %s - %s", args[idx], args[idx]))
				end
			else
				if fl and arg then
					fl, match = checkFlag(fl, commands[currentCmd].flags)
					if not match then
						error(string.format("unknown flag: %s", args[idx]))
					end

					if fl then
						flagMap.commands[currentCmd][fl] = arg
					end
				else
					error(string.format("error parsing: %s - %s", args[idx], args[idx]))
				end
			end

			idx = idx + 1
		else
			foundFirstCommand = true
			currentCmd = args[idx]
			flagMap.commands[currentCmd] = {}
		end

		idx = idx + 1
	end

	for _, v in ipairs(flags) do
		if not flagMap[v.name] and v.required then
			if v.value ~= nil then
				flagMap[v.name] = v.value
			else
				error("required flag missing: "..v.name)
			end
		end
	end

	for k, v in pairs(flagMap.commands) do
		for _, c in pairs(v) do
			if not flagMap.commands[k][c.name] and c.required then
				if c.value ~= nil then
					flagMap.commands[k][c.name] = c.value
				else
					error("required flag missing: "..c.name)
				end
			end
		end
	end

	return flagMap
end

return flag
