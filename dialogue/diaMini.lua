dark = require("dark")

math.randomseed(os.time())

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
 


-- return tout les string dans un phrase appartenant à un tag 
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



-- return true si un des deux mot contient l'autre , et false sinon
function findVal( tab , valUser)
 	bol =false
	--print("valUser = "..valUser)
 
	for key,val in pairs(tab)  do
		str =string.lower(val)
		if(str~="")then

			if(string.find(valUser,str)~=nil)then
				bol =true
					--	print("aaaaaaaaaaaaaa table = "..val)

			elseif(string.find(str,valUser)~=nil)then
				bol =true

			end
		end
	end
	return bol
end



-- renvoye le nom du tag d'un string 
function transform(str,lseq)
	--a complèter avec tout les nom des attributs , et mettre les mots composé en premiers
	local bdTags = {"#paternal-grandfather","#father-in-law-and-uncle","#son-half-brother-half-uncle","#great-uncle","#maternal-great-uncle","#uncle-by-marriage",
		"#paternal-uncle","#maternal-uncle","#father-uncle","#mother-first-cousin-once-removed",
		"#brother-cousin","#first-cousin","#second-cousin","#sister-cousin",
		"#cousin-lover","#distant-cousin","#brother-first-and-third-cousin","#nieces-by-marriage","#great-nieces",
		"#distant-descendant","#grandson-great-nephew","#nephew-by-marriage","#nephew-first-cousin","#great-great-nephew",
		"#double-grandmother-first-cousin","#aunt-and-mother-in-law","#aunt-sister","#aunt-by-marriage","#bastard-half-brother","#half-brother-in-law",
		"#half-brother","#sister-in-law","#twin-sister","#bastard-half-sister","#half-sister","#maternal-grandfather",
		"#father-maternal-grandfather-husband","#father-grandfather","#son-nephew","#half-nephew","#legal-father",
		"#father-in-law","#grandmother-in-law","#maternal-grandmother","#paternal-grandmother",
		"#daughter","#maternal","#mother","#father","#aunt","#oncle","#grandfather","#grandmother","#sister","#brother",
 		"#maternal-aunt","#paternal-aunt","#brother-in-law","#first","#second","#third","#fourth",
		"#cousin","#cousins ","#niece","#descendant","#nephew","#actor","#season","#type","#age",
		"#founder","#seat","#allegiance","#sovereign","#aka","#lord","#people","#culture","#firstSeen","#die",
		"#last","#titles","#place","#night","#bastard","#visit","#wife","#region","#founder","#military","#heir","#weapon","#vassals","#words","#prononciation","#religion"}
	
	for key,val in pairs(bdTags) do
	
		tab=getMultiple(lseq,bdTags[key])

		if(tab~="")then
			for key2,val2 in pairs(tab)  do

				if(string.find(tab[key2],str)~=nil)then
					
					resTran = string.gsub(val,"#","") 
					resTran = string.gsub(resTran,"-"," ") 

					if(resTran=="military")then -- faire pareil pour wife car il y a plusieur de nom attribut pour wife
						return "militarySize"
					else
						--print("resTran = " ..resTran)
						return resTran
					end
				end
			end
		end
	end
	return ""
end


-- return  0= 0 tout les str sont null ,   1= un str non null, 2 = deux str non null, 3 = trois str non null
function isPresence(str1, str2, st3)
	local compt =0

	if(str1~="")then
		compt=compt+1
	end
	if(str2~="")then
		compt=compt+1
	end
	if(str3~="")then
		compt=compt+1
	end
	

	return compt
 end



-- return la dernière valeur du tableau qui est passé en param
function dernier( tab ) --tab = un tableau de 1 dimension 
	res2 =""
	for key =1,  #tab do
		 res2=tab[key] 
		-- print("res = "..res2)
	end
	return res2
end






-- elle renvoye la valeur dand la base de donnée, prend en param le sujet(sujetV), l'objet à repondre ou le nom de l'attribut (aRepVar), et les nom des maison
function rechercheBD(sujetV, aRepVar, tabHouse)

	local db2Var = dofile("db.txt")
	tmp=""
	resultVar=""
	maison =""
	compt=0
	tab={}


	--[[
	for key,val in pairs(db2Var["house stark"]['characters']["arya stark"]['family']) do
		if(string.find(key, "sister")~=nil)then
			print(" key = "..key)
		end
	end
	]]--
	k=0



	for key =1, #tabHouse do

		maison = tabHouse[key]
		maison = maison:gsub(",","")
		if( db2Var[maison]~=nil)then

			if( db2Var[maison]["characters"]~=nil)then

				if(db2Var[maison]['characters'][sujetV]~=nil)then
 			   		--print("##############le sujet : "..sujetV.." et a repoondre "..aRepVar)
                    

					if(db2Var[maison]['characters'][sujetV][aRepVar]~=nil) then
						
								 
								local size = #db2Var[maison]['characters'][sujetV][aRepVar]
								if(aRepVar == "season") then 

									for key,val in pairs(db2Var[maison]['characters'][sujetV][aRepVar]) do 
										--print("val : "..val)
										table.insert(tab, val)
		 							end
									return tab,size,1
								else

									--print("val : "..db2Var[maison]['characters'][sujetV][aRepVar])
									table.insert(tab, db2Var[maison]['characters'][sujetV][aRepVar])
									return tab,1,1
								end	
							 

						else

 						if( aRepVar=="husband" or aRepVar == "daughter" or aRepVar == "son" or aRepVar == "wife" or aRepVar == "father"or aRepVar == "mother"or aRepVar == "brother"or aRepVar =="sister" or aRepVar == "uncle by marriage" 
							or aRepVar =="paternal aunt" or aRepVar == "bastard" or aRepVar =="paternal uncle" or aRepVar =="maternal grandfather" or aRepVar =="maternal grandmother" or aRepVar =="maternal uncle" 
							or aRepVar =="maternal aunt" or aRepVar =="maternal great - uncle" or aRepVar =="maternal great - aunt" or aRepVar == "brother - in - law" or aRepVar =="maternal")  then
					 		
					 		if(db2Var[maison]['characters'][sujetV]['family'] ~= nil) then
									tmpARepVar = ""

								local cmptMatch = 0
								for key,val in pairs(db2Var[maison]['characters'][sujetV]['family']) do									
									if(string.find(string.gsub(key,"(.*)"," %1 "), "[^%a]"..aRepVar.."[^%a]")~=nil)then
										tmpARepVar = key
										cmptMatch = cmptMatch + 1
									end
						    		if (db2Var[maison]['characters'][sujetV]['family'][tmpARepVar] ~= nil  ) then  			
						   				local i =1
												
						   				if(db2Var[maison]['characters'][sujetV]['family'][tmpARepVar][i]~=nil)then
				    		 				while db2Var[maison]['characters'][sujetV]['family'][tmpARepVar][i] ~= nil do
							   					--print("##############le sujet : "..sujetV.." et a repoondre "..aRepVar)							
						 	 						tmp = db2Var[maison]['characters'][sujetV]['family'][tmpARepVar][i]
						 	 						table.insert(tab,tmp)
						 	 						tmp=""
						 	 						compt=compt+1					 							
					 							i=i+1
											end
										else
												tmp = db2Var[maison]['characters'][sujetV]['family'][tmpARepVar]						 	 					 
						 	 					table.insert(tab,tmp)
						 	 					tmp=""
						 	 					compt =compt+1
										end
									
									end
									tmpARepVar=""
								end
								return tab,compt,cmptMatch
							end
						




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
 
	tab[1] = resultVar



	return tab,compt,1

