dark = require("dark")

local main = dark.pipeline() -- pile d'execution
main:basic();
main:model("mdl/postag-en")

main:lexicon("#NomHouses", "lexique_houses.txt")
main:lexicon("#NomCharacters", "lexiques/lexique_character.txt")
main:lexicon("#NomLocations", "lexiques/lexique_locations.txt")
main:lexicon("#debut", {"debuts","debuting"})
main:lexicon("#de",{"du","de","des","d"})
main:lexicon("#apostrophe",{"'"})
main:lexicon("#title", {"Lord","Lady","King","Queen","Prince","Princess","Ser","Commander"})

main:pattern("[#Pronom (/^[Tt]he/|/^[Tt]heir/|/^[Hh]is/|/^[Hh]er/)]")
main:pattern("[#Be (is|are|was|were|will be)]")
main:pattern("[#House (/^[Hh]ouse/|/^[Hh]ouses/)]")
main:pattern("[#Child (/^[Ss]on/|/^[Dd]aughter/|/^[Cc]hild/|/^[Cc]hildren/)]")

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
main:pattern("[#MinorHouse_NS #House (#w)+ #Be (#w)+ minor #House .*?('.')]")
main:pattern("[#Castle_NS /^[Tt]heir/ castle #Be .*?('.')]")
main:pattern("[#Heir_NS (#Pronom)/^[Hh]eir/ #Be .*?('.')]")

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

-- Pour Location non structure
main:pattern("[#Visit (#W (#POS=DET | '-' | #de #apostrophe?)?){1,} >(visits|visit|visited|has visited)]")

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

-- Pour Perso non structure
--main:pattern("[#House_NS #NomHouses]")
main:pattern("[#NightSwatch /^[Nn]ight/ '%'' s /^[Ww]atch/]")
main:pattern("[#Prononciation #Be pronounced .*?('.')]")
main:pattern("[#Bastard #Be (#Pronom)? bastard #Child of .*?('.')]")
main:pattern("[#Killed #Be killed by .*?('.')]")

