dark = require("dark")

local main = dark.pipeline() -- pile d'execution
main:basic();
main:model("mdl/postag-en")

main:pattern("[#Pronom (/^[Tt]he/|/^[Tt]heir/|/^[Hh]is/|/^[Hh]er/)]")
main:pattern("[#Be (is|are|was|were|will be)]")
main:pattern("[#House (/^[Hh]ouse/|/^[Hh]ouses/)]")

-- Pour Houses structure
main:pattern("[#Title (Title|title) '=' .*(\n)]")
main:pattern("[#Sigil /^[Ss]igil/ '=' .*(\n)]")
main:pattern("[#Words /^[Ww]ords/ '=' .*(\n)]")
main:pattern("[#Titles (Titles|titles) '=' .*(\n)]")
main:pattern("[#Seat /^[Ss]eat/ '=' .*('=')]")
main:pattern("[#Region /^[Rr]egion/ '=' .*(\n)]")
main:pattern("[#Lord /^[Ll]ord/ '=' .*(\n)]")
main:pattern("[#Heir /^[Hh]eir/ '=' .*(\n)]")
main:pattern("[#Allegiance /^[Aa]llegiance/ '=' .*(\n)]")
main:pattern("[#Vassals /^[Vv]assals/ '=' .*(\n)]")
main:pattern("[#Military /^[Mm]ilitary/ '=' .*(\n)]")
main:pattern("[#Cadets /^[Cc]adets/ '=' .*(\n)]")
main:pattern("[#Age /^[Aa]ge/ '=' .*(\n)]")
main:pattern("[#Founder /^[Ff]ounder/ '=' .*(\n)]")
main:pattern("[#Weapon /^[Ww]eapon/ '=' .*(\n)]")

-- Pour Houses non structure
main:pattern("[#Sigil_NS (#Pronom) (#w|#W)* /^[Ss]igil/ #Be .*?('.')]") -- OK
main:pattern("[#Words_NS (#Pronom) (#w|#W)* (/^[Ww]ords/|/^[Mm]otto/) #Be .*?('.')]") -- OK
main:pattern("[#Seat_NS (#Pronom) (#w|#W)* /^[Ss]eat/ #Be .*?('.')]") -- OK
main:pattern("[#Region_NS ((#Pronom)?/^[Rr]egion/ #Be |They (rule|ruled) over) .*?('.')]") -- OK (je crois)
main:pattern("[#Lord_NS ((#Pronom)/^[Ll]ord/ #Be | ((#w)* #Be (#w)* head of)) .*?('.')]") -- Récupere souvent la même info que seat ou castle
main:pattern("[#Allegiance_NS /^[Aa]llegiance[s]/ #Be .*?('.')]")
main:pattern("[#Vassals_NS (#Pronom)?(/^[Vv]assal/|/^[Vv]assals/) #Be .*?('.')]")
main:pattern("[#Military_NS (#Pronom)?/^[Mm]ilitary[s]/ #Be .*?('.')]")
main:pattern("[#Cadets_NS (#Pronom)?/^[Cc]adet[s]/ #Be .*?('.')]")
main:pattern("[#Age_NS (#Pronom)?/^[Aa]ge[s]/ #Be .*?('.')]")
main:pattern("[#Founder_NS ((#Pronom)(Founder|founder|Founders|founders) #Be| #House (#w)+ #Be founded by) .*?('.')]")
main:pattern("[#Weapon_NS (#Pronom)/^[Ww]eapon[s]/ #Be .*?('.')]")
main:pattern("[#GreatHouse_NS #House (#w)+ #Be (#w)+ /^[Gg]reat/ #House .*?('.')]")
main:pattern("[#VassalHouse_NS #House (#w)+ #Be (#w)+ vassal #House .*?('.')]")
main:pattern("[#Castle_NS /^[Tt]heir/ castle #Be .*?('.')]")

