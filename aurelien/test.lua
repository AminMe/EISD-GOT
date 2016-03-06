--[[ Fonction qui ajoute des infos non structurée dans le tableau ]]--
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
		result[key] = value
	end

	return result, somme
end

local texte = "3 dragons , under 100 Dothraki cavalry , 8 , 000 Unsullied ( heavy infantry ) , 2 , 000 Second Sons ( armored mercenary cavalry )"
local result, somme
texte = cleannumber(texte)
result, somme = splitvirgule(texte)
print(serialize(result))
print(somme)
