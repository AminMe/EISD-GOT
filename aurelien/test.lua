dark = require("dark")

local main = dark.pipeline() -- pile d'execution
main:basic();
--main:lexicon("#cigle", "cigles.txt")
--main:lexicon("#parti", "partis.txt")
main:lexicon("#fonction", {"Président", "président", "Ministre", "ministre", "secrétaire", "Secrétaire"})
main:model("mdl/postag-fr")

main:pattern("[#homme 'il']")
main:pattern("[#femme 'elle']")
main:pattern([[
				[#prenom (#POS=NNP | #POS=NNC | #POS=NNP #POS=NNP #POS=NNP)]
				[#nom (#POS=NNP #POS=NNP | #POS=NNP | #POS=ADP? >( #W ) (#POS=NNC | #POS=NNP))]
				(#POS=VRB #POS=VRB #POS=DET)
				[#naissance #d#p#d#p#d]
				("." (Si #femme |  S "'" #homme) devient "président" de la "république" en 2007 "," (il | elle) aura)
				[#ageDebut #d ans]
				(au "début" de son mandat "," et)
				[#ageFin #d ans]
				("à" la fin "," en 2012 ".")
			  ]
		]])

main:pattern("[#personne #prenom #nom]")

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

local tags = {
	--[["#prenom"] = "red",
	["#nom"] = "green",
	["#naissance"] = "cyan",
	["#personne"] = "yellow",
	["#parti"] = "magenta",
	["#cigle"] = "blue",]]--
	["#homme"] = "blue",
	["#femme"] = "green",
}

for fichier in os.dir("corpus") do
	local parti = nil
	local cigle = nil	
	local fonction
	for line in io.lines("corpus/"..fichier) do
		line = line:gsub("(%p)"," %1 ")
		local seq = main(line)
		seq:dump()
		--print(seq:tostring(tags))
		if #seq["#personne"] ~= 0 then
			personne = gettag(seq,"#personne")
			local prenom = gettag(seq,"#prenom")
			local nom = gettag(seq,"#nom")
			local naissance = gettag(seq,"#naissance")
			local ageDebut = gettag(seq,"#ageDebut")
			local ageFin = gettag(seq,"#ageFin")
			if not db[personne] then
				db[personne] = {}
			end
			if #seq["#nom"] ~= 0 then
				db[personne]["nom"] = nom
			end
			if #seq["#prenom"] ~= 0 then
				db[personne]["prenom"] = prenom
			end
			if #seq["#homme"] ~= 0 then
				db[personne]["sexe"] = "M"
			else
				db[personne]["sexe"] = "F"
			end
			if #seq["#naissance"] ~= 0 then
				db[personne]["naissance"] = naissance
			end
			if #seq["#ageDebut"] ~= 0 then
				db[personne]["ageDebut"] = ageDebut
			end
			if #seq["#ageFin"] ~= 0 then
				db[personne]["ageFin"] = ageFin
			end
		end
		if #seq["#parti"] ~= 0 then
			if (parti == nil) then
				parti = gettag(seq,"#parti")
				db[personne]["parti"] = parti
			end
		end
		if #seq["#cigle"] ~= 0 then
			if (cigle == nil) then
				cigle = gettag(seq,"#cigle")
				db[personne]["cigle parti"] = cigle
			end
		end
		if #seq["#fonction"] ~= 0 then
			if #seq["#personne"] == 0 then
				if (fonction == nil) then
					fonction = gettag(seq,"#fonction")
				else
					fonction = (fonction .. ", " .. gettag(seq,"#fonction"))
				end
				db[personne]["fonction"] = fonction
			end
		end	
	end
end

local out = io.open("db.txt", "w")
out:write("return ")
out:write(serialize(db))
out:close()

local db2 = dofile("db.txt")

--print(serialize(db2))
