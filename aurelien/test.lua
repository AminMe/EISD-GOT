local texte = "3 dragons , under 100 Dothraki cavalry , 8 , 000 Unsullied ( heavy infantry ) , 2 , 000 Second Sons ( armored mercenary cavalry )"

local value = {}

--texte:gsub('(%d+ , %d+)', '(%d+%d+)')

local i = 1
for word in string.gmatch(texte, '(%d+ , %d+)') do
    print(word)
	word = word:gsub(" , ", "")
	value[i] =  word
	i = i + 1
end

print(value[1])
print(value[2])
