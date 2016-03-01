dark = require("dark")

local main = dark.pipeline() -- pile d'execution
main:basic();
main:model("mdl/postag-en")


--match("Allegiance=([^\n]-")

-- Pour Houses structure
--[[main:pattern("[#HouseTitle House #w+]")
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
main:pattern("[#Weapon 'Weapon' '=' .*(\n)]")]]--

main:pattern("[#Pronom (/^[Tt]he/|/^[Tt]heir/|/^[Hh]is/|/^[Hh]er/)]")

main:pattern("[#Sigil (#Pronom)?/^[Ss]igil/ is .*?('.')]")
main:pattern("[#Words (#Pronom)?(/^[Ww]ords/ are | /^[Mm]otto/ (is | are)) .*?('.')]")
main:pattern("[#Seat (The head of the house is | (#Pronom)?/^[Ss]eat/ is) .*?('.')]")
main:pattern("[#Region (#Pronom)?/^[Rr]egion/ is .*?('.')]")
main:pattern("[#Lord (#Pronom)?/^[Ll]ord/ is .*?('.')]")
main:pattern("[#Allegiance /^[Aa]llegiance[s]/ (is|are) .*?('.')]")
main:pattern("[#Vassals (#Pronom)?/^[Vv]assal[s]/ (is|are) .*?('.')]")
main:pattern("[#Military (#Pronom)?/^[Mm]ilitary[s]/ (is|are) .*?('.')]")
main:pattern("[#Cadets (#Pronom)?/^[Cc]adet[s]/ (is|are) .*?('.')]")
main:pattern("[#Age (#Pronom)?/^[Aa]ge[s]/ (is|are) .*?('.')]")
--/^[Tt]he/|/^[Tt]heir/)? ((/^[Ff]ounder[s]/ (is|are))|
--main:pattern("[#Founder (/^[Hh]ouse[s]/)? (#w)? (was|is) founded by) .*?('.')]")
main:pattern("[#Weapon (#Pronom)?/^[Ww]eapon[s]/ (is|are) .*?('.')]")

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
}

local db = {}

for fichier in os.dir("corpus/Noble_houses/") do
	local house = nil
	for line in io.lines("corpus/Noble_houses/"..fichier) do
		line = line:gsub("(%p)"," %1 ")
		local seq = main(line)
		--seq:dump()
		--print(seq:tostring(tags))	
		if #seq["#Sigil"] ~= 0 then
			sigil = gettag(seq,"#Sigil")
			--sigil = house:gsub("Title =","")
			--sigil = cleantext(house)
			print("Sigil : "..sigil.."\n")
		end	
		if #seq["#Words"] ~= 0 then
			words = gettag(seq,"#Words")
			--sigil = house:gsub("Title =","")
			--sigil = cleantext(house)
			print("Words : "..words.."\n")
		end	
		if #seq["#Seat"] ~= 0 then
			seat = gettag(seq,"#Seat")
			--sigil = house:gsub("Title =","")
			--sigil = cleantext(house)
			print("Seat : "..seat.."\n")
		end	
		if #seq["#Region"] ~= 0 then
			region = gettag(seq,"#Region")
			--sigil = house:gsub("Title =","")
			--sigil = cleantext(house)
			print("Region : "..region.."\n")
		end	
		if #seq["#Lord"] ~= 0 then
			lord = gettag(seq,"#Lord")
			--sigil = house:gsub("Title =","")
			--sigil = cleantext(house)
			print("Lord : "..lord.."\n")
		end	
		if #seq["#Allegiance"] ~= 0 then
			allegiance = gettag(seq,"#Allegiance")
			--sigil = house:gsub("Title =","")
			--sigil = cleantext(house)
			print("allegiance : "..allegiance.."\n")
		end	
		if #seq["#Vassals"] ~= 0 then
			vassals = gettag(seq,"#Vassals")
			--sigil = house:gsub("Title =","")
			--sigil = cleantext(house)
			print("vassals : "..vassals.."\n")
		end	
		if #seq["#Military"] ~= 0 then
			military = gettag(seq,"#Military")
			--sigil = house:gsub("Title =","")
			--sigil = cleantext(house)
			print("military : "..military.."\n")
		end	
		if #seq["#Age"] ~= 0 then
			age = gettag(seq,"#Age")
			--sigil = house:gsub("Title =","")
			--sigil = cleantext(house)
			print("age : "..age.."\n")
		end	
		if #seq["#Founder"] ~= 0 then
			founder = gettag(seq,"#Founder")
			--sigil = house:gsub("Title =","")
			--sigil = cleantext(house)
			print("Founder : "..founder.."\n")
		end	
		if #seq["#Weapon"] ~= 0 then
			weapon = gettag(seq,"#Weapon")
			--sigil = house:gsub("Title =","")
			--sigil = cleantext(house)
			print("weapon : "..weapon.."\n")
		end
	end
end

local out = io.open("db.txt", "w")
out:write("return ")
out:write(serialize(db))
out:close()

--local db2 = dofile("db.txt")
