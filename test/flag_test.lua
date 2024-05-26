local flag = require("flag")
local cli = require("cli")

local function testIsFlag()
	local cases = {
		{flag = "-a", expected = {idx = 1, is = true}},
		{flag = "--a", expected = {idx = 2, is = true}},
		{flag = "--a=b", expected = {idx = 2, is = true}},
		{flag = "-a=b", expected = {idx = 1, is = true}},
		{flag = "a=b", expected = {idx = nil, is = false}},
		{flag = "a", expected = {idx = nil, is = false}},
		{flag = nil, expected = {idx = nil, is = false}}
	}

	for _, c in ipairs(cases) do
		local idx, is = flag.isFlag(c.flag)
		assert(idx == c.expected.idx, string.format("got %s want %s", idx, c.expected.idx))
		assert(is == c.expected.is, string.format("got %s want %s", is, c.expected.is))
	end
end

local function testGetFlag()
	local cases = {
		{flag = "-a", expected = "a"},
		{flag = "--a", expected = "a"},
		{flag = "--a=b", expected = "a=b"},
		{flag = "-a=b", expected = "a=b"},
		{flag = "a=b", expected = nil},
		{flag = "a", expected = nil},
		{flag = nil, expected = nil},
	}

	for _, c in ipairs(cases) do
		local got = flag.getFlag(c.flag)
		assert(got == c.expected, string.format("got %s want %s", got, c.expected))
	end
end

local function testCheckValidFlag()
	local cases = {
		{flag = "-f", expected = "foo", valid = true},
		{flag = "--foo", expected = "foo", valid = true},
		{flag = "-b", expected = "bar", valid = true},
		{flag = "--bar", expected = "bar", valid = true},
		{flag = "-q", expected = nil, valid = false},
		{flag = "--quz", expected = nil, valid = false}
	}

	local flags = {
		cli.newFlag("foo", "f", "fooing", "foobar", true),
		cli.newFlag("bar", "b", "baring", "barfoo", true),
	}

	for _, c in ipairs(cases) do
		local valid
		local fl = flag.getFlag(c.flag)
		assert(fl)

		fl, valid = flag.checkValidFlag(fl, flags)
		assert(fl == c.expected, string.format("got %s want %s for %s", fl, c.expected, c.flag))
		assert(valid == c.valid, string.format("got %s want %s for %s", valid, c.valid, c.flag))
	end
end

local function testGetArg()
	local cases = {
		{arg = "a", expected = "a"},
		{arg = "true", expected = "true"},
		{arg = "a,b,c,d", expected = {"a", "b", "c", "d"}},
		{arg = "a,1,b,2", expected = {"a", "1", "b", "2"}},
	}

	for _, c in ipairs(cases) do
		local got = flag.getArg(c.arg)
		if type(got) == "table" then
			for i, v in ipairs(got) do
				assert(v == c.expected[i], string.format("got %s want %s", v, c.expected[i]))
			end
		else
			assert(got == c.expected, string.format("got %s want %s", got, c.expected))
		end
	end
end

local main = function ()
	testIsFlag()
	testGetFlag()
	testCheckValidFlag()
	testGetArg()
end

main()
