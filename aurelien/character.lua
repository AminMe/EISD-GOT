dark = require("dark")

local main = dark.pipeline() -- pile d'execution
main:basic();
main:model("mdl/postag-en")


--match("Allegiance=([^\n]-")

-- Pour Houses structure
main:pattern("[#Character (Title|title) '=' .*(\n)]")


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

function cleantext(string)
	
	string = string:gsub("%[ %[ File : (.-) ] ]","")
	string = string:gsub("]","")
	string = string:gsub("%[ ","")
	string = string:gsub("' ' '","")
	--string = string:gsub(" ' ' '","")
	string = string:gsub("< br / >", ",")
	string = string:gsub("/", "")
	string = string:gsub(" < br >",";")
	string = string:gsub("  < small >","")
	string = string:gsub(" < / small >","")
	string = string:gsub("}","")
	string = string:gsub("<ref>","")

	return string
end

local db = {}

local tags = {
	["#LocationTitle"] = "red",
	["#Location"] = "cyan",
	["#TitleValue"] = "red",
	["#Image"] = "yellow",	
	["#Type"] = "magenta",
	["#Population"] = "green",
	["#Rulers"] = "blue",
	["#Religion"] = "red",
	["#Institutions"] = "cyan",	
	["#Places"] = "red",
	["#Founding"] = "yellow",
}

local db = {}
local out = io.open("lexique_character.txt", "w")

for fichier in os.dir("corpus/Characters/") do
	local charact = nil
	for line in io.lines("corpus/Characters/"..fichier) do
		line = line:gsub("(%p)"," %1 ")
		local seq = main(line)
		--seq:dump()
		--print(seq:tostring(tags))	
		if #seq["#Character"] ~= 0 then
			charact = gettag(seq,"#Character")
			charact = charact:gsub("Title = ","")
			charact = charact:gsub("title = ","")
			charact = string.lower(charact)
			charact = cleantext(charact)
			out:write(charact..'\n')
		end
	end
end

out:close()