main:pattern([[
	[#infoCharacter
		'is' ('a'|'an') 
		[#type
			(#w+)
		]
		'character' 
		(#POS=VRB? #POS=ADP #POS=DET
			(
			[#season
				#w 
			]
			(',' #POS=CON | ',' | #POS=CON)?)+ >('seasons' | 'season'))?
	]		
]])
main:pattern([[
		[#relationName 
			#title? 
				[#name
				(#W (#POS=DET | '-' | #de #apostrophe?)?) {1,}
				]
		]
]])

main:pattern([[
	[#Actor
		<(#POS=PRO #POS=VRB #POS=VRB #POS=ADP #w+) #name
	]
]])



main:pattern([[
	[#firstSeen
		#debut (#POS=ADP #POS=DET|#POS=ADP) 
		[#episodeName
			(#w|#d|#POS=NNC)+
		]
	]
]])

function getMultiple(seq,tag)
	local pos = seq[tag]
	if #pos == 0 then
		return ""
	end
	local number = #pos
	local tab = {}
	for j=1, number do
		local res = {}
		local deb = pos[j][1]
		local fin = pos[j][2]
		for i = deb, fin do
			res[#res + 1] = seq[i].token
		end
		tab[#tab + 1] = table.concat(res, " ")
	end
	return tab
end

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

function getFamily(str) 
	local tableName = getMultiple(str,"#nomPersonne")
	local tableLien = getMultiple(str,"#lienFamille")
	local tableFini = {}
	if(tableName ~= "") then
		for key,val in pairs(tableLien) do 
			if not tableFini[val] then 
				tableFini[val] = {}
			end
			i = #tableFini[val] + 1
			if not tableFini[val][i] then 
				tableFini[val][i] = {}
			end 
			tableFini[val][i] = tableName[key]
		end
		
		print("____________________")
	end
	return tableFini
end
--[[ Fonction qui ajoute des infos non structurée dans le tableau ]]--
function remplirTabStructure(db, seq, tag, variable, title, expression)
	if tag=="#Family" then
		if #seq[tag] ~= 0 then
			if (variable == nil) then
				variable = gettag(seq,tag)
				--print(variable)

				--print("..... "..expression)


				variable = variable:gsub(expression,"")
				local lmain = dark.pipeline()
				lmain:basic()
				lmain:model("mdl/postag-en")

				lmain:pattern([[
					[#familleRelation
						([#nomPersonne
							(#w)+
						]
						'-'
						[#lienFamille
							(#w|'-')+
						]
						('[' ']')?)*
						]
				]])

				variable = variable:gsub("(%p)", " %1 ")
				variable = variable:gsub("[%\\%/]","")

		


				res = string.gsub(variable,"%-%s+(.-)([A-Z])","- %1 [ ] %2")
				lseq = lmain(res)

				--print("lseq ................... ")
				tabFamily = getFamily(lseq)

				--print("new")
				--print(variable)

				local case = tag:gsub("#","")
				case = case:lower()
				if (variable:lower() ~= case:lower() .. " =") then
					-- variable = variable:gsub(expression,"")
					variable = cleantext(variable)
					variable = cleannumber(variable)
					db[title][case] = tabFamily
				end
			end
		end
	elseif tag=="#Age" then
		if #seq[tag] ~= 0 then
			if (variable == nil) then
				variable = gettag(seq,tag)

				local lmain = dark.pipeline()
				lmain:basic()
				lmain:model("mdl/postag-en")
				--print("phrase age = " .. variable)

				lmain:pattern([[
					[#age 
					   #d >(('years' | #POS=ADP )) | 'thousand' | #d
					]   
				]])

				variable = cleantext(variable)
				variable = cleannumber(variable)

				lseq = lmain(variable)
				ageP = gettag(lseq,"#age")
				--print("age = "..ageP)
				variable = ageP
				local case = tag:gsub("#","")
				case = case:lower()
				if (variable:lower() ~= case:lower() .. " =") then
					variable = variable:gsub(expression,"")
					
					db[title][case] = variable
				end
			end
		end
	else
		if #seq[tag] ~= 0 then
			if (variable == nil) then
				variable = gettag(seq,tag)
				local case = tag:gsub("#","")
				case = case:lower()
				if (variable:lower() ~= case:lower() .. " =") then
					variable = variable:gsub(expression,"")
					variable = cleantext(variable)
					variable = cleannumber(variable)
					db[title][case] = variable
				end
			end
		end
	end

	return variable
end

--[[ Fonction qui ajoute des infos non structurée dans le tableau ]]--
function remplirTabStructure_military(db, seq, tag, variable, title, expression)

	local result = {}

	title = title:lower()
	if #seq[tag] ~= 0 then
		if (variable == nil) then
			variable = gettag(seq,tag)
			local case = tag:gsub("#","")
			case = case:lower()
			if (variable:lower() ~= case:lower() .. " =") then
				variable = variable:gsub(expression,"")
				variable = cleantext(variable)
				variable = cleannumber(variable)
				result,somme = splitvirgule(variable)
				db[title][case] = result
			end
		end
	end

	db[title]["militarySize"] = somme

	return variable
end

--[[ Fonction qui ajoute des infos non structurée dans le tableau ]]--
function getVisit(db, location, variable)

	if not db[location]["visit"] then
		db[location]["visit"] = {}
	end

	variable = variable:gsub("When ", "")
	db[location]["visit"][#db[location]["visit"] + 1] = variable

end

--[[ Fonction qui ajoute un personnage et ces information dans la maison à laquelle il appartient ]]--
function addCharacterHouse(db, house, character, tabCharacter)

	if (character ~= nil) then
		character = character:lower()
		if (house ~= nil) then
			house = house:lower()
			if not db[house] then
				db[house] = {}
			end

			if not db[house]["characters"] then
				db[house]["characters"] = {}
			end
			
			db[house]["characters"][character] = tabCharacter[character]
		else			
			if not db["unknown"] then
				db["unknown"] = {}
			end

			if not db["unknown"]["characters"] then
				db["unknown"]["characters"] = {}
			end

			db["unknown"]["characters"][character] = tabCharacter[character]
		end
	end
end

--[[ Fonction qui retire les virgule des grands nombres ]]--
function cleannumber(texte)
	local old = {}
	local value = {}
	local i = 1

	for word in string.gmatch(texte, '(%d+ , %d+)') do
    		old[i] = word
		word = word:gsub(" , ", "")
		value[i] =  word
		i = i + 1
	end

	for i = 1, #old do 
		texte = texte:gsub(old[i], value[i])
	end
	
	return texte
end

--[[ Fonction qui sépare les info séparé par des virgules (notament pour military) ]]--
function splitvirgule(texte)

	local table = {}
	local result = {}
	local i = 1
	local key, value
	local somme = 0
	texte = texte:gsub(", ", ",")
	for word in string.gmatch(texte, '([^,]+)') do
		word = word:gsub("%( (.-) %)","")
    		table[i] = word
		i = i + 1
	end

	for i = 1, #table do
		for word in string.gmatch(table[i], '(%d+ [^%d]+)', 1) do			
			for nombre in word.gmatch(word, '(%d+)', 1) do
				value = nombre
				somme = somme + tonumber(value)
			end			
			for cle in word.gmatch(word, ' ([^%d]+)') do
				key = cle
			end
		end
		if (key ~= nil) then
			result[key] = value
		else
			result["military"] = value
		end
	end

	return result,somme
end

function cleantext(string)
	
	string = string:gsub("%[ %[ File : (.-) ] ]","")
	string = string:gsub("]","")
	string = string:gsub("%[ ","")
	string = string:gsub("' ' '","")
	--string = string:gsub(" ' ' '","")
	string = string:gsub("' ","")
	string = string:gsub("< br / >", ",")
	string = string:gsub("/", "")
	string = string:gsub(" < br >",";")
	string = string:gsub("  < small >","")
	string = string:gsub(" < / small >","")
	string = string:gsub("}","")
	string = string:gsub("<ref>","")
	string = string:gsub("\\ u2022",";")
	string = string:gsub("\\",";")
	string = string:lower()

	return string
end

function getSeason(seq)
	local pos = seq["#infoCharacter"]
	if #pos == 0 then
		return ""
	end
	local major = seq["#season"]
	local number = #major
	if(number == 0) then 
		return ""
	end	
	local tab = {}
	for j=1, number do
		local res = {}
		local deb = major[j][1]
		local fin = major[j][2]
	for i = deb, fin do
		res[#res + 1] = seq[i].token
	end
		tab[#tab + 1] = table.concat(res, " ")
	end
	return tab
end

local tags = {
	["#Military"] = "magenta",
}

local db = {}



for fichier in os.dir("corpus/Noble_houses/") do	
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
	local typeHouse = nil

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
				sigil = remplirTabStructure(db, seq, "#Sigil", sigil, title, "[Ss]igil = ")
			end
			if #seq["#Sigil_NS"] ~= 0 then
				local sigil_ns = gettag(seq,"#Sigil_NS")
				db[title]["sigil_NS"] = sigil_ns
			end
			if #seq["#Words"] ~= 0 then	
				words = remplirTabStructure(db, seq, "#Words", words, title, "[Ww]ords = ")
			end
			if #seq["#Words_NS"] ~= 0 then		
				local words_ns = gettag(seq,"#Words_NS")
				db[title]["words_NS"] = words_ns
			end
			if #seq["#Titles"] ~= 0 then
				titles = remplirTabStructure(db, seq, "#Titles", titles, title, "[Tt]itles = ")
			end
			if #seq["#Seat"] ~= 0 then
				seat = remplirTabStructure(db, seq, "#Seat", seat, title, "[Ss]eat = ")
			end
			if #seq["#Seat_NS"] ~= 0 then
				local seat_ns = gettag(seq,"#Seat_NS")
				db[title]["seat_NS"] = seat_ns
			end
			if #seq["#Region"] ~= 0 then
				region = remplirTabStructure(db, seq, "#Region", region, title, "[Rr]egion = ")
			end
			if #seq["#Region_NS"] ~= 0 then
				local region_ns = gettag(seq,"#Region_NS")
				db[title]["region_NS"] = region_ns
			end		
			if #seq["#Lord"] ~= 0 then
				lord = remplirTabStructure(db, seq, "#Lord", lord, title, "[Ll]ord = ")
			end		
			if #seq["#Lord_NS"] ~= 0 then
				local lord_ns = gettag(seq,"#Lord_NS")
				db[title]["lord_NS"] = lord_ns
			end		
			if #seq["#Heir"] ~= 0 then
				heir = remplirTabStructure(db, seq, "#Heir", heir, title, "[Hh]eir = ")
			end		
			if #seq["#Heir_NS"] ~= 0 then
				local heir_ns = gettag(seq,"#Heir_NS")
				db[title]["heir_NS"] = heir_ns
			end
			if #seq["#Allegiance"] ~= 0 then
				allegiance = remplirTabStructure(db, seq, "#Allegiance", allegiance, title, "[Aa]llegiance = ")
			end	
			if #seq["#Vassals"] ~= 0 then
				vassals = remplirTabStructure(db, seq, "#Vassals", vassals, title, "[Vv]assals = ")
			end
			if #seq["#Military"] ~= 0 then
				military = remplirTabStructure_military(db, seq, "#Military", military, title, "[Mm]ilitary = ")
			end	
			if #seq["#Age"] ~= 0 then
				age = remplirTabStructure(db, seq, "#Age", age, title, "[Aa]ge = ")
			end
			if #seq["#Founder"] ~= 0 then
				founder = remplirTabStructure(db, seq, "#Founder", founder, title, "[Ff]ounder = ")
			end
			if #seq["#Founder_NS"] ~= 0 then
				local founder_ns = gettag(seq,"#Founder_NS")
				db[title]["founder_NS"] = founder_ns
			end
			if #seq["#Weapon"] ~= 0 then
				weapon = remplirTabStructure(db, seq, "#Weapon", weapon, title, "[Ww]eapon = ")
			end
			if #seq["#GreatHouse_NS"] ~= 0 then
				if (typeHouse == nil) then
					typeHouse = gettag(seq,"#GreatHouse_NS")
					db[title]["type_house"] = typeHouse
				end
			end
			if #seq["#VassalHouse_NS"] ~= 0 then
				if (typeHouse == nil) then
					typeHouse = gettag(seq,"#VassalHouse_NS")
					db[title]["type_house"] = typeHouse
				end
			end
			if #seq["#MinorHouse_NS"] ~= 0 then
				if (typeHouse == nil) then
					typeHouse = gettag(seq,"#MinorHouse_NS")
					db[title]["type_house"] = typeHouse
				end
			end
			if #seq["#Castle_NS"] ~= 0 then
				local castle_ns = gettag(seq,"#Castle_NS")
				db[title]["castle_NS"] = castle_ns
			end
			if #seq["#Prononciation"] ~= 0 then
				local prononciation = gettag(seq,"#Prononciation")
				prononciation = prononciation:gsub("is pronounced ", "")
				db[title]["prononciation"] = prononciation
			end
		end		
	end
end

for fichier in os.dir("corpus/Locations/") do	
	local title = nil
	local population = nil	
	local rulers = nil
	local religion = nil	
	local institutions = nil
	local places = nil	
	local founding = nil
	local age = nil	
	local castle = nil
	local military = nil	
	local placesOfNote = nil

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
			if #seq["#Population"] ~= 0 then
				population = remplirTabStructure(db, seq, "#Population", population, title, "[Pp]opulation = ")
			end
			if #seq["#Rulers"] ~= 0 then
				rulers = remplirTabStructure(db, seq, "#Rulers", rulers, title, "[Rr]ulers = ")
			end
			if #seq["#Religion"] ~= 0 then
				religion = remplirTabStructure(db, seq, "#Religion", religion, title, "[Rr]eligion = ")
			end		
			if #seq["#Institutions"] ~= 0 then
				institutions = remplirTabStructure(db, seq, "#Institutions", institutions, title, "[Ii]nstitutions = ")
			end	
			if #seq["#Places"] ~= 0 then
				places = remplirTabStructure(db, seq, "#Places", places, title, "[Pp]laces = ")
			end
			if #seq["#Founding"] ~= 0 then
				founding = remplirTabStructure(db, seq, "#Founding", founding, title, "[Ff]ounding = ")
			end	
			if #seq["#Age"] ~= 0 then
				age = remplirTabStructure(db, seq, "#Age", age, title, "[Aa]ge = ")
			end	
			if #seq["#Castle"] ~= 0 then
				castle = remplirTabStructure(db, seq, "#Castle", castle, title, "[Cc]astle = ")
			end	
			if #seq["#Military"] ~= 0 then
				military = remplirTabStructure_military(db, seq, "#Military", military, title, "[Mm]ilitary = ")
			end	
			if #seq["#PlacesOfNote"] ~= 0 then
				placesOfNote = remplirTabStructure(db, seq, "#PlacesOfNote", placesOfNote, title, "[Pp]laces of note = ")
			end
			if #seq["#Prononciation"] ~= 0 then
				local prononciation = gettag(seq,"#Prononciation")
				prononciation = prononciation:gsub("is pronounced ", "")
				db[title]["prononciation"] = prononciation
			end
			if #seq["#Castle_NS"] ~= 0 then
				local castle_ns = gettag(seq,"#Castle_NS")
				db[title]["Castle_NS"] = castle_ns
			end
			if #seq["#Visit"] ~= 0 then
				local visit = gettag(seq,"#Visit")
				getVisit(db, title, visit)
			end
		end		
	end
end

for fichier in os.dir("corpus/Characters/") do

	local tabCharacter = {}
	local title = nil	
	local season = nil
	local first = nil	
	local last = nil
	local mentionned = nil	
	local appearances = nil
	local titles = nil	
	local aka = nil
	local age = nil	
	local status = nil
	local death = nil	
	local place = nil
	local allegiance = nil	
	local family = nil
	local actor = nil	
	local culture = nil
	local nom_house = nil
	local night_ns = nil
	local bastard = nil
	local killed = nil
	local actor = nil
	local firstSeen = nil
	local typeCharacter = nil

	for line in io.lines("corpus/Characters/"..fichier) do
		line = line:gsub("(%p)"," %1 ")
		local seq = main(line)
		--seq:dump()
		--print(seq:tostring(tags))
		if #seq["#Title"] ~= 0 then
			title = gettag(seq,"#Title")
			title = title:gsub("[Tt]itle = ","")
			title = cleantext(title)
			if not tabCharacter[title] then
				tabCharacter[title] = {}
			end
		end
		if (title ~= nil) then
			if #seq["#Season"] ~= 0 then
				season = remplirTabStructure(tabCharacter, seq, "#Season", season, title, "[Ss]eason = ")
			end
			if #seq["#First"] ~= 0 then
				first = remplirTabStructure(tabCharacter, seq, "#First", first, title, "[Ff]irst = ")
			end
			if #seq["#Last"] ~= 0 then
				last = remplirTabStructure(tabCharacter, seq, "#Last", last, title, "[Ll]ast = ")
			end		
			if #seq["#Mentionned"] ~= 0 then
				mentionned = remplirTabStructure(tabCharacter, seq, "#Mentionned", mentionned, title, "[Mm]entionned = ")
			end
			if #seq["#Appearances"] ~= 0 then
				appearances = remplirTabStructure(tabCharacter, seq, "#Appearances", appearances, title, "[Aa]ppearances = ")
			end
			if #seq["#Titles"] ~= 0 then
				titles = remplirTabStructure(tabCharacter, seq, "#Titles", titles, title, "[Tt]itles = ")
			end
			if #seq["#Aka"] ~= 0 then
				aka = remplirTabStructure(tabCharacter, seq, "#Aka", aka, title, "[Aa]ka = ")
			end	
			if #seq["#Age"] ~= 0 then
				age = remplirTabStructure(tabCharacter, seq, "#Age", age, title, "[Aa]ge = ")
			end	
			if #seq["#Status"] ~= 0 then
				status = remplirTabStructure(tabCharacter, seq, "#Status", status, title, "[Ss]tatus = ")
			end	
			if #seq["#Death"] ~= 0 then
				death = remplirTabStructure(tabCharacter, seq, "#Death", death, title, "[Dd]eath = ")
			end	
			if #seq["#Place"] ~= 0 then
				place = remplirTabStructure(tabCharacter, seq, "#Place", place, title, "[Pp]lace = ")
			end	
			if #seq["#Allegiance"] ~= 0 then
				allegiance = remplirTabStructure(tabCharacter, seq, "#Allegiance", allegiance, title, "[Aa]llegiance = ")
			end
			if #seq["#Family"] ~= 0 then
				family = remplirTabStructure(tabCharacter, seq, "#Family", family, title, "[Ff]amily = ")
			end
			if #seq["#Actor"] ~= 0 then
				actor = remplirTabStructure(tabCharacter, seq, "#Actor", actor, title, "[Aa]ctor = ")
			end
			if #seq["#Culture"] ~= 0 then
				culture = remplirTabStructure(tabCharacter, seq, "#Culture", culture, title, "[Cc]ulture = ")
			end
			if #seq["#Castle_NS"] ~= 0 then
				local castle_ns = gettag(seq,"#Castle_NS")
				tabCharacter[title]["castle_NS"] = castle_ns
			end
			if #seq["#Bastard"] ~= 0 then
				if (bastard == nil) then
					bastard = gettag(seq,"#Bastard")
					tabCharacter[title]["bastard"] = bastard
				end
			end
			if #seq["#Killed"] ~= 0 then
				if (status ~= nil and killed == nil) then
					if (status:lower() ~= "alive") then
						killed = gettag(seq,"#Killed")
						tabCharacter[title]["killed"] = killed
					end
				end
			end
			if #seq["#Prononciation"] ~= 0 then
				local prononciation = gettag(seq,"#Prononciation")
				prononciation = prononciation:gsub("is pronounced ", "")
				tabCharacter[title]["prononciation"] = prononciation
			end
			if #seq["#NightSwatch"] ~= 0 then
				night_ns = "true"
				tabCharacter[title]["night"] = night_ns
			end
			if #seq["#NomHouses"] ~= 0 then
				if (nom_house == nil) then
					nom_house = gettag(seq,"#NomHouses")
					nom_house = nom_house:lower()
					tabCharacter[title]["house"] = nom_house
				end
			end
			if #seq["#Actor"] ~= 0 then
				if (actor == nil) then
					actor = gettag(seq,"#Actor")
					actor = actor:lower()
					tabCharacter[title]["actor"] = actor
				end
			end
			if #seq["#firstSeen"] ~= 0 then
				if (firstSeen == nil) then
					firstSeen = gettag(seq,"#firstSeen")
					firstSeen = firstSeen:lower()
					tabCharacter[title]["firstSeen"] = firstSeen
				end
			end
			if #seq["#type"] ~= 0 then
				if (typeCharacter == nil) then
					typeCharacter = gettag(seq,"#type")
					typeCharacter = typeCharacter:lower()
					tabCharacter[title]["type"] = typeCharacter
				end
			end
			if getSeason(seq) ~='' then
				--Add season to te tab
				local tab = getSeason(seq)
				-- A CHANGER LE db[name][season] par le vrai chemin  
				if not tabCharacter[title]['season'] then
					tabCharacter[title]['season'] = {}
					for k,v in pairs(tab) do 
						--print(k,v) 
						tabCharacter[title]['season'][k] = v
					end	
				end
			end
		end		
	end
		
	addCharacterHouse(db, nom_house, title, tabCharacter)
	
end

local out = io.open("db.txt", "w")
out:write("return ")
out:write(serialize(db))
out:close()
