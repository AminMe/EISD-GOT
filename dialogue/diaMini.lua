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


function transform(str,lseq)
	local bdTags = {"#visit","#prononciation","#words","#vassals","#weapon","#heir","#lord","#founder","#seat","#titles","#type_house","#allegiance","#region","#rulers","#population","#castle","#military","#religion","#sigil","#characters","#titles","#actor","#night","#place","#season","#family","#wife","#husband","#father","#mother","#son","#daughter","#brother","#sister","#child","#parent","#type","#status","#appearances","#first","#house","#words","#culture","#bastard","#hellhot","#death","#aka","#last","#age","#institutions","#killed"}
	

	for key,val in pairs(bdTags) do
		--print("-----> "..key.." -> " .. val)
		--print("lseq = "..lseq:tostring(ltags))
		--print("bdTags[key] = "..bdTags[key])
		tab=getMultiple(lseq,bdTags[key])

		if(tab~="")then
			for key2,val2 in pairs(tab)  do

				if(string.find(tab[key2],str)~=nil)then
					
					resTran = string.gsub(val,"#","") 
					if(resTran=="military")then
						return "militarySize"
					else
						return resTran
					end
				end
			end
		end
	end
	return ""
end






function dernier( tab ) --tab = un tableau de 1 dimension 
	res2 =""
	for key =1,  #tab do
		 res2=tab[key] 
		-- print("res = "..res2)
	end
	return res2
end




function rep2param(sujetV, aRepVar)

	local db2Var = dofile("db-1.txt")
	res =""
	if( db2Var[sujetV]~=nil)then
		--print("sujet : "..sujetV.." et arep = "..aRepVar)

		if( db2Var[sujetV][aRepVar]~=nil)then
 			res=db2Var[sujetV][aRepVar]
		end
	end
	return res

end



function rechercheBD(sujetV, aRepVar, tabHouse)

	local db2Var = dofile("db-1.txt")
	tmp=""
	resultVar=""
	maison =""
	compt=0

	for key =1, #tabHouse do

		maison = tabHouse[key]
		maison = maison:gsub(",","")
		if( db2Var[maison]~=nil)then

			if( db2Var[maison]["characters"]~=nil)then
					  --print("##############le sujet : "..sujetV.." et a repoondre "..aRepVar)

				if( db2Var[maison]['characters'][sujetV]~=nil)then
					print("maison : "..maison)
			   		--print("##############le sujet : "..sujetV.." et a repoondre "..aRepVar)


					if( db2Var[maison]['characters'][sujetV]['family'] ~=nil)then

						-- a améliorer 
						if( aRepVar=="husband" or aRepVar == "daughter" or aRepVar == "son" or aRepVar == "wife" or aRepVar == "father"or aRepVar == "mother"or aRepVar == "brother"or aRepVar =="sister" or aRepVar == "uncle by marriage" 
							or aRepVar =="paternal aunt" or aRepVar == "bastard" or aRepVar =="paternal uncle" or aRepVar =="maternal grandfather" or aRepVar =="maternal grandmother" or aRepVar =="maternal uncle" 
							or aRepVar =="maternal aunt" or aRepVar =="maternal great - uncle" or aRepVar =="maternal great - aunt" or aRepVar == "brother - in - law") then
					 		




					 		if(db2Var[maison]['characters'][sujetV]['family'] ~= nil) then


					    		if (db2Var[maison]['characters'][sujetV]['family'][aRepVar] ~= nil  ) then
					   			
					   				local i =1


		    		 				while db2Var[maison]['characters'][sujetV]['family'][aRepVar][i] ~= nil do
					   					--print("##############le sujet : "..sujetV.." et a repoondre "..aRepVar)

					   				 
				 	 						tmp = resultVar.." "..db2Var[maison]['characters'][sujetV]['family'][aRepVar][i].."  "
				 	 						resultVar =tmp
				 	 						tmp=""
				 	 						compt=compt+1

			 							
			 							i=i+1
									end
									return resultVar,compt
								end
							end
						else
							return db2Var[maison]['characters'][sujetV][aRepVar],1
						end

					end
				end
			end
		end
 	end





 	resultVar =""
	if( db2Var[sujetV]~=nil)then
		--print("sujet : "..sujetV.." et arep = "..aRepVar)

		if( db2Var[sujetV][aRepVar]~=nil)then
 			resultVar=db2Var[sujetV][aRepVar] 
 			compt=1
		end
	end
 




	return resultVar,compt

end






--######################################################### Génération des réponses #################################################################################



