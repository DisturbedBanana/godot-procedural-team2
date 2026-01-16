class_name QuestData extends Resource

enum QuestType {Tracassin, Syndicat}
enum QuestObjective {Kill, Heal, Get}
enum QuestEntity {Sign, Chest, Lamp, Mouse, Slug, Fox, Mosquito, Gun, Rifle, Axe, Medkit, Keys, BlackHole} #temporary

var type : QuestType
var action : QuestObjective
var number : int
var entity : QuestEntity
var biome : BiomeData
var text : String

var dic_action : Dictionary = {
	"récupérer" : QuestObjective.Get,
	"tuer" : QuestObjective.Kill,
	"soigner" : QuestObjective.Heal
}

var dic_entity : Dictionary = {
	"panneaux" : QuestEntity.Sign,
	"coffres" : QuestEntity.Chest,
	"lampadaires" : QuestEntity.Lamp,
	"souris" : QuestEntity.Mouse,
	"limaces" : QuestEntity.Slug,
	"renards" : QuestEntity.Fox,
	"moustiques" : QuestEntity.Mosquito,
	"caisses de soin" : QuestEntity.Medkit,
	"clés" : QuestEntity.Keys,
	"trous noir" : QuestEntity.BlackHole,
	"pistolets" : QuestEntity.Gun,
	"fusils" : QuestEntity.Rifle,
	"haches" : QuestEntity.Axe
}


var dic_biome : Dictionary = {
	"la foret" : "Forest",
	"le bois oublié" : "ForgottenWood",
	"le désert" : "Desert",
	"la steppe interdite" : "Steppe",
	"les ruines" : "Ruins",
	"la cité perdue" : "LostCity",
	"le marécage" : "Swamp",
	"le bayou putride" : "Bayou"
}
