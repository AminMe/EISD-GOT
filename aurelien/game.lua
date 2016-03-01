dark = require("dark")

local main = dark.pipeline() -- pile d'execution
main:basic();
main:model("mdl/postag-en")


--match("Allegiance=([^\n]-")

-- Pour Houses structure
main:pattern("[#HouseTitle House #w+]")
main:pattern("[#House 'Title' '=' .*(\n)]")
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
main:pattern("[#LocationTitle 'Title' '=' .*(\n)]")
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

for fichier in os.dir("got/Tableau/Houses/") do
	local house = nil
	for line in io.lines("got/Tableau/Houses/"..fichier) do
		line = line:gsub("(%p)"," %1 ")
		local seq = main(line)
		--seq:dump()
		--print(seq:tostring(tags))	
		if #seq["#House"] ~= 0 then
			house = gettag(seq,"#House")
			house = house:gsub("Title =","")
			house = cleantext(house)
			if not db[house] then
				db[house] = {}
			end
		end
		if #seq["#Image"] ~= 0 then
			local image = gettag(seq,"#Image")
			image = image:gsub("Image =","")
			image = cleantext(image)
			db[house]["Image"] = image
		end
		if #seq["#Sigil"] ~= 0 then
			local sigil = gettag(seq,"#Sigil")
			sigil = sigil:gsub("Sigil =","")
			sigil = cleantext(sigil)
			db[house]["Sigil"] = sigil
		end
		if #seq["#Words"] ~= 0 then
			local words = gettag(seq,"#Words")
			words = words:gsub("Words =", "")
			words = cleantext(words)
			db[house]["Words"] = words
		end
		if #seq["#Titles"] ~= 0 then
			local titles = gettag(seq,"#Titles")
			titles = titles:gsub("Titles =", "")
			titles = cleantext(titles)
			db[house]["Titles"] = titles
		end
		if #seq["#Seat"] ~= 0 then
			local seat = gettag(seq,"#Seat")
			seat = seat:gsub("Seat =","")
			seat = cleantext(seat)
			db[house]["Seat"] = seat
		end
		if #seq["#Region"] ~= 0 then
			local region = gettag(seq,"#Region")
			region = region:gsub("Region =", "")
			region = cleantext(region)
			db[house]["Region"] = region
		end
		if #seq["#Lord"] ~= 0 then
			local lord = gettag(seq,"#Lord")
			lord = lord:gsub("Lord =", "")
			lord = cleantext(lord)
			db[house]["Lord"] = lord
		end
		if #seq["#Heir"] ~= 0 then
			local heir = gettag(seq,"#Heir")
			heir = heir:gsub("Heir =", "")
			heir = cleantext(heir)
			db[house]["Heir"] = heir
		end
		if #seq["#Allegiance"] ~= 0 then
			local allegiance = gettag(seq,"#Allegiance")
			allegiance = allegiance:gsub("Allegiance =", "")
			allegiance = cleantext(allegiance)
			db[house]["Allegiance"] = allegiance
		end
		if #seq["#Vassals"] ~= 0 then
			local vassals = gettag(seq,"#Vassals")
			vassals = vassals:gsub("Vassals =", "")
			vassals = cleantext(vassals)
			db[house]["Vassals"] = vassals
		end
		if #seq["#Military"] ~= 0 then
			local military = gettag(seq,"#Military")
			military = military:gsub("Military =", "")
			military = cleantext(military)
			db[house]["Military"] = military
		end
		if #seq["#Cadets"] ~= 0 then
			local cadet = gettag(seq,"#Cadets")
			cadet = cadet:gsub("Cadets =", "")
			cadet = cleantext(cadet)
			db[house]["Cadets"] = cadet
		end
		if #seq["#Age"] ~= 0 then
			local age = gettag(seq,"#Age")
			age = age:gsub("Age =", "")
			age = cleantext(age)
			db[house]["Age"] = age
		end
		if #seq["#Founder"] ~= 0 then
			local founder = gettag(seq,"#Founder")
			founder = founder:gsub("Founder =", "")
			founder = cleantext(founder)
			db[house]["Founder"] = founder
		end
		if #seq["#Weapon"] ~= 0 then
			local weapon = gettag(seq,"#Weapon")
			weapon = weapon:gsub("Weapon =", "")
			weapon = cleantext(weapon)
			db[house]["Weapon"] = weapon
		end
	end
