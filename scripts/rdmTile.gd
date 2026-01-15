class_name randomTile extends Node2D
@export var nodeParent : Node 
@export var possible_script:Array[Script]
var possible_tile:Array[Sprite2D]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	findByClass(nodeParent,"Sprite2D",possible_tile)
	var tile=randi_range(0,possible_tile.size()-1)
	var i=0;
	for tiles in possible_tile:
		if tile==i:
			print(i)
			tiles.visible=true
			if possible_script[i]!=null:
				nodeParent.set_script(possible_script[i])
		else:
			tiles.visible=false
		i+=1
	pass # Replace with function body.




func findByClass(node: Node, className : String, result : Array) -> void:
	if node.is_class(className) :
		result.push_back(node)
	for child in node.get_children():
		findByClass(child, className, result)
