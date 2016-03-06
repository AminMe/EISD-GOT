local db = {}
local jon = {}
jon["NIght"] = true
jon["miam"] = "poulet"


local arya = {}
arya["day"] = true
arya["miam"] = "boeuf"

if not db["Stark"] then
	db["Stark"] = {}
end

db["Stark"]["Seat"] = "Winterfell"
db["Stark"]["Military"] = 17
db["Stark"]["Miam"] = "le poulet"
if not db["Stark"]["Characters"] then
	db["Stark"]["Characters"] = {}
end

db["Stark"]["Characters"]["jon"] = jon
db["Stark"]["Characters"]["arya"] = arya

print(serialize(db))
