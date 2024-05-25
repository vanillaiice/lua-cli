local flag = require("flag")

local cases = {
	{"--make", "toyota"},
	{"-m", "honda"},
	{"--horse-power", "300"},
	{"-h", 150},
	{"--model", "wrx sti"},
	{"--engine-specs", "2.0 Turbocharged"}
}

local want = {
	make = "toyota",
	m = "honda",
	["horse-power"] = "300",
	h = 150,
	model = "wrx sti",
	["engine-specs"] = "2.0 Turbocharged"
}

for _, case in ipairs(cases) do
	--[[
		local got = flag.parse(case)
		print("got")
		for k, v in pairs(got) do
			assert(want[k]==v, "got "..v..", want "..want[k])
			print("case passed for "..k.." "..v)
		end
	--]]
end
