local cli = require("../cli")

local app = cli.app("Cool Cars", "0.0.1", "vanillaiice", "play with cool cars")

app:addFlags(
	cli.newFlag("make", "m", "make of the car", "toyota", true),
	cli.newFlag("model", "o", "model of the car", "MR2", true),
	cli.newFlag("horsepower", "h", "car horsepower", 140, true),
	cli.newFlag("drivers", "d", "name of drivers", "Ken Kogashiwa, Kai Kogashiwa", true),
	cli.newFlag("engine-specs", "e", "car engine specifications", "1.8 NA", false),
	cli.newFlag("kilometers", "k", "kilometers on odometer", nil, false)
)

app:addCommands(
	cli.newCommand("rev", "r", "make the car rev", {cli.newFlag("sound", "s", "sound of the car", "VOOOOO", false)}, function(globalFlagMap, localFlagMap)
		assert(globalFlagMap.make == "subaru", string.format("got %s want %s", globalFlagMap.make, "subaru"))
		assert(globalFlagMap.model == "wrx sti", string.format("got %s want %s", globalFlagMap.model, "wrx sti"))
		assert(globalFlagMap.horsepower == 300, string.format("got %s want %s", globalFlagMap.horsepower, 300))
		assert(globalFlagMap.drivers[1] == "Bunta Fujiwara", string.format("got %s want %s", globalFlagMap.drivers[1], "Bunta Fujiwara"))
		assert(globalFlagMap.drivers[2] == "Takumi Fujiwara", string.format("got %s want %s", globalFlagMap.drivers[2], "Takumi Fujiwara"))
		assert(globalFlagMap["engine-specs"] == nil, string.format("got %s want %s", globalFlagMap["engine-specs"], nil))
		assert(localFlagMap.sound == "STUSTUSTU", string.format("got %s want %s", localFlagMap.sound, "STUSTUSTU"))
	end),
	cli.newCommand("full-send", "f", "full send the car", {}, function() assert(true) end)
)

app:setAction(function(flagMap)
	assert(flagMap.make == "subaru", string.format("got %s want %s", flagMap.make, "subaru"))
	assert(flagMap.model == "wrx sti", string.format("got %s want %s", flagMap.model, "wrx sti"))
	assert(flagMap.horsepower == 300, string.format("got %s want %s", flagMap.horsepower, 300))
	assert(flagMap.drivers[1] == "Bunta Fujiwara", string.format("got %s want %s", flagMap.drivers[1], "Bunta Fujiwara"))
	assert(flagMap.drivers[2] == "Takumi Fujiwara", string.format("got %s want %s", flagMap.drivers[2], "Takumi Fujiwara"))
	assert(flagMap["engine-specs"] == nil, string.format("got %s want %s", flagMap["engine-specs"], nil))
end)

app:run({"--make", "subaru", "-o", "wrx sti", "-h", 300, "--drivers", "Bunta Fujiwara,Takumi Fujiwara", "rev", "-s", "STUSTUSTU", "full-send"})

app:run({"--make", "subaru", "-o", "wrx sti", "-h", 300, "--drivers", "Bunta Fujiwara,Takumi Fujiwara"})

app:help()