--######################################################### FIN Génération des réponses #################################################################################













--######################################################### Début des pattern #################################################################################





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
main:lexicon("#actor", {"comedian","actor","performed", "performs","perform","performing","play","plays", "played", "playing","represent","represents","representing","represented", "interpret", "interpreted", "interpreteding", "interprets"})
main:lexicon("#serie",{"season", "episode"})
main:lexicon("#actorSyno" , {"actor","comedian"})

main:lexicon("#vrbLieu", {"location","live", "lived", "lives", "shack", "living", "shackes", "shacking", "shacked","dwell", "inhabit", "inhabited", "inhabits","lodge","lodges","lodged", "tenant", "tenants", "tenanted","located", "located","locating"})

main:lexicon("#type", {"type"})

--lexicon type de question : 

main:lexicon("#qNumerique", { "how many", "how much", "how often"})
main:lexicon("#qInfoS", { "what's"  , "what is",   "who", "who's" , "give me one","give me","give me a", "give me an", "how", "which's", "which is","which","what"})
main:lexicon("#qInfoP", { "what're" , "what are", "who", "who're", "who are","give me all","give me", "give me some" ,"which are", "which're"})
main:lexicon("#qLieu",{"where", "where's", "where're", "where are", "where is"})
main:lexicon("#age",{"age", "old"})
main:lexicon("#founder",{"founder", "creator","leader"})


main:lexicon("#enTeteYN",{ "do you know the information that","is" , "do you know if","do you know " ,"do you think"})

--lexicon seat :
main:lexicon("#seat", {"base", "seat","throne","centre"})
main:lexicon("#allegiance", {"allegiance","adherence","constancy","fidelity","obedience","obligation","loyalty"})
main:lexicon("#sovereign" ,{"sovereign","chief","emperor","empress","king","monarch"})
main:lexicon("#aka", {"aka", "as known as","nickname"})


--lexicon verbe :
main:lexicon("#Auxiliaire",{"do", "does", "could", "would", "should"})
main:lexicon("#be", {"be","is","Is","Are", "are", "were", "was", "had been", "has been"})
main:lexicon("#apparaitre",{"appears", "appear","appeared","arise","arised","show","showed","attend","attended"})

--lexicon de preposition :
main:lexicon("#prepoOf",{"of","from"})
main:lexicon("#prepo",{"the","a","an", "in"})


--lexicon de lord :
main:lexicon("#lord", {"lord","commander","governor","king","leader"})

--lexicon de personnage: 
main:lexicon("#people" , {"part"})

main:lexicon("#culture", {"culture","ceremonie"})

main:lexicon("#first", { "first time", "first seen", "first apparition", "first appearance","first"})
main:lexicon("#die",{"die", "died", "kill", "killed","death"})
main:lexicon("#last",{"last","at the end", "the end","end","lastest","final"})
main:lexicon("#titles",{"titles","appellation","privilege"})
main:lexicon("#place",{"place","area","location","locus","point","position","site","station"})
main:lexicon("#night",{"night watches","night guardian","guardian","night","darkness"})
main:lexicon("#bastard",{"bastard","by-blow","illegitimate child","whoreson"})
main:lexicon("#visit",{"go to see","went to see","goes to see","visit","visited"})



-- apartenance
main:lexicon("#apartenance", {" ' s"," ‘ s", " ’ s","‘s"})

 
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

--print(serialize(lexiconHouseLexique))


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
		prenomNPoint = prenom.." "..nom:sub(1,1).."."
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
	[#attributeBD 
		#seat|#age|#vrbLieu|#actor|#family|#allegiance|#age|#army|#type|#founder|#sovereign|#lord|#people|#serie|#culture|#actorSyno|#aka|#first
		|#region |#military |#heir |#weapon |#vassals |#words |#prononciation|#visit|#bastard|#night|#place|#titles|#last|#die|#first

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
 		  (#perso | #maison | #lieu | #pronom|#actorSyno | #POS=NNC? #POS=NNP? | #POS=NNP? #POS=NNC? )
	]
 	]])