-- Pour Location structure
main:pattern("[#LocationTitle (Title|title) '=' .*(\n)]")
main:pattern("[#Location /^[Ll]ocation/ '=' .*(\n)]")
main:pattern("[#Type /^[Tt]ype/ '=' .*(\n)]")
main:pattern("[#Population /^[Pp]opulation/ '=' .*(\n)]")
main:pattern("[#Rulers /^[Rr]ulers/ '=' .*(\n)]")
main:pattern("[#Religion /^[Rr]eligion/ '=' .*(\n)]")
main:pattern("[#Institutions /^[Ii]nstitutions/ '=' .*(\n)]")
main:pattern("[#Places /^[Pp]laces/'Places' '=' .*(\n)]")
main:pattern("[#Founding /^[Ff]ounding/ '=' .*(\n)]")
main:pattern("[#Castle /^[Cc]astle/ '=' .*(\n)]")
main:pattern("[#PlacesOfNote /^[Pp]laces/ of note '=' .*(\n)]")
main:pattern("[#LocMilitary /^[Mm]ilitary/ '=' .*?(\n)]")

-- Pour Perso structure
main:pattern("[#Season /^[Ss]ilitary/ '=' .*(\n)]")
main:pattern("[#First /^[Ff]irst/ '=' .*(\n)]")
main:pattern("[#Last /^[Ll]ast/ '=' .*(\n)]")
main:pattern("[#Mentionned /^[Mm]entionned/ '=' .*(\n)]")
main:pattern("[#Appearances /^[Aa]ppearances/ '=' .*(\n)]")
main:pattern("[#Aka /^[Aa]ka/ '=' .*(\n)]")
main:pattern("[#Status /^[Ss]tatus/ '=' .*(\n)]")
main:pattern("[#Death /^[Dd]eath/ '=' .*(\n)]")
main:pattern("[#Place /^[Pp]lace/ '=' .*(\n)]")
main:pattern("[#Family /^[Ff]amily/ '=' .*(\n)]")
main:pattern("[#Actor /^[Aa]ctor/ '=' .*(\n)]")
main:pattern("[#Culture /^[Cc]ulture/ '=' .*(\n)]")

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

--[[ Fonction qui ajoute des infos non structurée dans le tableau ]]--
function remplirTabStructure(db, seq, tag, variable, title, expression)
	if #seq[tag] ~= 0 then
		if (variable == nil) then
			variable = gettag(seq,tag)
			local case = tag:gsub("#","")
			if (variable:lower() ~= case:lower() .. " =") then
				variable = variable:gsub(expression,"")
				variable = cleantext(variable)
				db[title][case] = variable
			end
		end
	end

	return variable
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
	string = string:gsub("\\ u2022",";")
	string = string:gsub("\\",";")

	return string
end

local tags = {
	["#Military"] = "magenta",
}

local db = {}

