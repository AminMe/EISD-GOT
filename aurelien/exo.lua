dark = require("dark")

local corpus = "La hauteur de la tour Eiffel est de 327 mètres."
corpus = string.gsub(corpus, "(%p)", " %1 ")

local basic = dark.basic()

local seq = dark.sequence(corpus)

basic(seq)

seq:dump()

local tags = {
	["#w"] = "yellow",
	["#d"] = "green",
}

print(seq:tostring(tags))