end






--######################################################### Génération des réponses #################################################################################
-- verif : 0 si la reponse est fausse, 1 sinon pour les question YesNo
-- comptMatch : dans le cas ou il y a plusieurs maniere de dire un mot  
-- questionType ==>  1 : YesNo 2 : YesNoAnswer 3 : Normal
function generation(numberResponse, questionType, sujet, aRepondre, aVerifier, reponse, verif, comptMatch)

	--[[if(reponse=="")then
			print("vide")
	else
		print(" non vide")
	end]]--

	--	print("verif = "..verif.." et type : "..questionType.. " et nb = "..numberResponse.. " et sujet = "..sujet)
    
    if (verif == 0 and questionType == 1) then 
        return generateYesNoResponse(verif)  
    elseif (verif == 1 and questionType == 1) then 
        return generateYesNoResponse(verif)          
    elseif (numberResponse == 0) then
        return generateNoResponse(sujet,aRepondre)
    elseif (numberResponse == 1) then
        -- Test questionType 
        if (questionType == 3) then 

            return generateNormalResponse(sujet,aRepondre,reponse) 
        elseif (questionType == 2) then
            return generateYesNoAnswerResponse(sujet,aRepondre,reponse)
        end        
    elseif(numberResponse ~= 1) then 
        if (questionType == 3 ) then
            return generateNormalMultipleResponse(sujet,aRepondre,reponse,numberResponse,comptMatch)  
        end
    end  
end