for fichier in os.dir("corpus/Test/") do	
	local title = nil
	local sigil = nil	
	local words = nil
	local titles = nil	
	local seat = nil
	local region = nil	
	local lord = nil
	local heir = nil	
	local allegiance = nil
	local vassals = nil	
	local military = nil
	local age = nil	
	local founder = nil
	local weapon = nil

	for line in io.lines("corpus/Test/"..fichier) do
		line = line:gsub("(%p)"," %1 ")
		local seq = main(line)
		--seq:dump()
		--print(seq:tostring(tags))
		if #seq["#Title"] ~= 0 then
			title = gettag(seq,"#Title")
			title = title:gsub("[Tt]itle = ","")
			title = cleantext(title)
			if not db[title] then
				db[title] = {}
			end
		end
		if (title ~= nil) then
			if #seq["#Sigil"] ~= 0 then
				sigil = remplirTabStructure(db, seq, "#Sigil", sigil, title, "[Ss]igil = ")
			end
			if #seq["#Sigil_NS"] ~= 0 then
				local sigil_ns = gettag(seq,"#Sigil_NS")
				db[title]["Sigil_NS"] = sigil_ns
			end
			if #seq["#Words"] ~= 0 then	
				words = remplirTabStructure(db, seq, "#Words", words, title, "[Ww]ords = ")
			end
			if #seq["#Words_NS"] ~= 0 then		
				local words_ns = gettag(seq,"#Words_NS")
				db[title]["Words_NS"] = words_ns
			end
			if #seq["#Titles"] ~= 0 then
				titles = remplirTabStructure(db, seq, "#Titles", titles, title, "[Tt]itles = ")
			end
			if #seq["#Seat"] ~= 0 then
				seat = remplirTabStructure(db, seq, "#Seat", seat, title, "[Ss]eat = ")
			end
			if #seq["#Seat_NS"] ~= 0 then
				local seat_ns = gettag(seq,"#Seat_NS")
				db[title]["Seat_NS"] = seat_ns
			end
			if #seq["#Region"] ~= 0 then
				region = remplirTabStructure(db, seq, "#Region", region, title, "[Rr]egion = ")
			end
			if #seq["#Region_NS"] ~= 0 then
				local region_ns = gettag(seq,"#Region_NS")
				db[title]["Region_NS"] = region_ns
			end		
			if #seq["#Lord"] ~= 0 then
				lord = remplirTabStructure(db, seq, "#Lord", lord, title, "[Ll]ord = ")
			end		
			if #seq["#Lord_NS"] ~= 0 then
				local lord_ns = gettag(seq,"#Lord_NS")
				db[title]["Lord_NS"] = lord_ns
			end		
			if #seq["#Heir"] ~= 0 then
				heir = remplirTabStructure(db, seq, "#Heir", heir, title, "[Hh]eir = ")
			end		
			if #seq["#Heir_NS"] ~= 0 then
				local heir_ns = gettag(seq,"#Heir_NS")
				db[title]["Heir_NS"] = heir_ns
			end	
			if #seq["#Allegiance"] ~= 0 then
				allegiance = remplirTabStructure(db, seq, "#Allegiance", allegiance, title, "[Aa]llegiance = ")
			end	
			if #seq["#Vassals"] ~= 0 then
				vassals = remplirTabStructure(db, seq, "#Vassals", vassals, title, "[Vv]assals = ")
			end
			if #seq["#Military"] ~= 0 then
				military = remplirTabStructure(db, seq, "#Military", military, title, "[Mm]ilitary = ")
				if (military ~= nil) then
					print(seq[1])
				end
			end	
			if #seq["#Age"] ~= 0 then
				age = remplirTabStructure(db, seq, "#Age", age, title, "[Aa]ge = ")
			end
			if #seq["#Founder"] ~= 0 then
				founder = remplirTabStructure(db, seq, "#Founder", founder, title, "[Ff]ounder = ")
			end
			if #seq["#Founder_NS"] ~= 0 then
				local founder_ns = gettag(seq,"#Founder_NS")
				db[title]["Founder_NS"] = founder_ns
			end
			if #seq["#Weapon"] ~= 0 then
				weapon = remplirTabStructure(db, seq, "#Weapon", weapon, title, "[Ww]eapon = ")
			end
			if #seq["#GreatHouse_NS"] ~= 0 then
				local greatHouse_ns = gettag(seq,"#GreatHouse_NS")
				db[title]["GreatHouse_NS"] = greatHouse_ns
			end
			if #seq["#VassalHouse_NS"] ~= 0 then
				local vassalHouse_ns = gettag(seq,"#VassalHouse_NS")
				db[title]["VassalHouse_NS"] = vassalHouse_ns
			end
			if #seq["#Castle_NS"] ~= 0 then
				local castle_ns = gettag(seq,"#Castle_NS")
				db[title]["Castle_NS"] = castle_ns
			end
		end		
	end
end

