class_name BiomeList extends Resource
@export var biomes_list : Array[BiomeData] = []
func find_biome(biome_name : String):
	for biome in biomes_list:
		if(biome.name == biome_name):
			return biome
			
	return null	
