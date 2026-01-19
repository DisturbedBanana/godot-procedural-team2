class_name BiomeData extends Resource
enum BiomeType {Primary, Secondary}
@export var name : String
@export var type : BiomeType
@export var secondaryBiomes : Array[BiomeData] = []