--[[for fichier in os.dir("corpus/Locations/") do	
	local title = nil
	for line in io.lines("corpus/Locations/"..fichier) do
		line = line:gsub("(%p)"," %1 ")
		local seq = main(line)
		--seq:dump()
		--print(seq:tostring(tags))
		if #seq["#Title"] ~= 0 then
			title = gettag(seq,"#Title")
			title = title:gsub("[Tt]itle = ","")
			title = cleantext(title)
			if not db[title] then
				db[title] = {}
			end
		end
		if (title ~= nil) then
			--[[if #seq["#Type"] ~= 0 then		
				local tipe = gettag(seq,"#Type")
				if (tipe:lower() ~= "type =") then
					tipe = tipe:gsub("[Tt]ype = ","")
					db[title]["Type"] = tipe
				end
			end-
			if #seq["#Population"] ~= 0 then
				local population = gettag(seq,"#Population")
				if (population:lower() ~= "population =") then
					population = population:gsub("[Pp]opulation = ","")
					db[title]["Population"] = population
				end
			end
			if #seq["#Rulers"] ~= 0 then
				local rulers = gettag(seq,"#Rulers")
				if (rulers:lower() ~= "rulers =") then
					rulers = rulers:gsub("[Rr]ulers = ","")
					db[title]["Rulers"] = rulers
				end
			end
			if #seq["#Religion"] ~= 0 then
				local religion = gettag(seq,"#Religion")
				if (religion:lower() ~= "religion =") then
					religion = religion:gsub("[Rr]eligion = ","")
					db[title]["Religion"] = religion
				end
			end		
			if #seq["#Institutions"] ~= 0 then
				local institutions = gettag(seq,"#Institutions")
				if (institutions:lower() ~= "institutions =") then
					institutions = institutions:gsub("[Ii]nstitutions = ","")
					db[title]["Institutions"] = institutions
				end
			end	
			if #seq["#Places"] ~= 0 then
				local places = gettag(seq,"#Places")
				if (places:lower() ~= "places =") then
					places = places:gsub("[Pp]laces = ","")
					db[title]["Places"] = places
				end
			end
			if #seq["#Founding"] ~= 0 then
				local founding = gettag(seq,"#Founding")
				if (founding:lower() ~= "founding =") then
					founding = founding:gsub("[Ff]ounding = ","")
					db[title]["Founding"] = founding
				end
			end	
			if #seq["#Age"] ~= 0 then
				local age = gettag(seq,"#Age")
				if (age:lower() ~= "age =") then
					age = age:gsub("[Aa]ge = ","")
					db[title]["Age"] = age
				end
			end	
			if #seq["#Castle"] ~= 0 then
				local castle = gettag(seq,"#Castle")
				if (castle:lower() ~= "castle =") then
					castle = castle:gsub("[Cc]astle = ","")
					db[title]["Castle"] = castle
				end
			end	
			if #seq["#Military"] ~= 0 then
				local military = gettag(seq,"#Military")
				if (military:lower() ~= "military =") then
					military = military:gsub("[Mm]ilitary = ","")
					military = cleantext(military)			
					db[title]["Military"] = military
				end
			end	
			if #seq["#PlacesOfNote"] ~= 0 then
				local placesOfNote = gettag(seq,"#PlacesOfNote")
				if (placesOfNote:lower() ~= "places of note =") then
					placesOfNote = placesOfNote:gsub("[Pp]laces of note = ","")
					placesOfNote = cleantext(placesOfNote)					
					db[title]["PlacesOfNote"] = placesOfNote
				end
			end
			--[[if #seq["#Castle_NS"] ~= 0 then
				local castle_ns = gettag(seq,"#Castle_NS")
				db[title]["Castle_NS"] = castle_ns
			end
		end		
	end
end--]]

--[[for fichier in os.dir("corpus/Characters/") do	
	local title = nil
	for line in io.lines("corpus/Characters/"..fichier) do
		line = line:gsub("(%p)"," %1 ")
		local seq = main(line)
		--seq:dump()
		--print(seq:tostring(tags))
		if #seq["#Title"] ~= 0 then
			title = gettag(seq,"#Title")
			title = title:gsub("[Tt]itle = ","")
			title = cleantext(title)
			if not db[title] then
				db[title] = {}
			end
		end
		if (title ~= nil) then
			if #seq["#Season"] ~= 0 then
				local season = gettag(seq,"#Season")
				if (season:lower() ~= "season =") then
					season = season:gsub("[Ss]eason = ","")
					season = cleantext(season)		
					db[title]["Season"] = season
				end
			end
			if #seq["#First"] ~= 0 then
				local first = gettag(seq,"#First")
				if (first:lower() ~= "first =") then
					first = first:gsub("[Ff]irst = ","")
					first = cleantext(first)		
					db[title]["First"] = first
				end
			end
			if #seq["#Last"] ~= 0 then
				local last = gettag(seq,"#Last")
				if (last:lower() ~= "last =") then
					last = last:gsub("[Ll]ast = ","")
					last = cleantext(last)		
					db[title]["Last"] = last
				end
			end		
			if #seq["#Mentionned"] ~= 0 then
				local mentionned = gettag(seq,"#Mentionned")
				if (mentionned:lower() ~= "mentionned =") then
					mentionned = mentionned:gsub("[Mm]entionned = ","")
					mentionned = cleantext(mentionned)		
					db[title]["Mentionned"] = mentionned
				end
			end
			if #seq["#Appearances"] ~= 0 then
				local appearances = gettag(seq,"#Appearances")
				if (appearances:lower() ~= "appearances =") then
					appearances = appearances:gsub("[Aa]ppearances = ","")
					appearances = cleantext(appearances)		
					db[title]["Appearances"] = appearances
				end
			end
			if #seq["#Titles"] ~= 0 then
				local titles = gettag(seq,"#Titles")
				if (titles:lower() ~= "titles =") then
					titles = titles:gsub("[Tt]itles = ","")
					titles = cleantext(titles)		
					db[title]["Titles"] = titles
				end
			end
			if #seq["#Aka"] ~= 0 then
				local aka = gettag(seq,"#Aka")
				if (aka:lower() ~= "aka =") then
					aka = aka:gsub("[Aa]ka = ","")
					aka = cleantext(aka)		
					db[title]["Aka"] = aka
				end
			end	
			if #seq["#Age"] ~= 0 then
				local age = gettag(seq,"#Age")
				if (age:lower() ~= "age =") then
					age = age:gsub("[Aa]ge = ","")
					age = cleantext(age)		
					db[title]["Age"] = age
				end
			end	
			if #seq["#Status"] ~= 0 then
				local status = gettag(seq,"#Status")
				if (status:lower() ~= "status =") then
					status = status:gsub("[Ss]tatus = ","")
					status = cleantext(status)		
					db[title]["Status"] = status
				end
			end	
			if #seq["#Death"] ~= 0 then
				local death = gettag(seq,"#Death")
				if (death:lower() ~= "death =") then
					death = death:gsub("[Dd]eath = ","")	
					death = cleantext(death)			
					db[title]["Death"] = death
				end
			end	
			if #seq["#Place"] ~= 0 then
				local place = gettag(seq,"#Place")
				if (place:lower() ~= "place =") then
					place = place:gsub("[Pp]lace = ","")	
					place = cleantext(place)			
					db[title]["Place"] = place
				end
			end	
			if #seq["#Allegiance"] ~= 0 then
				local allegiance = gettag(seq,"#Allegiance")
				if (allegiance:lower() ~= "allegiance =") then
					allegiance = allegiance:gsub("[Aa]llegiance = ","")
					allegiance = cleantext(allegiance)		
					db[title]["Allegiance"] = allegiance
				end
			end
			if #seq["#Family"] ~= 0 then
				local family = gettag(seq,"#Family")
				if (family:lower() ~= "family =") then
					family = family:gsub("[Ff]amily = ","")
					family = cleantext(family)					
					db[title]["Family"] = family
				end
			end
			if #seq["#Actor"] ~= 0 then
				local actor = gettag(seq,"#Actor")
				if (actor:lower() ~= "actor =") then
					actor = actor:gsub("[Aa]ctor = ","")	
					actor = cleantext(actor)						
					db[title]["Actor"] = actor
				end
			end
			if #seq["#Culture"] ~= 0 then
				local culture = gettag(seq,"#Culture")
				if (culture:lower() ~= "culture =") then
					culture = culture:gsub("[Cc]ulture = ","")
					culture = cleantext(culture)							
					db[title]["Culture"] = culture
				end
			end
			--[[if #seq["#Castle_NS"] ~= 0 then
				local castle_ns = gettag(seq,"#Castle_NS")
				db[title]["Castle_NS"] = castle_ns
			end
		end		
	end
end--]]

local out = io.open("db.txt", "w")
out:write(serialize(db))
out:close()
