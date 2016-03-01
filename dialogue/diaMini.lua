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




function getNom(tabNom , suj)

	local i=1
	while tabNom[i]~=nil do
		if(string.find(suj,tabNom[i])~=nil)then
			return tabNom[i]
		end
		i=i+1
	end
	return ""
end
 







 


--   #################################   debut des lexicon et pattern    #####################################


local main = dark.pipeline()

main:basic()

-- lexicon en rapport avec la stucture de la base
main:lexicon("#actor", {"performed", "performs","perform","performing","play","plays", "played", "playing","represent","represents","representing","represented", "interpret", "interpreted", "interpreteding", "interprets"})
main:lexicon("#lieu", {"live", "lived", "lives", "shack", "living", "shackes", "shacking", "shacked","dwell", "inhabit", "inhabited", "inhabits","lodge","lodges","lodged", "tenant", "tenants", "tenanted","located", "located","locating"})
main:lexicon("#family", {"parent", "daughter", "sister", "wife", "husband", "father","mother","son","marry","married", "wedded", "couple","grandfather","grandmother","brother"})
main:lexicon("#house",{"allegiance","lord","sigil","region","founder","military","heir","weapon","seat"})-- a complèter par des mots equivalence






main:lexicon("#I",{"I", "my", "me"})
main:lexicon("#he", {"he", "his", "hiself"})
main:lexicon("#she",{"she", "her","hers", "herself"})
main:lexicon("#it", {"it", "its","itself"})
main:lexicon("#we", {"we", "our", "ourself"})
main:lexicon("#you", {"you", "your", "yourself"})

main:lexicon("#prepo",{"the","a","an"})
main:lexicon("#prepoOf",{"of","from"})
main:lexicon("#be", {"be","is","Is","Are", "are", "were", "was", "had been", "has been"})
main:lexicon("#have",{"have","has","had"})
main:lexicon("#Quantifieur", {"more","few","little","many", "lot of"})
main:lexicon("#Auxiliaire",{"do", "does", "could", "would", "should"})
--main:lexicon("#live", {"live", "lived", "lives", "shack", "living", "shackes", "shacking", "shacked","dwell", "inhabit", "inhabited", "inhabits","lodge","lodges","lodged", "tenant", "tenants", "tenanted"})
main:lexicon("#month", {"january", "february","march","april","may","june", "july", "august", "september", "october", "november", "december"})
main:lexicon("#day", {"monday", "tuesday", "wednesday", "thursday", "friday", "satuday", "sunday"})

main:lexicon("#advInt", {"how","what", "what's" , "what're"})
main:lexicon("#advIntTime", {"when"})
main:lexicon("#advIntFrequ", {"how often"})
main:lexicon("#advIntAge", {"how old"})
main:lexicon("#advIntLieu", {"where", "where's", "where're"})
main:lexicon("#advIntQuanti", {"which", "how many", "how much"})
main:lexicon("#advIntCause", {"why"})
main:lexicon("#advIntPerso", {"who", "whom", "whose"})
main:lexicon("#advIntWant", {"give me", "i want to know", "anwser me", "can i ask you", "tell me", })

main:lexicon("#adjPerso", {"quality", ""})-- a remplir pour detecter les questions qui sont en rapport avec les qualités (et descriptions ) du perso
main:lexicon("#prenomPerso", {"tyrion","catelyn","jaime", "robb", "john","jon","sansa","brandon","benjen","lyanna","rickon","rickard","bran","eddard","arya","talisa" })
main:lexicon("#nomPerso", {"lannister", "snow", "stark"})
main:lexicon("#title", {"Lord","Lady","King","Queen","Prince","Princess"})
 
main:model("mdl/postag-en")

main:pattern([[
	[#perso ( #nomPerso #prenomPerso| #nomPerso | #prenomPerso #nomPerso | #prenomPerso )

	]

	]])


main:pattern([[
	[#appartenance  (#POS=NNC |#POS=NNP | #POS=PRO | #perso) >(#POS=PRT  's' #POS=NNC)
	]
	]])
main:pattern([[
	[#grpAppartenance  (#POS=NNC |#POS=NNP | #POS=PRO | #perso) #POS=PRT  's' #POS=NNC
	]
	
	]])