main:pattern([[
	[#aRepondre
		(#attributeBD) >(#apartenance (#POS=ADJ | #POS=CON #POS=ADJ)*  (#w)* #prepoOf (#w)* #sujet )
		|(#attributeBD) >(#prepoOf #prepo* (#POS=NNC | #POS=NNP | #sujet)  #prepoOf )
		| (#attributeBD) >((#w)* (#prepoOf |#prepo)* (#w)* #sujet #VB?)
		| <(#sujet #apartenance (#POS=ADJ | #POS=CON #POS=ADJ )* ) (#attributeBD)
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



--######################################################### FIN des pattern #################################################################################











-- todo fct qui permet de choisir entre deux aRepondre , avec des lexicon ayant certain priorité, et renvoye le premier si il y en a un seul

 
result =""
context ="" 
motNotFind=""
test=""
ret=""
historique ={
	motAdemander="",
	contextHis="",
	type="",
	question,
}
tabHistorique={}

local db2 = dofile("db-1.txt")

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


 		qYN = gettag(seq,"#qYesNo")
 		qYesNoAnswer = gettag(seq,"#qYesNoAnswer")
 		qNormal =gettag(seq,"#qNormal")

 		boolFindSujet = true
 		boolFindArep = true

 		boolMaison =false
 		boolLieu =false
 		boolPerso = false
 		boolYNAnswer =false
 		boolValBD=false
 		boolContextVide=false


 		compt=0

 		if(qYesNoAnswer~="")then
 			 boolYNAnswer= true
 		end


 --############################################################# Question normal ##################################################################################
 --###########################################################################################################################################################


 		if(qNormal~="" or qYesNoAnswer~="")then

 	--###################### recherche de sujet ###########################################################################
 			tabSujet = getMultiple(seq,"#sujet")
 			sujet =dernier(tabSujet)
 			--sujet = gettag(seq,"#sujet")

 			if(sujet=="")then-- on ne trouve pas de sujet normal alors on cherche un sujet YN dans le pire des cas
 				sujet=gettag(seq,"#sujetYN")
 				boolFindSujet =false
 			end
 	--#################### fin recherche de sujet ########################################################################

 			

 	--###################### recherche du context ###########################################################################
 			if(context=="")then
				if( sujet=="he" or sujet=="she" or sujet=="it" or sujet=="him" or sujet=="her" or sujet=="its")then
					while (sujet=="he" or sujet=="she" or sujet=="it" or sujet=="him" or sujet=="her" or sujet=="its") do
 						io.write("\n> ") 
						tmpSujet = io.read()
						sujet=tmpSujet
					end
					context=sujet
 					boolContextVide=true
 				else
 					context=sujet
 					boolContextVide=true
 				end
 			else

 				if(context~="" and( sujet=="he" or sujet=="she" or sujet=="it" or sujet=="him" or sujet=="her" or sujet=="its") )then
 					sujet =context
 				elseif (context~=sujet)then
 					context =sujet
 				end

 			

 			end

 			print("context = "..context)
 	--###################### recherche du context ###########################################################################



 	--################### recherche de aRepondre ########################################################################
 			aRep = gettag(seq, "#aRepondre")
 			if(aRep=="")then --on ne trouve pas de aRepondre du coup on cherche aVerifier dans le pire des cas
 				aRep=gettag(seq,"#aVerifier")
 				boolFindArep=false
 			end

 			ret = transform(aRep,seq)-- on recherche le tag des synonymes , afin qu'on puisse accèder dans la bd
 			aRep=ret
 			print("tag de aRepondre est : "..aRep)
 	--################### fin recherche de aRepondre ########################################################################



 	--################## accès bd ##############################################################################################################################
 			-- result = rechercheBD("catelyn stark","husband",lexiconHouseLexique)
 			--print("sujet : "..sujet.." , aRepondre = "..aRep)
 			result,compt = rechercheBD(sujet,aRep,lexiconHouseLexique)
 			-- result = rep2param(sujet,aRep)

 			 if(result==nil)then 			 
 			 	print("result est null")
 			 else
	 			if(result=="")then
	 				if(boolYNAnswer==true)then
	 			 		print("Non, nous n'avons pas trouvé la réponse à votre question. ")
	 				else
	 			 		print(" nous n'avons pas trouvé la réponse à votre question. ")
	 			 	end
	 			else
	 				if(boolYNAnswer==true)then
	 					print("Oui je sais et la response est : "..result.." et compteur = "..compt)
	 				else
	 			 		print("la response est : "..result.." et compteur = "..compt)
	 			 	end

	 			end
 			 end
 	--################### fin accès bd ##############################################################################################################################


 	--################### sauvegarde du context , type de la question et la question  ########################################################################
 		historique.motAdemander=motNotFind
 		historique.contextHis =context
 		historique.type="Normal"
 		historique.question =line
 		table.insert( tabHistorique, historique)
 		--print("historique : mot à revérifier à l'utilisateur = "..tabHistorique[1].motAdemander.." |context = "..tabHistorique[1].contextHis.." | type = "..tabHistorique[1].type.." | question = "..tabHistorique[1].question )
 	--################### Fin sauvegarde du context , type de la question et la question  ########################################################################


 --############################################################# FIN Question normal ####################################################################################################
 --###########################################################################################################################################################












 --############################################################# Question Yes No ##################################################################################
 --###########################################################################################################################################################


 		elseif (qYN ~="") then -- gestion des question yes no  
 			 
 		
 	--###################### recherche de sujet #####################
 			tabSujet = getMultiple(seq,"#sujetYN")
 			sujet =dernier(tabSujet)
 			--sujet = gettag(seq,"#sujet")

 			if(sujet=="")then-- on ne trouve pas de sujet normal alors on cherche un sujet YN dans le pire des cas
 				sujet=gettag(seq,"#sujet")
 				boolFindSujet =false
 			end
 	--#################### fin recherche de sujet ##################





 	--###################### recherche du context ###########################################################################
 			if(context=="")then
				if( sujet=="he" or sujet=="she" or sujet=="it" or sujet=="him" or sujet=="her" or sujet=="its")then
					while (sujet=="he" or sujet=="she" or sujet=="it" or sujet=="him" or sujet=="her" or sujet=="its") do
 						io.write("\n> ") 
						tmpSujet = io.read()
						sujet=tmpSujet
					end
					context=sujet
 					boolContextVide=true
 				else
 					context=sujet
 					boolContextVide=true
 				end
 			else

 				if(context~="" and( sujet=="he" or sujet=="she" or sujet=="it" or sujet=="him" or sujet=="her" or sujet=="its") )then
 					sujet =context
 				elseif (context~=sujet)then
 					context =sujet
 				end

 			end

 			

 			print("context = "..context)
 	--###################### recherche du context ###########################################################################





 	--################### recherche de aRepondre ##################
 			aRep = gettag(seq, "#aVerifier")
 			if(aRep=="")then --on ne trouve pas de aRepondre du coup on cherche aVerifier dans le pire des cas
 				aRep=gettag(seq,"#aRepondre")
 				boolFindArep=false
 			end

 			ret = transform(aRep,seq)-- on recherche le tag des synonymes , afin qu'on puisse accèder dans la bd
 			aRep=ret
 			print("tag de aRepondre est : "..aRep)

 	--################### fin recherche de aRepondre ##################


 	--################### recherche de valeur du BD proposé par l'utilisateur ##################
			valBD = gettag(seq, "#valeurBd")
 			if(aRep=="")then --on ne trouve pas de aRepondre du coup on cherche aVerifier dans le pire des cas
 				aRep=gettag(seq,"#aRepondre")-- le cas ou la valeur du bd est identique que le aRepondre
 				boolFindArep=false
 			end


 	--################### fin recherche de valeur du BD proposé par l'utilisateur ##################



 	--################## accès bd ##################
 			-- result = rechercheBD("catelyn stark","husband",lexiconHouseLexique)
 			--print("sujet : "..sujet.." , aRepondre = "..aRep)
 			result,compt = rechercheBD(sujet,aRep,lexiconHouseLexique)
 			-- result = rep2param(sujet,aRep)

 			 if(result==nil)then 			 
 			 	print("result est null")
 			 else
	 			if(result=="")then
	 			 		print("Non")
	 				
	 			else

	 				print("la valeur proposer par l'utilisateur est : "..valBD.."  et la valeur du BD est : "..result)
	 				if(string.find(result, valBD)~=nil)then

	 					print("Oui")

	 				elseif(string.find(valBD,result)~=nil)then
	 					print("Oui")

	 				else
	 					print("Non")
	 				end

	 			end
	 		 
 			 end
 	--################### fin accès bd ##################
 
 		end
 

 	 
 
 	--######################### fin Connexion avec la bd ############################




	--################### sauvegarde du context , type de la question et la question  ##################
		historique.motAdemander=motNotFind
 		historique.contextHis =context
 		historique.type="YN"
 		historique.question =line
 		table.insert( tabHistorique, historique)
 	--	print("historique : mot à revérifier à l'utilisateur = "..tabHistorique[1].motAdemander.." |context = "..tabHistorique[1].contextHis.." | type = "..tabHistorique[1].type.." | question = "..tabHistorique[1].question )
	--################### Fin sauvegarde du context , type de la question et la question  ##################

 		seq:dump()

 	else
 		print("icici")

	end 
 



 --############################################################# FIN Question Yes No ##################################################################################
 --###########################################################################################################################################################



end
