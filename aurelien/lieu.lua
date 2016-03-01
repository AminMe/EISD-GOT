dark = require("dark")

local main = dark.pipeline() -- pile d'execution
main:basic();
main:model("mdl/postag-en")


--match("Allegiance=([^\n]-")

-- Pour Houses structure
main:pattern("[#HouseTitle House #w+]")
main:pattern("[#House (Title|title) '=' .*(\n)]")
main:pattern("[#Image 'Image' '=' .*(\n)]")
main:pattern("[#Sigil 'Sigil' '=' .*(\n)]")
main:pattern("[#Words 'Words' '=' .*(\n)]")
main:pattern("[#Titles 'Titles' '=' .*(\n)]")
main:pattern("[#Seat 'Seat' '=' .*(\n)]")
main:pattern("[#Region 'Region' '=' .*(\n)]")
main:pattern("[#Lord 'Lord' '=' .*(\n)]")
main:pattern("[#Heir 'Heir' '=' .*(\n)]")
main:pattern("[#Allegiance 'Allegiance' '=' .*(\n)]")
main:pattern("[#Vassals 'Vassals' '=' .*(\n)]")
main:pattern("[#Military 'Military' '=' .*(\n)]")
main:pattern("[#Cadets 'Cadets' '=' .*(\n)]")
main:pattern("[#Age 'Age' '=' .*(\n)]")
main:pattern("[#Founder 'Founder' '=' .*(\n)]")
main:pattern("[#Weapon 'Weapon' '=' .*(\n)]")


-- Pour Location structure
main:pattern("[#LocationTitle (Title|title) '=' .*(\n)]")
main:pattern("[#Location 'Location' '=' .*(\n)]")
main:pattern("[#Type 'Type' '=' .*(\n)]")
main:pattern("[#Population 'Population' '=' .*(\n)]")
main:pattern("[#Rulers 'Rulers' '=' .*(\n)]")
main:pattern("[#Religion 'Religion' '=' .*(\n)]")
main:pattern("[#Institutions 'Institutions' '=' .*(\n)]")
main:pattern("[#Places 'Places' '=' .*(\n)]")
main:pattern("[#Founding 'Founding' '=' .*(\n)]")

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
local location = io.open("lexique_locations.txt", "w")

for fichier in os.dir("corpus/Locations/") do
	local locTitle = nil
	for line in io.lines("corpus/Locations/"..fichier) do
		line = line:gsub("(%p)"," %1 ")
		local seq = main(line)
		--seq:dump()
		--print(seq:tostring(tags))	
		if #seq["#LocationTitle"] ~= 0 then
			locTitle = gettag(seq,"#LocationTitle")
			locTitle = locTitle:gsub("Title = ","")
			locTitle = locTitle:gsub("title = ","")
			locTitle = string.lower(locTitle)
			locTitle = cleantext(locTitle)
			location:write(locTitle..'\n')
		end
	end
end

location:close()