main:pattern([[
	[#inte '?'
	]
	]])

--main:pattern([[
--	[#name (#W ('-' | #de #apostrophe?)?)+
--	]
--	]])


 --capture le sujet d'une phrase  , remplir le cas avec desnom du perso
main:pattern([[
 	[#sujet
 		(#he |#she |#it |#we |#I |#you |#prepo* #POS=NNP| #prepo* #POS=NNC | #perso) >(#POS=VRB  )
 		|<(#Auxiliaire|#be )(#he |#she |#it |#we |#I |#you | (#POS=NNP | #POS=NNC)+ | #nomPerso #prenomPerso| #nomPerso | #prenomPerso #nomPerso | #prenomPerso ) 
 		|#appartenance
 		| <( #POS=NNC #prepoOf ) (#POS=NNC | #POS=NNP |  #nomPerso #prenomPerso| #nomPerso | #prenomPerso #nomPerso | #prenomPerso )+


 		
	]
 	]])

main:pattern([[
	[#question 
		(#advIntQuanti| #advIntLieu | #advIntAge| #advIntPerso |#advIntFrequ | #advIntCause| #advIntTime | #advInt )+ 
		(#POS=NNC | #POS=NNP |#POS=PRO | #perso)* (#be | #Auxiliaire |#have )+ #prepo* #grpAppartenance* ( #prepo (#POS=NNC | #POS=NNP | #perso))*   #w*  #inte*
		|#advIntWant #w*


	]
	]])

main:pattern([[
	[#aRepondre
			( #POS=NNC | #POS=NNP) >(#prepoOf (#POS=NNC | #POS=NNP | #perso |#sujet |#he|#she|#you|#we) )
			| ((#POS=NNC | #POS=NNP ) #prepoOf #prepo* (#POS=NNC | #POS=NNP | #perso) ) >(#prepoOf )
			| <(#appartenance "'" "s") (#POS=NNC | #POS=NNP |#perso |#sujet |#he|#she|#you|#we)
	]
	]])

main:pattern([[
	[#questionYesNo 
		^(#Auxiliaire |#be | #POS=VRB) (#sujet |#he |#she|#you |#it |#we | #perso | #prepo #POS=NNC | #POS=NNP )+ .* #inte*

	]
	]])

main:pattern([[
	[#aVerifier
		( #sujet #prepo #aRepondre) >(#prepoOf (#sujet |#he|#she|#you|#we))
		|( #sujet #POS=VRB) >(#POS=ADP*  (#perso  |#sujet |#he|#she|#you|#we))
	]
	]])

main:pattern([[
	[#sujetYN
		<(#aVerifier (#prepoOf |#POS=ADP* ))  (#sujet |#perso |#he|#she|#we|#you)
	]
	]])

 

local tags = {
		["#question"] = "red",
		--["#he"] = "red",
		--["#advIntLieu"] = "red",
		--["#advIntCause"] = "red",
		--["#advIntPerso"] = "red",
		--["#advIntTime"] = "red",
		--["#advIntFrequ"] = "red",
		--["#advIntAge"] = "red",
		--["#advIntQuanti"] = "red",
		--["#personnage"] = "white",
		["#sujetYN"] = "blue",
		["#aVerifier"] = "white",
		["#questionYesNo"] = "red",
		["#aRepondre"] = "white",
		["#name"] = "blue",

		["#sujet"] ="blue"
} 




-- ##############################################  fin pattern ######################################################




--main
local db = {}
context =""
contextTest="" -- a changer par le sujet de la question ou faire un lexicon de tout les nom des perso afin qu'il le détecte
contextN2 =""
question =""
local db2 = dofile("dbMini.txt")
for line in io.lines("quMini.txt") do
	--os.execute("clear")
	--print("Hello I'm Ozad. Can I help you ? \n\n")
	--io.write("\n> ") 
	--line = io.read()
	line =line:gsub("([\',?!:;.()])", " %1 ")
	if string.find("//", line) == nil then
		line = string.lower(line)


 		local seq = main(line)
		question = gettag(seq, "#question")
		
		local tmp
		

		--[[ étape  a finaliser après les questions simple

		if(question~= "") then

			tmp = gettag(seq, "#personnage")

			if ( tmp~= ""  )  then-- todo : il faut changer cette tmp~="" par une fct qui vérifie si il y a un changement de conttexte ou non
				print("####### Changement du Context -> Contient un nom ( lieu, perso, maison ... ) #########")
			 -- cas : possible d'un new context à vérifier si il y a bien un changement de contexte , si c'est le cas on réactualise la var contexte, sinon on place cette question dans la "question context"
				context = gettag(seq, "#personnage")  
				print("le context c'est : "..context)
   			





   			else  -- cas : pas de changement de contexte   				


   				print("####### pas de changement de contexte, et ne contient aucun nom ( perso et lieux ou maison ) dans la question ####")
				if (context~= "") then
					print(" ===> Cette question est dans le contexte actuelle, qui est :  "..context)
					--cas : question  dans le contexte actuel
					-- A/ tester la corespondance du type de pronom pour le sujet, pour ce faire il faut le sexe du personnage 
						--A.1/ todo faire une fct qui prend en param le sujet et dire si c'est masculain ou féminin ou objet(it)


					-- B/ passer à l'étape 3'  
				 
				else  
					print("===> cette  question ne contient pas de context et pas de sujet principal. #####")
					--cas : question ne contient pas de context et pas de sujet principal
					--il faut tester si dans cette question contient un sujet du style NNc ou NNP ou un pronom, si c'est un pronom, il faut que le systeme retourne la question suivante : " De qui parlez vous ?"

				end

   			end

		end
]]--


print(seq:tostring(tags))
QYN = gettag(seq, "#questionYesNo")
QNormal = gettag(seq,"#question")

 
seq:dump()

-- #############   question simple pas de changement de contexte #################################
		
if(QNormal~="") then

		--todo a faire pareil que YN selon les different type
	print(QNormal)
	sujtetQs = gettag(seq, "#sujet")
	rep = gettag(seq, "#aRepondre")
	typeLieu = gettag(seq,"#lieu")
	typefamily = gettag(seq,"#family")
	typeActor =gettag(seq, "#actor")	 
	notFound = false
	typeHouse  = gettag(seq,"#house")

	--todo faire une fct qui recupère le nom de famille


	-- context
	--[[
	if(sujtetQs~="")then
		if((contextTest=="") or (contextTest~=sujtetQs))then
			contextTest = sujtetQs
		end

	end]]--


 	if(string.find(rep, typefamily)~=nil and typefamily~="") then-- reponse pour une question de type famille et perso => 'characters'

		if(rep=="parent")then-- reponse si la question concerne les parent
			local i =1
			if( db2[contextTest]['characters'][sujtetQs]['family'][rep]~=nil) then-- faire une fct qui teste si "[contextTest]['characters'][sujtetQs]['family'][rep]" existe pour éviter un null pointer
		 		while db2[contextTest]['characters'][sujtetQs]['family'][rep][i] ~= nil do 
					print(db2[contextTest]['characters'][sujtetQs]['family'][rep][i].."\n")	 -- on affiche les parent lié au question		
					i=i+1
					notFound = true
				end
			end


			if(notFound==false)then-- si il y a pas de reponse lié aux parent
				print("Sorry I don't find what you want")
			end
 				
		elseif (rep == "daughter" or rep == "son" or rep == "wife") then
			local i =1
  			if(db2[contextTest]['characters'][sujtetQs]['family'][rep]~=nil)then

				while db2[contextTest]['characters'][sujtetQs]['family'][rep][i] ~= nil do 
				 	print( db2[contextTest]['characters'][sujtetQs]['family'][rep][i]['nom'].."\n") -- on affiche les resultats lié au question
					i=i+1
					notFound = true
				end
	 		end

			if(notFound==false)then -- si il y a pas de reponse  
				print("Sorry "..sujtetQs.." doesn't have "..rep..".")
			end

	 	elseif (rep == "name") then
			print(db2[contextTest]['characters'][sujtetQs]['nom'])
			print("\n")
		end

	elseif(string.find(rep, typeHouse)~=nil and typeHouse~="") then
		 if(db2[contextTest][rep]~=nil)then
		 	if((sujtetQs~=nil ) or (sujtetQs~=""))then
		 	print(rep.." of "..sujtetQs)
		 	else
		 		print("the anwser is"..rep)
		 	end
		 else
		 	print("can you reformulate your question please ? :)")
		 end


	elseif(string.find(rep, typeLieu)~=nil ) then--reponse pour une question de type lieu
		print("Coming soon ;)\n")

	elseif(string.find(rep, typeActor)~=nil ) then -- reponse pour une question de type acteur
		print("Coming soon ;)\n")

	end


elseif(QYN~="") then
		--print("q y n ")

	allNom = getMultiple(seq,"#nomPerso")
 


	print(QYN)
	verif=gettag(seq,"#aVerifier")
	aRepSujet = gettag(seq, "#sujet") 
	


	aRepVB = gettag(seq,"#aRepondre")

	typeLieu = gettag(seq,"#lieu")
	typefamily = gettag(seq,"#family")
	typeActor =gettag(seq, "#actor")
	sujetYN = gettag(seq,"#sujetYN")


	newContext = getNom(allNom,sujetYN)
	--print("le nom du sujet =>>>>>> "..nom)


	if(newContext=="snow")then
		newContext="stark"
	end
	print("newContext "..newContext)

 	if(string.find(verif, typefamily)~=nil and typefamily~="") then






	--debut recherche context 
	if(newContext~="")then-- recherche le context principal ici c'est le nom de famille
		if((contextTest=="") or (contextTest~=newContext))then
			contextTest = newContext
		end

	end


	if(sujetYN~="")then --on stocke le sujet n°2 ici c'est le nom et prenom (perso ) du contexte
		
		local testPronomM = ""
		local testPronomF = ""

		local pronM = getMultiple(seq,"#he")
		local pronF = getMultiple(seq,"#she")
 
		testPronomM = getNom(pronM,sujetYN)
		testPronomF = getNom(pronF,sujetYN)
		if(contextN2~="")then
			--print("====> "..contextN2)
			if((testPronomM~="")or(testPronomF~=""))then-- todo faire une comparaison du sexe du perso dans contexteN2 avec le type du pronom
				sujetYN = contextN2-- on remplace "il" ou "elle" (qui sont des sujet de la question ) par le sujet du contexte
			 
			else
				contextN2 = sujetYN
			end
		
		else
							contextN2 = sujetYN

		end


	else
			print("I don't understand your question because there isn't the subjet, can you repeat again please ?")
	end

	print("context nom : "..contextTest)
	print("\ncontexte sujet : "..contextN2)
	--fin context






			--print("family ------------"..typefamily)
		if(typefamily=="parent") then
				
	 		if (db2[contextTest]['characters'][sujetYN]['family'][typefamily][1] ~= nil ) then
	 			print("oui\n")
 			else
 				print("non\n")
			end
			
		elseif (typefamily == "daughter" or typefamily == "son" or typefamily == "wife") then
 
 				if(db2[contextTest]['characters'][sujetYN]['family'] ~= nil) then
    			if (db2[contextTest]['characters'][sujetYN]['family'][typefamily] ~= nil  ) then
   			 	local i =1
 
   			 	local b =false
   				 	 ---print(typefamily.." "..sujetYN.." "..aRepSujet)
   			 	while db2[contextTest]['characters'][sujetYN]['family'][typefamily][i] ~= nil do
	 					--print(db2[contextTest]['characters'][sujetYN]['family'][typefamily][i]['nom']..i)
	 				if(db2[contextTest]['characters'][sujetYN]['family'][typefamily][i]['nom']==aRepSujet) then
	 						 
	 					b= true		 				
	 				end
	 				i=i+1
				end
end
				if(b==true) then
					print("oui\n")
	 			else
	 				print("non\n")
	 			end
 			else
 				print("non\n")
			end
		else
			print("Coming soon ;)\n")  				
		end


	elseif(string.find(verif, typeLieu)~=nil ) then
		print("Coming soon ;)\n")

	elseif(string.find(verif, typeActor)~=nil ) then
		print("Coming soon ;)\n")

	end

end

 -- #############################  fin question simple ################################



		-- afficher les postags
		

		--afficher les tags colorés
		--print(seq:tostring(tags))
		
	end
end



