dark = require("dark")





function gettag(seq, tag)
	local pos = seq[tag]
	if #pos == 0 then
		return ""
	end
	local deb = pos[1][1]
	local fin = pos[1][2]
	local res = {}
	for i = deb, fin do
		res[#res + 1] = seq[i].token
		 
	end	
	 

	return table.concat(res, " ")
end
 








local main = dark.pipeline()

main:basic()


--main:lexicon("#lieu",{"winterfell"})
--main:lexicon("#perso",{"john snow"})
--main:lexicon("#maison",{"stark"})


--lexicon sur les pronoms 

main:lexicon("#he", {"he", "his", "hiself"})
main:lexicon("#she",{"she", "her","hers", "herself"})
main:lexicon("#it", {"it", "its","itself"})




--lexicon famille:
main:lexicon("#family", {"parent", "daughter", "sister", "wife", "husband", "father","mother","son","marry","married", "wedded", "couple","grandfather","grandmother","brother"})

--lexicon actor :
main:lexicon("#actor", {"performed", "performs","perform","performing","play","plays", "played", "playing","represent","represents","representing","represented", "interpret", "interpreted", "interpreteding", "interprets"})
main:lexicon("#serie",{"season", "episode"})
main:lexicon("#actorSyno" , {"actor","comedian"})

main:lexicon("#vrbLieu", {"location","live", "lived", "lives", "shack", "living", "shackes", "shacking", "shacked","dwell", "inhabit", "inhabited", "inhabits","lodge","lodges","lodged", "tenant", "tenants", "tenanted","located", "located","locating"})

main:lexicon("#type", {"type"})

--lexicon type de question : 

main:lexicon("#qNumerique", { "how many", "how much", "how often"})
main:lexicon("#qInfoS", {"what", "what's"  , "what is",   "who", "who's" , "give me one","give me","give me a", "give me an", "how"})
main:lexicon("#qInfoP", {"what", "what're" , "what are", "who", "who're", "who are","give me all","give me", "give me some" })
main:lexicon("#qLieu",{"where", "where's", "where're", "where are", "where is"})
main:lexicon("#age",{"age", "old"})
main:lexicon("#founder",{"founder", "creator","leader"})


main:lexicon("#enTeteYN",{ "do you know the information that","is" , "do you know if","do you know " ,"do you think"})

--lexicon seat :
main:lexicon("#seat", {"base", "seat"})
main:lexicon("#allegiance", {"allegiance"})
main:lexicon("#army", {"army"})
main:lexicon("#sovereign" ,{"sovereign"})
main:lexicon("#aka", {"aka", "as known as"})


--lexicon verbe :
main:lexicon("#Auxiliaire",{"do", "does", "could", "would", "should"})
main:lexicon("#be", {"be","is","Is","Are", "are", "were", "was", "had been", "has been"})
main:lexicon("#apparaitre",{"appears", "appear",""})

--lexicon de preposition :
main:lexicon("#prepoOf",{"of","from"})
main:lexicon("#prepo",{"the","a","an", "in"})


--lexicon de status :
main:lexicon("#status", {"lord"})

--lexicon de personnage: 
main:lexicon("#people" , {"people","part"})

main:lexicon("#culture", {"culture","ceremonie"})

main:lexicon("#first", { "first time", "first seen", "first apparition", "first appearance","first"})
main:lexicon("#die",{"die", "died", "kill", "killed","death"})
-- apartenance
main:lexicon("#apartenance", {" ' s"," ‘ s", " ’ s","‘s"})

country, district, division, expanse, land, locality, part, patch, 

main:lexicon("#region", {"region", "country", "district", "division", "expanse", "land", "locality", "part", "patch"})
main:lexicon("#founder", {"founder","beginner","initiator"})
main:lexicon("#military", {"military", "armed forces", "army", "forces", "services"})
main:lexicon("#heir", {"heir","beneficiary","heiress","next in line", "scion", "successor"})
main:lexicon("#weapon", {"secret weapon","weapon"})
main:lexicon("#vassals",{"vassals","vassal","bondman", "bondservant", "bondsman", "liegeman", "retainer", "serf", "slave", "subject", "thrall", "varlet"})
main:lexicon("#words", {"words","word", "lyrics", "text"})
main:lexicon("#prononciation",{"pronounciation", "pronounce", "accent", "accentuation", "articulate", "articulation", "diction", "elocution", "enunciation", "enunciate"})

--chargement du lexicon : maison, lieu, et perso

listHouseLexique = {}
lexiconHouseLexique = {}
for line in io.lines("lexiques/lexique_houses.txt") do
	listHouseLexique[line] = {}
	listHouseLexique[line][line] = line
	listHouseLexique[line][string.gsub(line,".-%s","")] = string.gsub(line,".-%s","")
	lexiconHouseLexique[#lexiconHouseLexique+1] = line
end

main:lexicon("#maison", lexiconHouseLexique)

-- tester si nil

print(serialize(lexiconHouseLexique))


function sizegmatch(line)
	cpt = 0
	matches = {}
	for w in line:gmatch("%w+") do 
		cpt=cpt+1 
		matches[cpt] = w
	end
	return cpt, matches
end

listCharacterLexique = {}
lexiconCharacterLexique = {}
for line in io.lines("lexiques/lexique_character.txt") do
	listCharacterLexique[line] = {}
	listCharacterLexique[line][line] = line
	size, matches = sizegmatch(line)
	if(size==2) then
		prenom = matches[1]
		listCharacterLexique[line][prenom] = prenom
		nom = matches[2]
		pNom = prenom:sub(1,1).." "..nom
		listCharacterLexique[line][pNom] = pNom
		prenomN = prenom.." "..nom:sub(1,1)
		listCharacterLexique[line][prenomN] = prenomN
		pNomPoint = prenom:sub(1,1)..". "..nom
		listCharacterLexique[line][pNomPoint] = pNomPoint
		prenomNPoint = prenom..". "..nom:sub(1,1)
		listCharacterLexique[line][prenomNPoint] = prenomNPoint
	end
	lexiconCharacterLexique[#lexiconCharacterLexique+1] = line
end
main:lexicon("#perso", lexiconCharacterLexique)

--print(serialize(listCharacterLexique))


listLocationLexique = {}
lexiconLocationLexique = {}
for line in io.lines("lexiques/lexique_locations.txt") do
	listLocationLexique[line] = line
	lexiconLocationLexique[#lexiconLocationLexique+1] = line
end

--print(serialize(listLocationLexique))


main:lexicon("#lieu", lexiconLocationLexique)



--fin du chargement du lexicon lieu, maison , perso






-- debut des pattern
main:model("mdl/postag-en")

main:pattern([[
	[#VB 
		#be|#apparaitre|#actor
	]

	]])


main:pattern([[
	[#attributeBD #seat|#age|#vrbLieu|#actor|#family|#allegiance|#age|#army|#type|#founder|#sovereign|#status|#people|#serie|#culture|#actorSyno|#aka|#first

	]
	]])

--patterne question normal
main:pattern([[
	[#qNormal
		(#qNumerique | #qLieu |#qInfoP |#qInfoS) .*
	]
]])


--patterne question Y/N 
main:pattern([[
	[#qYesNo 
		^(#Auxiliaire |#be | #POS=VRB) .*
	]
	]])


--patterne question Y/N + reponse
main:pattern([[
	[#qYesNoAnswer 
		^(#Auxiliaire 'you' ('know'| 'think') )
	]
]])

--patterne pronom :
main:pattern([[
	[#pronom   (#he |#she |#it |#we |#I |#you )
	]
	]])


--patterne sujet :

 main:pattern([[
 	[#sujet
 		 (#perso | #maison | #lieu | #pronom|#actorSyno)
	]
 	]])


main:pattern([[
	[#aRepondre
		(#attributeBD) >(#apartenance (#POS=ADJ | #POS=CON #POS=ADJ)*  (#w)* #prepoOf (#w)* #sujet )
		|(#attributeBD) >(#prepoOf #prepo* (#POS=NNC | #POS=NNP | #sujet)  #prepoOf )
		| (#attributeBD) >((#w)* (#prepoOf |#prepo)* (#w)* #sujet #VB?)
		| <(#sujet #apartenance (#POS=ADJ | #POS=CON #POS=ADJ)* ) (#attributeBD)
		| #age 
		|(#vrbLieu ) >(#sujet)
		|#actor
		|#first
		|#die

	]
	]])

main:pattern([[
	[#aVerifier
		 <( #enTeteYN ) ( [#valeurBd (#sujet|(#w |#d)*) ] (#POS=VRB |#actor | #vrbLieu)) >(#POS=ADP*   (#perso  |#sujet |#pronom))
		|<( #enTeteYN )  <( #sujet | #pronom) ([#valeurBd (#sujet|(#w |#d)*) ] #prepo? #aRepondre)
		|<(  #sujet #apartenance)  ((#POS=NNC |#attributeBD)* ([#valeurBd (#sujet|(#w |#d)+) ]))
		|<( #enTeteYN ) ((#w)* #aRepondre #prepoOf #sujet #POS=VRB [#valeurBd (#sujet|(#w |#d)+) ])
		|<( #enTeteYN ) ([#valeurBd (#sujet|(#w |#d)+) ] #aRepondre )
		|<( #enTeteYN  (#sujet|(#w |#d)+)  #aRepondre #POS=ADP*)([#valeurBd (#POS=NNC)+ ])
		|<( #enTeteYN )  ([#valeurBd (#POS=NNC |#attributeBD|#lieu |#maison |#perso)]* #prepo* #aRepondre )
		|<( #enTeteYN  (#sujet|(#w |#d)+)  #POS=ADP)([#valeurBd (#POS=NNC |#season)+ #d ])



	]
	]])


 
 
main:pattern([[
	[#sujetYN
		<(#aVerifier #prepoOf) (#sujet|#pronom)
		|<(#aVerifier #POS=ADP*) (#perso|#sujet|#pronom)
		|(#sujet|#pronom) >(#aVerifier)
		|(#sujet) >(#apartenance #aVerifier)
	]
	]])








local tags = {
		["#valeurBd"] ="blue",
		["#qYesNoAnswer"] ="blue",
		["#qYesNo"] ="blue",
		["#aRepondre"] ="white",
		["#sujet"]= "red",
		["#lieu"] ="red",
		["#maison"] ="red",
		["#perso"] = "red",
		["#qNumerique"] = "red",
		["#aVerifier"] = "white",
		["#sujetYN"] = "blue",
		--["#enTeteYN"] = "white",
} 






-- todo fct qui permet de choisir entre deux aRepondre , avec des lexicon ayant certain priorité, et renvoye le premier si il y en a un seul
-- todo fct army
-- faire synonyme
 

for line in io.lines("debug.txt") do
	line=line:gsub("‘s","'s")			
	line=line:gsub("’s","'s")
	line =line:gsub("([\',?!:;.()])", " %1 ")
	

	if string.find("//", line) == nil then
		line = string.lower(line)
		line =line:gsub("do you know the information that","is")
		line =line:gsub("do you know which","what is")
 		local seq = main(line)

 		print(seq:tostring(tags))

 		seq:dump()

	end

end