end

for fichier in os.dir("got/Tableau/Locations/") do
	local locTitle = nil
	for line in io.lines("got/Tableau/Locations/"..fichier) do
		line = line:gsub("(%p)"," %1 ")
		local seq = main(line)
		--seq:dump()
		--print(seq:tostring(tags))	
		if #seq["#LocationTitle"] ~= 0 then
			locTitle = gettag(seq,"#LocationTitle")
			locTitle = locTitle:gsub("Title =","")
			locTitle = cleantext(locTitle)
			if not db[locTitle] then
				db[locTitle] = {}
			end
		end
		if #seq["#Image"] ~= 0 then
			local image = gettag(seq,"#Image")
			image = image:gsub("Image =","")
			image = cleantext(image)
			db[locTitle]["Image"] = image
		end
		if #seq["#Location"] ~= 0 then
			local location = gettag(seq,"#Location")
			location = location:gsub("Location =","")
			location = cleantext(location)
			db[locTitle]["Location"] = location
		end
		if #seq["#Type"] ~= 0 then
			local tipe = gettag(seq,"#Type")
			tipe = tipe:gsub("Type =", "")
			tipe = cleantext(tipe)
			db[locTitle]["Type"] = tipe
		end
		if #seq["#Population"] ~= 0 then
			local population = gettag(seq,"#Population")
			population = population:gsub("Population =", "")
			population = cleantext(population)
			db[locTitle]["Population"] = population
		end
		if #seq["#Rulers"] ~= 0 then
			local rulers = gettag(seq,"#Rulers")
			rulers = rulers:gsub("Rulers =","")
			rulers = cleantext(rulers)
			db[locTitle]["Rulers"] = rulers
		end
		if #seq["#Religion"] ~= 0 then
			local religion = gettag(seq,"#Religion")
			religion = religion:gsub("Religion =", "")
			religion = cleantext(religion)
			db[locTitle]["Region"] = religion
		end
		if #seq["#Military"] ~= 0 then
			local military = gettag(seq,"#Military")
			military = military:gsub("Military =", "")
			military = cleantext(military)
			db[locTitle]["Military"] = military
		end
		if #seq["#Institutions"] ~= 0 then
			local institutions = gettag(seq,"#Institutions")
			institutions = institutions:gsub("Institutions =", "")
			institutions = cleantext(institutions)
			db[locTitle]["Institutions"] = institutions
		end
		if #seq["#Places"] ~= 0 then
			local places = gettag(seq,"#Places")
			places = places:gsub("Places =", "")
			places = cleantext(places)
			db[locTitle]["Places"] = places
		end
		if #seq["#Founding"] ~= 0 then
			local founding = gettag(seq,"#Founding")
			founding = founding:gsub("Founding =", "")
			founding = cleantext(founding)
			db[locTitle]["Founding"] = founding
		end
		if #seq["#Age"] ~= 0 then
			local age = gettag(seq,"#Age")
			age = age:gsub("Age =", "")
			age = cleantext(age)
			db[locTitle]["Age"] = age
		end
		if #seq["#Founder"] ~= 0 then
			local founder = gettag(seq,"#Founder")
			founder = founder:gsub("Founder =", "")
			founder = cleantext(founder)
			db[locTitle]["Founder"] = founder
		end
	end
end

local out = io.open("db.txt", "w")
out:write("return ")
out:write(serialize(db))
out:close()

--local db2 = dofile("db.txt")
