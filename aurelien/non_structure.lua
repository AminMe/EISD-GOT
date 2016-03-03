dark = require("dark")

local main = dark.pipeline() -- pile d'execution
main:basic();
main:model("mdl/postag-en")

-- Pour Houses structure
main:pattern("[#Title (Title|title) '=' .*(\n)]")
--main:pattern("[#Image /^[Ii]mage/ '=' .*(\n)]")
main:pattern("[#Sigil /^[Ss]igil/ '=' .*(\n)]")
main:pattern("[#Words /^[Ww]ords/ '=' .*(\n)]")
main:pattern("[#Titles (Titles|titles) '=' .*(\n)]")
main:pattern("[#Seat /^[Ss]eat/ '=' .*(\n)]")
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

main:pattern("[#Pronom (/^[Tt]he/|/^[Tt]heir/|/^[Hh]is/|/^[Hh]er/)]")
main:pattern("[#Be (is|are|was|were|will be)]")
main:pattern("[#House (/^[Hh]ouse/|/^[Hh]ouses/)]")

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
	["#Sigil"] = "red",
	["#Words"] = "cyan",	
	["#Title"] = "magenta",
	["#Seat"] = "yellow",
}

local db = {}

for fichier in os.dir("corpus/Noble_houses/") do	
	local title = nil
	for line in io.lines("corpus/Noble_houses/"..fichier) do
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
				local sigil = gettag(seq,"#Sigil")
				if (sigil:lower() ~= "sigil =") then
					sigil = sigil:gsub("[Ss]igil = ","")
					db[title]["Sigil"] = sigil
				end
			end
			if #seq["#Sigil_NS"] ~= 0 then
				local sigil_ns = gettag(seq,"#Sigil_NS")
				db[title]["Sigil_NS"] = sigil_ns
			end
			if #seq["#Words"] ~= 0 then		
				local words = gettag(seq,"#Words")
				if (words:lower() ~= "words =") then
					words = words:gsub("[Ww]ords = ","")
					db[title]["Words"] = words
				end
			end
			if #seq["#Words_NS"] ~= 0 then		
				local words_ns = gettag(seq,"#Words_NS")
				db[title]["Words_NS"] = words_ns
			end
			if #seq["#Titles"] ~= 0 then
				local titles = gettag(seq,"#Titles")
				if (titles:lower() ~= "titles =") then
					titles = titles:gsub("[Tt]itles = ","")
					db[title]["Titles"] = titles
				end
			end
			if #seq["#Seat"] ~= 0 then
				local seat = gettag(seq,"#Seat")
				if (seat:lower() ~= "seat =") then
					seat = seat:gsub("[Ss]eat = ","")
					db[title]["Seat"] = seat
				end
			end
			if #seq["#Seat_NS"] ~= 0 then
				local seat_ns = gettag(seq,"#Seat_NS")
				db[title]["Seat_NS"] = seat_ns
			end
			if #seq["#Region"] ~= 0 then
				local region = gettag(seq,"#Region")
				if (region:lower() ~= "region =") then
					region = region:gsub("[Rr]egion = ","")
					db[title]["Region"] = region
				end
			end
			if #seq["#Region_NS"] ~= 0 then
				local region_ns = gettag(seq,"#Region_NS")
				db[title]["Region_NS"] = region_ns
			end		
			if #seq["#Lord"] ~= 0 then
				local lord = gettag(seq,"#Lord")
				if (lord:lower() ~= "lord =") then
					lord = lord:gsub("[Ll]ord = ","")
					db[title]["Lord"] = lord
				end
			end		
			if #seq["#Lord_NS"] ~= 0 then
				local lord_ns = gettag(seq,"#Lord_NS")
				db[title]["Lord_NS"] = lord_ns
			end		
			if #seq["#Heir"] ~= 0 then
				local heir = gettag(seq,"#Heir")
				if (heir:lower() ~= "heir =") then
					heir = heir:gsub("[Hh]eir = ","")
					db[title]["Heir"] = heir
				end
			end		
			if #seq["#Heir_NS"] ~= 0 then
				local heir_ns = gettag(seq,"#Heir_NS")
				db[title]["Heir_NS"] = heir_ns
			end	
			if #seq["#Allegiance"] ~= 0 then
				local allegiance = gettag(seq,"#Allegiance")
				if (allegiance:lower() ~= "allegiance =") then
					allegiance = allegiance:gsub("[Aa]llegiance = ","")
					db[title]["Allegiance"] = allegiance
				end
			end	
			if #seq["#Vassals"] ~= 0 then
				local vassals = gettag(seq,"#Vassals")
				if (vassals:lower() ~= "vassals =") then
					vassals = vassals:gsub("[Vv]assals = ","")
					db[title]["Vassals"] = vassals
				end
			end	
			if #seq["#Military"] ~= 0 then
				local military = gettag(seq,"#Military")
				if (military:lower() ~= "military =") then
					military = military:gsub("[Mm]ilitary = ","")
					db[title]["Military"] = military
				end
			end	
			if #seq["#Age"] ~= 0 then
				local age = gettag(seq,"#Age")
				if (age:lower() ~= "age =") then
					age = age:gsub("[Aa]ge = ","")
					db[title]["Age"] = age
				end
			end
			if #seq["#Founder"] ~= 0 then
				local founder = gettag(seq,"#Founder")
				if (founder:lower() ~= "founder =") then
					founder = founder:gsub("[Ff]ounder = ","")
					db[title]["Founder"] = founder
				end
			end
			if #seq["#Founder_NS"] ~= 0 then
				local founder_ns = gettag(seq,"#Founder_NS")
				db[title]["Founder_NS"] = founder_ns
			end
			if #seq["#Weapon"] ~= 0 then
				local weapon = gettag(seq,"#Weapon")
				if (weapon:lower() ~= "weapon =") then
					weapon = weapon:gsub("[Ww]eapon = ","")
					db[title]["Weapon"] = weapon
				end
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

local out = io.open("db.txt", "w")
out:write(serialize(db))
out:close()