function generateYesNoResponse(val)
    if val == 0 then

        local response =
        {
            [1] = "No it's not correct",
            [2] = "Sorry for you but your answer is wrong",
            [3] = "No your information is not correct",
        }
        local index = math.random(#response)
         print(response[index])
    else 
        local response =
        {
            [1] = "Yes it is",
            [2] = "Of course",
            [3] = "It's correct",
            [3] = "You are right",
        }
        local index = math.random(#response)
        print(response[index])
    end    
end    

function generateNormalMultipleResponse(sujet,tag,reponse,numberResponse,comptMatch)
   -- print(comptMatch)
  -- 	print("sujet = "..sujet.." et tag : "..tag.. " et nb rep = "..numberResponse.. " et comptMatch = "..comptMatch)

    local resultVar=""
    local tmp 
	if numberResponse > 4 then 
		for i = 1, 4 do
			tmp = resultVar .. reponse[i] .. ","
			resultVar = tmp
        	tmp = ""
		end
	else 
		for key,val in pairs(reponse) do 
	        tmp = resultVar .. val .. ","
	        resultVar = tmp
	        tmp = ""
   		 end
    end

    if comptMatch ~= nil then 
  		if comptMatch >1 then
	  		if numberResponse > 4 then
				local response = 
			    {
			        [1] = "They are many answers, here the first four : " .. resultVar .. "\n , i have many type of response to give you, can you be more precise please ", 
			        [2] = "They are more than four answer, here they are : " .. resultVar .. '\n can you give more information please because i know many other way to find your information ?' 
			    }
		    	local index = math.random(#response)
		    	print(response[index]) 
		    	return true
	    	else
	    		local response = 
			    {
			        [1] = "Here are the answer" .. resultVar .. "\n can you be more precise please beacuse i know other tag to answer you", 
			        [2] = "They are "..numberResponse .. " answer : " .. resultVar .. "\n i have many other that corresponding to your request, can you give more information please ?", 
			    }
		    	local index = math.random(#response)
		    	print(response[index]) 
		    	return true
		    end 
		

		else
			local response = 
			    {
			        [1] = "Here are the answer " .. resultVar .."but there are others", 
			        [2] = "here the first four  answer : " .. resultVar .. "and there are others", 
			    }
		    	local index = math.random(#response)
		    	print(response[index]) 
		    	return false
		end  
	else 
		if numberResponse > 4 then
			local response = 
		    {
		        [1] = "They are many answers, here the first four : " .. resultVar .. ", but there are others", 
		        [2] = "They are more than four answer, here they are : " .. resultVar .. " and ther are others", 
		    }
	    	local index = math.random(#response)
	    	print(response[index])
	    	return false 
    	else
    		local response = 
		    {
				[1] = "There are " .. numberResponse .. " answers : " .. resultVar,	        
		    }
		    if numberResponse ~= 1 then
				response[2] = "All answers are : " ..resultVar
			else 
				response[2] = "The answer is " ..resultVar
			end	
	    	local index = math.random(#response)
	    	print(response[index])
	    	return false
	    end  	
	end	
end    

function generateNoResponse(sujet,tag)
   -- print("DANS NO RESPONSE " .. "Suejt " .. sujet .. "tag" .. tag)

    if sujet == "" then 
        local response =
        {
            [1] = "I am sorry i don't know the answer", 
            [2] = "Sorry, i don't have an answer to your question",
            [3] = "Please excuse me, but I don't know the response,",
            [4] = "So sorry, but i don't know ",
        }

        local index = math.random(#response)
        print(response[index])
    elseif tag == "" then
        local response =
        {
            [1] = "I am sorry i don't know what you are searching", 
            [2] = "I don't know what you are looking for",
            [3] = "I am sorry but i can't give you an answer to your request",
            [4] = "I don't understand what you are talking about",
        }
        local index = math.random(#response)
        print(response[index]) 
    else 
    	local response =
        {
            [1] = tag .. " is not a valid attribute for " .. sujet, 
            [2] = "I can't give you an answer for " .. tag .." of " ..sujet,
            [3] = sujet .. " does not have a " ..tag .." information",
        }
        local index = math.random(#response)
        print(response[index]) 
    end	
end

function generateNormalResponse(sujet,tag,reponse) 
	 
 --	print("sujet : "..sujet.." et tag = "..tag.." et reponse : ")
    local response =
        {
            [1] = reponse[1] .. " is the " .. tag .. " of " .. sujet,
            [3] = "the answer is " .. reponse[1],
            [4] = "It's " .. reponse[1],
            [5] = "The " .. tag .. "of" .. sujet .."is" .. reponse[1],
        }
        local index = math.random(#response)
        print(response[index]) 
end    


function generateYesNoAnswerResponse(sujet,tag,reponse) 
	
    local response =
        {
            [1] = "Yes " .. reponse[1] .. " is the " .. tag .. " of " .. sujet,
            [3] = "You are right " .. "the answer is " .. reponse[1],
            [4] = "It's " .. reponse[1] .. ", well done",
            [5] = "The " .. tag .. "of" .. sujet .."is" .. reponse[1] .."it's correct",
        }
        local index = math.random(#response)
        print(response[index]) 
end 


--######################################################### FIN Génération des réponses #################################################################################













--######################################################### Début des pattern #################################################################################


local main = dark.pipeline()

main:basic()


--lexicon sur les pronoms 
main:lexicon("#he", {"he", "his", "hiself","him"})
main:lexicon("#she",{"she", "her","hers", "herself"})
main:lexicon("#it", {"it", "its","itself"})


--lexicon attribut de la bd :
main:lexicon("#seat", {"base", "seat","throne","centre" })
main:lexicon("#allegiance", {"allegiance","adherence","constancy","fidelity","obedience","obligation","loyalty"})
main:lexicon("#sovereign" ,{"sovereign","chief","emperor","empress","king","monarch"})
main:lexicon("#aka", {"aka", "as known as","nickname","pseudo"})
main:lexicon("#type", {"type"})
main:lexicon("#age",{"age", "old"})
main:lexicon("#founder",{"founder", "creator","leader"})
main:lexicon("#culture", {"culture","ceremonie"})
main:lexicon("#firstSeen", { "first time", "first seen", "first apparition", "first appearance"})
main:lexicon("#die",{"die", "died", "kill", "killed","death"})
main:lexicon("#last",{"last","at the end", "the end","end","lastest","final"})
main:lexicon("#titles",{"titles","appellation","privilege"})
main:lexicon("#place",{"place","area","locus","point","position","site","station"})
main:lexicon("#night",{"night watches","night guardian","guardian","night","darkness"})
main:lexicon("#bastard",{"bastard","by-blow","illegitimate child","whoreson"})
main:lexicon("#visit",{"go to see","went to see","goes to see","visit","visited"})
main:lexicon("#region", {"region", "country", "district", "division", "expanse", "land", "locality", "part", "patch", "location","location","live", "lived", "lives", "shack", "living", "shackes", "shacking", "shacked","dwell", "inhabit", "inhabited", "inhabits","lodge","lodges","lodged", "tenant", "tenants", "tenanted","located", "located","locating"})
main:lexicon("#founder", {"founder","beginner","initiator"})
main:lexicon("#military", {"military", "armed forces", "army", "forces", "services"})
main:lexicon("#heir", {"heir","beneficiary","heiress","next in line", "scion", "successor"})
main:lexicon("#weapon", {"secret weapon","weapon"})
main:lexicon("#vassals",{"vassals","vassal","bondman", "bondservant", "bondsman", "liegeman", "retainer", "serf", "slave", "subject", "thrall", "varlet"})
main:lexicon("#words", {"words","word", "lyrics", "text"})
main:lexicon("#prononciation",{"pronounciation", "pronounce", "accent", "accentuation", "articulate", "articulation", "diction", "elocution", "enunciation", "enunciate"})
main:lexicon("#religion",{"beliefs","belief","religions","religion"})
main:lexicon("#actor", {"comedian","actor","performed", "performs","perform","performing","play","plays", "played", "playing","represent","represents","representing","represented", "interpret", "interpreted", "interpreteding", "interprets"})
main:lexicon("#actorSyno" , {"actor","comedian"})
main:lexicon("#season", {"season","seasons"})
main:lexicon("#lord", {"lord","commander","governor","king","leader"})

--lexicon famille:
main:lexicon("#family", {"parent", "daughter", "sister", "wife", "husband", "father","mother","son","marry","married", "wedded", "couple","grandfather","grandmother","brother"})
main:lexicon("#daughter", {"daughters", "daughter"})
main:lexicon("#maternal", {"maternal"})
main:lexicon("#mother", {"mothers","mother", "mom"})
main:lexicon("#father", {"fathers","father", "dad"})
main:lexicon("#aunt", {"aunts","aunts"})
main:lexicon("#oncle", {"oncles","oncle"})
main:lexicon("#grandfather",{"grandfathers","grandfather"})
main:lexicon("#grandmother",{"grandmothers","grandmother"})
main:lexicon("#sister", {"sister"})
main:lexicon("#brother", {"brother"})
main:lexicon("#maternal-aunt",{"maternal aunt"})
main:lexicon("#aunt-and-mother-in-law",{"aunt and mother in law"})
main:lexicon("#aunt-sister",{"aunt sister"})
main:lexicon("#aunt-by-marriage",{"aunt by marriage"})
main:lexicon("#paternal-aunt",{"paternal aunt"})
main:lexicon("#bastard-half-brother",{"bastard half brother"})
main:lexicon("#brother-in-law",{"brother in law"})
main:lexicon("#half-brother",{"half brother"})
main:lexicon("#half-brother-in-law",{"half brother in law"})
main:lexicon("#half-sister",{"half sister"})
main:lexicon("#bastard-half-sister",{"bastard half sister"})
main:lexicon("#twin-sister",{"twin sister"})
main:lexicon("#sister-in-law",{"sister in law"})
main:lexicon("#father-grandfather",{"father grandfather"})
main:lexicon("#father-maternal-grandfather-husband",{"father maternal grandfather husband"})
main:lexicon("#maternal-grandfather",{"maternal grandfather"})
main:lexicon("#paternal-grandfather",{"paternal grandfather"})
main:lexicon("#father-in-law-and-uncle",{"father in law and uncle"})
main:lexicon("#son-half-brother-half-uncle",{"son half brother half uncle"})
main:lexicon("#great-uncle",{"great uncle"})
main:lexicon("#maternal-great-uncle",{"maternal great uncle"})
main:lexicon("#uncle-by-marriage",{"uncle by marriage"})
main:lexicon("#paternal-uncle",{"paternal uncle"})
main:lexicon("#maternal-uncle",{"maternal uncle"})
main:lexicon("#father-uncle",{"father uncle"})
main:lexicon("#mother-first-cousin-once-removed",{"mother-first-cousin","mother first cousin"})
main:lexicon("#brother-cousin",{"brother cousin","brother-cousin"})
main:lexicon("#first-cousin",{"first cousin","first-cousin"})
main:lexicon("#second-cousin",{"second-cousin","second-cousin"})
main:lexicon("#sister-cousin",{"sister cousin","sister-cousin"})
main:lexicon("#cousin-lover",{"cousin lover","cousin-lover"})
main:lexicon("#distant-cousin",{"distant-cousin","distant cousin"})
main:lexicon("#cousin",{"cousin"})
main:lexicon("#cousins",{"cousins"})
main:lexicon("#brother-first-and-third-cousin",{"brother first and third cousin","brother-first and third-cousin","brother-first-third cousin","brother-first-and-third cousin"})
main:lexicon("#nieces-by-marriage",{"nieces-by-marriage","nieces by marriage"})
main:lexicon("#great-nieces",{"great-nieces","great nieces"})
main:lexicon("#niece",{"niece"})
main:lexicon("#distant-descendant",{"distant descendant","distant-descendant"})
main:lexicon("#descendant",{"descendant"})
main:lexicon("#son-nephew",{"son nephew"})
main:lexicon("#grandson-great-nephew",{"grandson great nephew","grandson-great-nephew"})
main:lexicon("#nephew-by-marriage",{"nephew-by-marriage","nephew by marriage"})
main:lexicon("#half-nephew",{"half-nephew","half nephew"})
main:lexicon("#nephew-first-cousin",{"nephew-first-cousin","nephew first cousin"})
main:lexicon("#great-great-nephew",{"great-great-nephew","great great nephew"})
main:lexicon("#nephew",{"nephew"})
main:lexicon("#legal-father",{"legal father","legal-father"})
main:lexicon("#father-in-law",{"father-in-law","father in law"})
main:lexicon("#grandmother-in-law",{"grandmother-in-law","grandmother in law"})
main:lexicon("#double-grandmother-first-cousin",{"double grandmother first cousin","double-grandmother-first-cousin"})
main:lexicon("#maternal-grandmother",{"maternal-grandmother","maternal grandmother"})
main:lexicon("#paternal-grandmother",{"paternal-grandmother","paternal grandmother"})
main:lexicon("#wife", {"wife unborn child - to be named","daughter - wife","wife"})

--lexicon type de question : 
main:lexicon("#qNumerique", { "how many", "how much", "how often"})
main:lexicon("#qInfoS", { "what's"  , "what is",   "who", "who's" , "give me one","give me","give me a", "give me an", "how", "which's", "which is","which","what"})
main:lexicon("#qInfoP", { "what're" , "what are", "who", "who're", "who are","give me all","give me", "give me some" ,"which are", "which're", "in which"})
main:lexicon("#qLieu",{"where", "where's", "where're", "where are", "where is"})
main:lexicon("#qTemp",{ "when do you see","when's", "when're", "when are", "when is","when"})
main:lexicon("#enTeteYN",{ "do you know the information that","is" , "do you know if","do you know " ,"do you think"})
main:lexicon("#shortQ",{"and also for", "and for", "and"})

--lexicon verbe :
main:lexicon("#Auxiliaire",{"do", "does", "could", "would", "should"})
main:lexicon("#be", {"be","is","Is","Are", "are", "were", "was", "had been", "has been"})
main:lexicon("#apparaitre",{"appears", "appear","appeared","arise","arised","show","showed","attend","attended"})

--lexicon de preposition :
main:lexicon("#prepoOf",{"of","from"})
main:lexicon("#prepo",{"the","a","an", "in"})
 
--lexicon de personnage: 
main:lexicon("#people" , {"part"})

 -- apartenance
main:lexicon("#apartenance", {" ' s"," ‘ s", " ’ s","‘s"})
 
 --lexicon aurevoir
main:lexicon("#bye",{"bye","bye bye","ciao","good bye","see you"})

-- lexicon chiffre
main:lexicon("#first",{"first","one","1"})
main:lexicon("#second",{"secon","two","2"})
main:lexicon("#third",{"third","three","3"})
main:lexicon("#fourth",{"fourth","four","4"})

--lexicon yes
main:lexicon("#yes",{ "yes please","please","yes of course","yes i want that","yes i want","of course", "ok", "alright", "let's go", "come on", "yeah", " why not","yes"})
main:lexicon("#no",{"no thanks" ,"i don't want it","nop", "no"})


--######################################################chargement du lexicon : maison, lieu, et perso######################################################
listHouseLexique = {}
lexiconHouseLexique = {}
for line in io.lines("lexiques/lexique_houses.txt") do
	listHouseLexique[line] = {}
	listHouseLexique[line][line] = line
	listHouseLexique[line][string.gsub(line,".-%s","")] = string.gsub(line,".-%s","")
	lexiconHouseLexique[#lexiconHouseLexique+1] = line
	lexiconHouseLexique[#lexiconHouseLexique+1] = string.gsub(line,".-%s","")

end
main:lexicon("#maison", lexiconHouseLexique)
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
		--listCharacterLexique[line][prenom] = prenom
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
	listLocationLexique[line] = {}
	listLocationLexique[line][line] = line
	lexiconLocationLexique[#lexiconLocationLexique+1] = line
end
--print(serialize(listLocationLexique))
main:lexicon("#lieu", lexiconLocationLexique)
--######################################################fin du chargement du lexicon lieu, maison , perso######################################################






-- debut des pattern
main:model("mdl/postag-en")

main:pattern([[
	[#VB 
		#be|#apparaitre|#actor
	]
]])

main:pattern([[
	[#attributeBD 
		#paternal-grandfather|#father-in-law-and-uncle|#son-half-brother-half-uncle|#great-uncle|#maternal-great-uncle|#uncle-by-marriage
		|#paternal-uncle|#maternal-uncle|#father-uncle|#mother-first-cousin-once-removed
		|#brother-cousin|#first-cousin|#second-cousin|#sister-cousin
		|#cousin-lover|#distant-cousin|#brother-first-and-third-cousin|#nieces-by-marriage|#great-nieces
		|#distant descendant|#grandson-great-nephew|#nephew-by-marriage|#nephew-first-cousin|#great-great-nephew
		|#double-grandmother-first-cousin
		|#aunt-and-mother-in-law|#aunt-sister|#aunt-by-marriage|#bastard-half-brother|#half-brother-in-law
		|#half-brother|#sister-in-law|#twin-sister|#bastard-half-sister|#half-sister|#maternal-grandfather
		|#father-maternal-grandfather-husband|#father-grandfather|#son-nephew|#half-nephew|#legal-father
		|#father-in-law|#grandmother-in-law|#maternal-grandmother|#paternal-grandmother
		|#daughter | #maternal |#mother|#father|#aunt|#oncle|#grandfather|#grandmother|#sister|#brother
 		|#maternal-aunt|#paternal-aunt|#brother-in-law
		|#cousin|#cousins |#niece|#descendant|#nephew|#actor|#season|#type|#age
		|#founder|#seat|#allegiance|#sovereign|#aka|#lord|#people|#culture|#firstSeen|#die
		|#last|#titles|#place|#night|#bastard|#visit|#wife|#region|#founder|#military|#heir|#weapon|#vassals|#words|#prononciation|#religion
		
	]
	]])


main:pattern([[
	[#attributeBD2 
		#paternal-grandfather|#father-in-law-and-uncle|#son-half-brother-half-uncle|#great-uncle|#maternal-great-uncle|#uncle-by-marriage
		|#paternal-uncle|#maternal-uncle|#father-uncle|#mother-first-cousin-once-removed
		|#brother-cousin|#first-cousin|#second-cousin|#sister-cousin
		|#cousin-lover|#distant-cousin|#brother-first-and-third-cousin|#nieces-by-marriage|#great-nieces
		|#distant descendant|#grandson-great-nephew|#nephew-by-marriage|#nephew-first-cousin|#great-great-nephew
		|#double-grandmother-first-cousin
		|#aunt-and-mother-in-law|#aunt-sister|#aunt-by-marriage|#bastard-half-brother|#half-brother-in-law
		|#half-brother|#sister-in-law|#twin-sister|#bastard-half-sister|#half-sister|#maternal-grandfather
		|#father-maternal-grandfather-husband|#father-grandfather|#son-nephew|#half-nephew|#legal-father
		|#father-in-law|#grandmother-in-law|#maternal-grandmother|#paternal-grandmother
		|#daughter | #maternal |#mother|#father|#aunt|#oncle|#grandfather|#grandmother|#sister|#brother
 		|#maternal-aunt|#paternal-aunt|#brother-in-law
		|#cousin|#cousins |#niece|#descendant|#nephew|#actor|#season|#type|#age
		|#founder|#seat|#allegiance|#aka|#lord|#people|#culture|#firstSeen|#die
		|#last|#titles|#place|#night|#bastard|#visit|#wife|#region|#founder|#military|#heir|#weapon|#vassals|#words|#prononciation|#religion
		
	]
	]])

--patterne question normal
main:pattern([[
	[#qNormal
		^(#qNumerique | #qLieu |#qInfoP |#qInfoS |#qTemp) .*

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
		| <(#sujet #apartenance (#POS=ADJ | #POS=CON #POS=ADJ )* ) (#attributeBD)
		|#attributeBD2
	]
]])

main:pattern([[
	[#aVerifier
		 <( #enTeteYN ) ( [#valeurBd (#sujet|(#w|#d)*) ] (#POS=VRB |#actor | #region)) >(#POS=ADP*   (#perso  |#sujet |#pronom))
		|<( #enTeteYN )  <( #sujet | #pronom) ([#valeurBd (#sujet|(#w |#d)*) ] #prepo? #aRepondre)
		|<(  #sujet #apartenance)  ((#POS=NNC |#attributeBD)* ([#valeurBd (#sujet|(#w |#d)+) ]))
		|<( #enTeteYN ) ((#w)* #aRepondre #prepoOf #sujet #POS=VRB [#valeurBd (#sujet|(#w |#d)+) ])
		|<( #enTeteYN ) ([#valeurBd (#sujet|(#w |#d)+) ] #aRepondre )
		|<( #enTeteYN  (#sujet|(#w |#d)+)  #aRepondre #POS=ADP*)([#valeurBd (#POS=NNC)+ ])
		|<( #enTeteYN )  ([#valeurBd (#POS=NNC |#attributeBD|#lieu |#maison |#perso)]* #prepo* #aRepondre )
		|<( #enTeteYN  (#sujet|(#w |#d)+)  #POS=ADP)([#valeurBd (#POS=NNC |#season)+ #d ])
		|<(#season) ([#valeurBd (#first|#second|#third|#fourth)])
		| ([#valeurBd (#first|#second|#third|#fourth)]) >(#season)
		|<(#sujet #apartenance) ((#w*)(#aRepondre ) [#valeurBd ((#w*)|#d)*]) 

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


--patterne question Y/N 
main:pattern([[
	[#qYesNo 
		^(#be | (#Auxiliaire #sujet)).*
	]
]])


 main:pattern([[
	[#qShort 
		^(#shortQ) #POS=DET? (#sujet | #aRepondre |#aVerifier | #sujetYN) 
	]
]])

local tags = {
		["#valeurBd"] ="blue",
		["#qYesNoAnswer"] ="blue",
		["#qYesNo"] ="blue",
		["#qNormal"] ="blue",
		["#aRepondre"] ="white",
		["#sujet"]= "red",
		["#lieu"] ="red",
		["#maison"] ="red",
		["#perso"] = "red",
		["#qNumerique"] = "red",
		["#aVerifier"] = "white",
		["#sujetYN"] = "blue",
} 



--######################################################### FIN des pattern #################################################################################




function levenshtein(chercher, dans, tolerance)

	verif = chercher:gsub("%s+","")
	if(verif=="") then return false end
	verif = dans:gsub("%s+","")
	if(verif=="") then return false end
	if(tolerance<0) then return false end

    local str1  = dans:lower()
    local str2 = chercher:lower()
    local len1, len2 = #str1, #str2
    local char1, char2, distance = {}, {}, {}
    str1:gsub('.', function (c) table.insert(char1, c) end)
    str2:gsub('.', function (c) table.insert(char2, c) end)
    for i = 0, len1 do distance[i] = {} end
    for i = 0, len1 do distance[i][0] = i end
    for i = 0, len2 do distance[0][i] = i end
    for i = 1, len1 do
        for j = 1, len2 do
            distance[i][j] = math.min(
                distance[i-1][j] + 1,
                distance[i][j-1] + 1,
                distance[i-1][j-1] + (char1[i] == char2[j] and 0 or 1)
            )
        end
    end
   
	diff = #str1-#str2
	if diff>0 then diff = -diff end
    return distance[len1][len2] - (diff) <= tolerance*#str2, distance[len1][len2]
end

function searchEquivalence(chercher, tab)

	res = {}
	continue = true
	for key,val in pairs(tab) do
		continue = true
		for sKey, sVal in pairs(val) do
			match = false
			tolerance = 0.35
			while match==false and tolerance<=0.42 do
				match,lev = levenshtein(chercher,sVal,tolerance)
				tolerance=tolerance+0.01
			end
			if(match==true and continue==true) then 
				size = #res+1
				res[size]={}
				res[size]["key"] = key
				res[size]["lev"] = lev
				continue = false
			end
		end
	end

	return res;
end

function minKey(tab)
	--print(serialize(tab))
	if tab~=nil and #tab>0 then
		min = 999
		keyMin = ""
		for key,val in pairs(tab) do 
			if val["lev"]<min then
				min = val["lev"]
				keyMin = val["key"]
			end
		end
		return min,keyMin
	end
end

function chooseBestEquivalence(resCharacter, resHouse, resLocation)
	
	minC, keyMinC = minKey(resCharacter)
	if keyMinC~=nil then 
		--print("Best match resCharacter = {min = " .. minC .. " key = " .. keyMinC .. "}") 
	end
	
	minH, keyMinH = minKey(resHouse)
	if keyMinH~=nil then 
		--print("Best match resHouse = {min = " .. minH .. " key = " .. keyMinH .. "}") 
	end
	minL, keyMinL = minKey(resLocation)
	if keyMinL~=nil then 
		--print("Best match resLocation = {min = " .. minL .. " key = " .. keyMinL .. "}") 
	end

	if(minC==nill and minH==nil and minL==nil) then return nil end
	if minC==nil then minC=999 end
	if minH==nil then minH=999 end
	if minL==nil then minL=999 end

	min = math.min(minC,minH,minL)

	
	if min==minH then return keyMinH end
	if min==minC then return keyMinC end
	if min==minL then return keyMinL end

end







-- todo fct qui permet de choisir entre deux aRepondre , avec des lexicon ayant certain priorité, et renvoye le premier si il y en a un seul

sujetRegex =""
finBoucle =1
result = {}
tabArep={}
context ="" 
motNotFind=""
test=""
ret=""

historique ={
	motAdemander="",
	contextHis="",
	type="",
	question,
	aRep=""
}
line=""
tabHistorique={}
boolTostring = false
recurse = true
local db2 = dofile("db.txt")
boolR =false

local vmain = dark.pipeline() -- pile d'execution
vmain:basic();
vmain:model("mdl/postag-en")
vmain:pattern("[#NAME ((#W ('-' | '.' | /^d['eu]/)?)) {1,}]")

while(boolR==false)do
	print("do you want active the toString(tag) ? (yes / no) ")
	io.write("\n> ") 
	line = io.read()

	line = string.lower(line)
	local res = main(line)
	yes = gettag(res,"#yes")
	no = gettag(res,"#no")

	if(yes~="")then
		boolTostring=true
		boolR=true
	elseif(no~="")then
		boolR=true
	end

end



local sujetBest = ""

print("Hello . Can I help you ? \n\n")

while finBoucle ==1 do
	--os.execute("clear")
 	io.write("\n> ") 
	line = io.read()

	chercher = line
	-- [ DEBUT LEVEINSHTEIN ] --
	vseq = vmain(chercher)
	 local vtags = {
		["#NAME"] = "green",
	}
   	--vseq:dump()
	--print(vseq:tostring(vtags))
	chercher = gettag(vseq,"#NAME")

   	resCharacter = searchEquivalence(chercher,listCharacterLexique)
   if(resCharacter~=nil and #resCharacter>0) then
		--print("Trouve Personnage : "..serialize(resCharacter))
		find = true
   end

   resHouse = searchEquivalence(chercher,listHouseLexique)
   if(resHouse~=nil and #resHouse>0) then
		--print("Trouve House : "..serialize(resHouse))
		find = true
   end

   resLocation = searchEquivalence(chercher,listLocationLexique)
   if(resLocation~=nil and #resLocation>0) then
		--print("Trouve Location : "..serialize(resLocation))
		find = true
   end

   sujetBest = chooseBestEquivalence(resCharacter,resHouse,resLocation)
   if sujetBest~=nil then print("I did not found "..chercher.." but here is something for "..sujetBest)
   else
   		sujetBest = chercher
   end
	-- [ FIN LEVEINSHTEIN ] --
	recurse = true

	while(recurse ==true) do

		recurse = false

		line=line:gsub("‘s","'s")			
		line=line:gsub("’s","'s")
		line=line:gsub("([\',?!:;.()])", " %1 ")
		

		if string.find("//", line) == nil then
			line = string.lower(line)
			line =line:gsub("do you know the information that","is")
			line =line:gsub("do you know which","what is")

	 		local seq = main(line)
	 		print(line)
	 		if(boolTostring==true)then
		    	print(seq:tostring(tags))
			end
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

	 		--print("qNormal = "..qNormal)
	 		--print("qYN "..qYN)



	 		sizeYN =string.len(qYN)
	 		sizeNormal=string.len(qNormal)
	 		sizeYNAnswer = string.len(qYesNoAnswer)


			aRep = gettag(seq, "#aRepondre")
	 		if(aRep=="")then --on ne trouve pas de aRepondre du coup on cherche aVerifier dans le pire des cas
	 			aRep=gettag(seq,"#aVerifier")
	 			boolFindArep=false
	 		end

	 			ret = transform(aRep,seq)-- on recherche le tag des synonymes , afin qu'on puisse accèder dans la bd
	 			aRep=ret


				aVer = gettag(seq, "#aVerifier")
	 			ret = transform(aVer,seq)-- on recherche le tag des synonymes , afin qu'on puisse accèder dans la bd
	 			aVer=ret


	 			sujetTest = gettag(seq,"#sujet")
	  			if(sujetTest=="")then-- on ne trouve pas de sujet normal alors on cherche un sujet YN dans le pire des cas
	 				sujetTest=gettag(seq,"#sujetYN")
	 			end


	 			--	print(" qyn = "..qYN.." et qNormal = "..qNormal.." rt qYesNoAnswer "..qYesNoAnswer)




	 
		--############################################################# Question Yes No ##################################################################################
		--###########################################################################################################################################################


	 		if (qYN ~="" and (qYesNoAnswer=="" and qNormal=="") ) then -- gestion des question yes no   		
	 		--###################### recherche de sujet #####################
	 			tabSujet = getMultiple(seq,"#sujetYN")
	 			
	 			sujet =dernier(tabSujet)
	 			
	 			if(sujet=="")then-- on ne trouve pas de sujet normal alors on cherche un sujet YN dans le pire des cas
	 				sujet=gettag(seq,"#sujet")
	 				boolFindSujet =false
	 				if(sujet=="")then
	 					sujet = sujetBest
	 				end


	 			end
	 		--#################### fin recherche de sujet ##################
	 
	 		--###################### recherche du context ###########################################################################
	 			if(context=="")then
					if( sujet=="he" or sujet=="she" or sujet=="it" or sujet=="him" or sujet=="her" or sujet=="its")then
						while (sujet=="he" or sujet=="she" or sujet=="it" or sujet=="him" or sujet=="her" or sujet=="its") do
	 						print("about who ?")
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
	 		--###################### recherche du context ###########################################################################

	 		--################### recherche de aRepondre ##################
	 			tabArep = getMultiple(seq, "#aRepondre")
	 			aRep =dernier(tabArep)
	 			if(aRep=="")then --on ne trouve pas de aRepondre du coup on cherche aVerifier dans le pire des cas
	 				aRep=gettag(seq,"#aVerifier")
	 				boolFindArep=false
	 			end
	 			--print("tag de aRepondre est : "..aRep)

	 			ret = transform(aRep,seq)-- on recherche le tag des synonymes , afin qu'on puisse accèder dans la bd
	 			aRep=ret
	 		--################### fin recherche de aRepondre ##################


	 		--################### recherche de valeur du BD proposé par l'utilisateur ##################
				valBD = gettag(seq, "#valeurBd")
	 			if(aRep=="")then --on ne trouve pas de aRepondre du coup on cherche aVerifier dans le pire des cas
	 				aRep=gettag(seq,"#aRepondre")-- le cas ou la valeur du bd est identique que le aRepondre
	 				boolFindArep=false
	 			end
	 			print("valeur bd :"..valBD)
	 		--################### fin recherche de valeur du BD proposé par l'utilisateur ##################



	 		--################## accès bd ##################
	 			-- result = rechercheBD("catelyn stark","husband",lexiconHouseLexique)
	 			--print("sujet : "..sujet.." , aRepondre = "..aRep)
	 			result,compt = rechercheBD(sujet,aRep,lexiconHouseLexique)

	 			 if(result==nil)then 			 
		 			 		generation(compt,1,sujet,aRep,valBD,"",0)	
	 			 else
		 			if(result=="")then
		 			 		--print("Non result est vide")
		 			 		generation(compt,1,sujet,aRep,valBD,result,0)	
		 			else
		 				--print("valbd = "..valBD.." et result de la bd : "..result)
		 				--print("la valeur proposer par l'utilisateur est : "..valBD.."  et la valeur du BD est : "..result)
		 				if(findVal(result, valBD)==true)then
		 					--print("Oui")
		 					generation(compt,1,sujet,aRep,valBD,result,1)	

		 				else
		 					--print("Non")
		 					generation(compt,1,sujet,aRep,valBD,result,0)	

		 				end

		 			end
		 		 
	 			 end
	 		--################### fin accès bd ##################
	 
	 		
	     
	    
	 	 
	     
	 		--######################### fin Connexion avec la bd ############################




			--################### sauvegarde du context , type de la question et la question  ##################
			historique.motAdemander=motNotFind
	 		historique.contextHis =context
	 		historique.type="YN"
	 		historique.question =line
	 		 		historique.aRep = aRep

	 		table.insert( tabHistorique, historique)


	 		--print("historique : mot à revérifier à l'utilisateur = "..tabHistorique[1].motAdemander.." |context = "..tabHistorique[1].contextHis.." | type = "..tabHistorique[1].type.." | question = "..tabHistorique[1].question )
			--################### Fin sauvegarde du context , type de la question et la question  ##################

		--############################################################# FIN Question Yes No ##################################################################################
		--###########################################################################################################################################################






		--############################################################# Question short ##################################################################################
		--###########################################################################################################################################################
		 		elseif(qShort~="" and (isPresence(aRep,aVer,sujetTest)==1) and qYN=="" and qNormal=="" )then

	 			historiqueVide =true
	 			if(sujetTest~="")then

	 		 --################## accès bd ##############################################################################################################################
	 			taille = #tabHistorique
				if(tabHistorique[taille]~=null)then
					aRep = tabHistorique[taille].aRep
				end
				while (historiqueVide == true) do
	 			--print("question short ")
			 		if(aRep~="")then
	 		 			print("sujet = "..sujetTest.." et arep = "..aRep)
			 				result,compt = rechercheBD(sujetTest,aRep,lexiconHouseLexique)
			 				print("compt = "..compt)
			 			 --print("resultat = "..result)
			 			 if(result==nil)then 		
	 			 			 		generation(compt,3,sujetTest,aRep,"","",0)	
			 			 else

				 			if(result=="")then
				 			 	
				 			 	--	print(" nous n'avons pas trouvé la réponse à votre question. ")
				 			 		generation(compt,3,sujetTest,aRep,"",result,0)			 	
				 			else	 				
				 			 		--print("la response est : "..result.." et compteur = "..compt)
				 			 		generation(compt,3,sujetTest,aRep,"",result,1)	
				 			end
			 			 end
			 			 historiqueVide = false
			 			else
									print("about what ?")
			 						io.write("\n> ") 
									line2 = io.read()
									line2 = string.lower(line2)
	 								local seq2 = main(line2)
	 								seq2:dump()
									aRep = gettag(seq2, "#aRepondre")
									print("arepondre : "..aRep)
	 								ret = transform(aRep,seq2)-- on recherche le tag des synonymes , afin qu'on puisse accèder dans la bd
	 								aRep=ret 
			 			end
					end
	 		 --################### fin accès bd ##############################################################################################################################
	 			end

		--############################################################# Fin Question short ##################################################################################
		--###########################################################################################################################################################










		--############################################################# Question normal ##################################################################################
		--###########################################################################################################################################################


	 		elseif((qNormal~="" or qYesNoAnswer~="" or (aRep ~="" and sujetTest~="")) and qYN=="" )then

	 		--###################### recherche de sujet ###########################################################################
	 			tabSujet = getMultiple(seq,"#sujet")
	 			sujet =dernier(tabSujet)
	 			--sujet = gettag(seq,"#sujet")
	 			--print("sujet : "..sujet)
	 			if(sujet=="")then-- on ne trouve pas de sujet normal alors on cherche un sujet YN dans le pire des cas
	 				sujet=gettag(seq,"#sujetYN")
	 				boolFindSujet =false
	 				if(sujet=="")then
	 					sujet = sujetBest
	 				end
	 			end
	 		--#################### fin recherche de sujet ########################################################################
	 		

	 		--###################### recherche du context ###########################################################################
	 			if(context=="")then
					if( sujet=="he" or sujet=="she" or sujet=="it" or sujet=="him" or sujet=="her" or sujet=="its" or sujet=="his")then
						 				--print("ici")
						while (sujet=="he" or sujet=="she" or sujet=="it" or sujet=="him" or sujet=="her" or sujet=="its" or sujet=="his") do
	 						print("about who ?")
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
	 				if(context~="" and( sujet=="he" or sujet=="she" or sujet=="it" or sujet=="him" or sujet=="her" or sujet=="its" or sujet=="his") )then
	 					sujet =context
	 				elseif (context~=sujet)then
	 					context =sujet
	 				end
	 			end
	 		--###################### recherche du context ###########################################################################



	 		--################### recherche de aRepondre ########################################################################
	 			aRep = gettag(seq, "#aRepondre")
	 			if(aRep=="")then --on ne trouve pas de aRepondre du coup on cherche aVerifier dans le pire des cas
	 				aRep=gettag(seq,"#aVerifier")
	 				boolFindArep=false
	 			end
	 			ret = transform(aRep,seq)-- on recherche le tag des synonymes , afin qu'on puisse accèder dans la bd
	 			aRep=ret
	 				 			--print("arep = "..aRep)

	 		--################### fin recherche de aRepondre ########################################################################



	 		--################## accès bd ##############################################################################################################################
	 			--print("sujet = "..sujet.." , arep = "..aRep)
	 			result,compt,comptMatch = rechercheBD(sujet,aRep,lexiconHouseLexique)

 	 			--print("result : "..result)
	 			--print("JE SUIS LA " .. comptMatch .. " result ".. result)
	 		

	 			 if(result==nil)then 		
	 			 	--print("result est null")
	 			 	generation(compt,3,sujet,aRep,"","",0,comptMatch)	
	 			 else
		 			if(result=="")then
		 				if(boolYNAnswer==true)then
		 			 		--print("Non, nous n'avons pas trouvé la réponse à votre question. ")
		 			 		generation(compt,2,sujet,aRep,"",result,0,comptMatch)	
		 				else
		 			 	--	print(" nous n'avons pas trouvé la réponse à votre question. ")
		 			 		generation(compt,3,sujet,aRep,"",result,0,comptMatch)	
		 			 	end
		 			else

		 				local continu
		 				if(boolYNAnswer==true)then 
		 					--print("Oui je sais et la response est : "..result.." et compteur = "..compt)
		 					continu = generation(compt,2,sujet,aRep,"",result,1,comptMatch)	
		 					if continu ~= nil then
		 						if continu == true then

		 						end
		 					end		
		 				else

		 			 		--print("la response est : "..result.." et compteur = "..compt)
		 			 		continu = generation(compt,3,sujet,aRep,"",result,1,comptMatch)
		 			 		if continu ~= nil then
		 						if continu == true then 
		 							 
	 									io.write("\n> ") 
										tmpArep = io.read()
										tmpLine =tmpArep
										local seq2 = main(tmpLine)

										qYN2 = gettag(seq2,"#qYesNo")
								 		qYesNoAnswer2 = gettag(seq2,"#qYesNoAnswer")
								 		qNormal2 =gettag(seq2,"#qNormal")

								 		if(qYN2~="" or qYesNoAnswer2~="" or qNormal2~="")then
								 			line = tmpArep
								 		else
								 			line=line:gsub(aRep,tmpArep)
								 		end
										
										print(" la nouvelle question : "..line)
										recurse = true
									 
		 						end
		 					end		
		 			 	end
		 			end
	 			end
	 		--################### fin accès bd ##############################################################################################################################

	 		--################### sauvegarde du context , type de la question et la question  ########################################################################
	 		historique.motAdemander=motNotFind
	 		historique.contextHis =context
	 		historique.type="Normal"
	 		historique.question =line
	 		historique.aRep = aRep
	 		table.insert( tabHistorique, historique)
	 		--print("historique : mot à revérifier à l'utilisateur = "..tabHistorique[1].motAdemander.." |context = "..tabHistorique[1].contextHis.." | type = "..tabHistorique[1].type.." | question = "..tabHistorique[1].question )
	 		--################### Fin sauvegarde du context , type de la question et la question  ########################################################################

		--############################################################# FIN Question normal ####################################################################################################
		--###########################################################################################################################################################
		else
		 			local response =
		        	{
			            [1] = "I am sorry i don't understand", 
			            [2] = "Ok :) but can you reformulate please ? ",
			            [3] = "I don't really get what you mean ",
			            [4] = "Excuse me, but i don't understand",
		        	}
		        	local index = math.random(#response)
		        	print(response[index])	
		end

		if gettag(seq,"#bye") ~= "" then 
			print("Bye, see you soon : ) ")
			finBoucle =0
			recurse = false
		end

		--seq:dump()
		end

	end


end
