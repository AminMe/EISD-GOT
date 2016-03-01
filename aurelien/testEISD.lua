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

-- Permet de récupéré toute les carrière
-- Regarde le nombre d'élèmenet à récupéré, et en fonction de cela, récupère les informations
function getCarriere(seq)
	local pos = seq["#carriere"]
	if #pos == 0 then
		return ""
	end
	local number = #pos
	local res = {}
	for j=1, number do
		local deb = pos[j][1]
		local fin = pos[j][2]
		for i = deb, fin do
		res[#res + 1] = seq[i].token
		end
		res[#res + 1] = '\n'
	end
	return table.concat(res, " ")
end






local main = dark.pipeline()
main:basic()
main:lexicon("#candidat", {"candidat","adhère", "Candidat","candidate","Secrétaire nationale"})
main:lexicon("#motPresident",{"président","présidente","Président","Présidente","préside"})
main:lexicon("#creation",{"forme","crée", "créée","fonde","fondé", "co-fondé"})
main:lexicon("#la",{"la","le","l"})
main:lexicon("#de",{"du","de","des","d"})
main:lexicon("#motSecretaire",{"Secrétaire nationale","Secrétaire Nationale", "secrétaire général"})
main:lexicon("#motMinistre",{"ministre","Ministre","premier ministre"})
main:lexicon("#motPresidentConseil", {"présidente du conseil régional","président du conseil général","président du conseil régional","présidente du conseil général"})
main:lexicon("#motDepute",{"député","députée","Député","Députée"})
main:lexicon("#motProgramme",{"programme","propositions","proposition","il veut","elle veut","souhaite"})
main:lexicon("#motMunicipale",{"adjointe au maire", "adjointe au Maire", "adjoint au maire", "adjoint au Maire","conseiller municipal","conseiller municipale","maire"})
main:lexicon("#apostrophe",{"'"})
main:lexicon("#naitre", {"née","né"})

main:model("mdl/postag-fr")

main:pattern([[
		[#name 
			(#W (#POS=DET | '-' | #de #apostrophe?)?) {2,}
		]
]])

main:pattern([[
		[#date
			[#jour #d ] 
			'/' 
			[#mois #d ]
			'/' 
			[#annee #d ]
		]
	]])

main:pattern([[
	[#phraseNaissance
		'est' #naitre 'le' #date
	]
]])

main:pattern([[
	[#ageFin
		#POS=NUM #POS=NNC >( #POS=ADP+ 'fin')
	]
]])

main:pattern([[
	[#ageDebut
		#POS=NUM #POS=NNC >( #POS=ADP+ 'début')
	]
]])



main:pattern([[
	[#partie
		   <( (#candidat|#motPresident) (#POS=ADP|#de)? (parti)? (#la? #apostrophe?)) (#W (#POS=DET | '-' | #de #apostrophe?|  #POS=ADJ |#d)?)+
		   | <((#POS=VRB #la #apostrophe 'investiture' (#de|pour #le))) (#w (#POS=DET  | #de #apostrophe? | #POS=ADJ |#d)?)
		   | <( #creation ((#la? #apostrophe?) (#POS=NNC #POS=ADJ)? |(#POS=CON #POS=VRB)? (#la? #apostrophe?) (parti)?) )  (#W (#POS=DET | '-' | #de #apostrophe?| #POS=ADJ |#d)?)+
	]	
]])
-- permet de savoir si il y a le poste d'un ministre
-- prend en compte les différent cas de figures apparus 

main:pattern([[
		[#estMinistre
			 #motMinistre #de #la? #apostrophe? (#w (#POS=CON #de #la? #apostrophe)?)+ >(#POS=ADP #POS=NNC | #POS=ADP #POS=NNP)
			 | #motMinistre #de #la? #apostrophe? (#w (#POS=CON #de #la? #apostrophe)?)+ >(#p)
			 | #motMinistre
		]
	]])

main:pattern([[
	[#info
		[#nomprenom #name]
		[#naissance #phraseNaissance ]
	]
]])

-- Permet de savoir si il y a le poste de député
main:pattern([[
	[#estDepute
		#motDepute (#w #de #apostrophe?|#de #apostrophe?) (#W (#POS=DET | '-' | #de #apostrophe? |#POS=ADJ)?)+
		| #motDepute #w 
	]
]])

-- permet de savoir si il y a le poste d'un président du conseil
main:pattern([[
	[#estPresidentConseil
	    #motPresidentConseil #de #apostrophe? (#W (#POS=DET | '-' | #de #apostrophe? |#POS=ADJ)?)+
	]
]])

-- permet de savoir si il y a le poste président d'un parti politique
main:pattern([[
	[#estPresidentParti
	    #motPresident (#POS=ADP|#de)? (parti)? (#la? #apostrophe?) (#W (#POS=DET | '-' | #de #apostrophe? |#POS=ADJ|#d)?)+
	]
]])
-- permet de savoir si secretaire nationale ou general
main:pattern([[
	[#estSecretaire
	    #motSecretaire (#POS=ADP|#de)? (parti)? (#la? #apostrophe?) (#W (#POS=DET | '-' | #de #apostrophe? |#POS=ADJ)?)+
	]
]])
-- permet de savoir si il y a un poste touchant la municipalite
main:pattern([[
	[#estMunicipale
	    #motMunicipale (#POS=ADP|#de)? (#la? #apostrophe?) (#W (#POS=DET | '-' | #de #apostrophe? |#POS=ADJ)?)+
	    | #motMunicipale
	]
]])

-- identifie son programme
main:pattern([[
	[#programme
		 #POS=VRB #d? #motProgramme .*
		 |#motProgramme .*

	]
]])
-- identifie sa carriere
main:pattern([[
	[#carriere
		(#estPresidentParti)? (#estPresidentConseil)?  (#estDepute)?  (#estMinistre)? (#estMunicipale)? (#estSecretaire)?
	]
]])


local db = {}

for fichier in os.dir("EISD") do
	local obj
	local out = io.open("test.txt", "w")
	local inp = io.open("EISD/"..fichier):read("*all")
	inp = inp:gsub("%b<>","")
	inp = inp:gsub("%b{}","")
	inp = inp:gsub("&nbsp","")
	
	--[[for line in io.lines("EISD/"..fichier) do
		--line =line:gsub("(%p)", " %1 ")	
		--line=line:gsub("<a.->(.-)</a>","%1")
		line=line:gsub("%b<>", "")
		line=line:gsub("%b{}","")
		line=line:gsub("&nbsp","")
		print(line)
		out:write(line)
		--seq:dump()
	    --print(seq:tostring(tags))
	end]]
	out:write(inp)
	out:close()
end

local out = io.open("db.txt", "w")
out:write("return ")
out:write(serialize(db))
out:close()

local db2 = dofile("db.txt")

print(serialize(db2))
