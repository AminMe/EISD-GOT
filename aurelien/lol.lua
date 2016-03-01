dark = require("dark")

local corpus = "La hauteur de la tour Eiffel est de 327 mètres."
--corpus = string.gsub(corpus, "(%p)"," %1 ")
corpus = corpus:gsub("(%p)"," %1 ")

local basic = dark.basic()
local lexique = dark.lexicon("#units", {"centimètres","mètres","kilomètres"})
local seq = dark.sequence(corpus)
local pat1 = dark.pattern("[#mesure #d #units ]")
local postags = dark.model("mdl/postag-fr")
-- > ( #W ) look ahead, si a la position suivante j'ai #W, si oui est-ce que je match
local pat2 = dark.pattern("[#monument #POS=DET? #POS=NNC* >( #W ) (#POS=NNC | #POS=NNP)]")

--[[seq:add("#nombre",9,9)
seq:add("#monument",5,6)--]]


local main = dark.pipeline() -- pile d'execution
main:basic();
main:lexicon("#units", {"centimètres","mètres","kilomètres"})
main:model("mdl/postag-fr")
main:pattern("[#mesure #d #units ]")
main:pattern([[
				[#monument 
				#POS=DET? #POS=NNC* >( #W ) (#POS=NNC | #POS=NNP)]
				]])
main:pattern([[
				[#info
					[#type (hauteur|longueur|largeur)]
					/^d[eu]$/ 
					[#objet #monument ] 
					(est|"était"|sera) .{,3} 
					[#valeur #mesure ]
			   ]
			]])

--local seq = main(corpus)

function gettag(seq, tag)
	local pos = seq[tag]
	if #pos == 0 then
		return ""
	end
	local deb = pos[1][1]
	local fin = pos[1][2]
	local res = {}
	for i=deb,fin do
		res[#res + 1] = seq[i].token
	end
	return table.concat(res, " ")
end

local db = {}

-- io.lines(file) si on ne specifie rien => input
for fichier in os.dir("corpus") do
	for line in io.lines("corpus/"..fichier) do
		line = line:gsub("(%p)"," %1 ")
		local seq = main(line)
		if #seq["#info"] ~= 0 then
			local typ = gettag(seq,"#type")
			local obj = gettag(seq,"#objet")
			local val = gettag(seq,"#valeur")
			if not db[obj] then
				db[obj] = {}
			end
			db[obj][typ] = val
			--print(obj,"-->",val)
		end
	end
end

print(serialize(db))


--[[basic(seq)
lexique(seq)
postags(seq)
pat1(seq)
pat2(seq)]]--

--[[local tags = {
	["#objet"] = "blue",
	["#valeur"] = "yellow",
	["#hauteur"] = "magenta",
}
-- pour debugguer
seq:dump()

print(seq:tostring(tags))
print(serialize(tags))





print(gettag(seq,"#hauteur"))
-- affiche le premier indice de la balise hauteur et la fin
print(serialize(seq["#hauteur"]))
]]--

-- renvoi un iterateur
--for idx, tok in seq:iter() do
--	print(idx,tok)
--end
