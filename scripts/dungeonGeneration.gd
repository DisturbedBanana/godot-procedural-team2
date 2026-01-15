extends Node2D

var Rooms:Array[Array]

var room = preload("res://scenes/rooms/room_1.tscn")

var space = 288.0; #SPACE IS ROOM SIZE DEPENDENT /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\
var spaceStart = -space/2.0

func _ready() -> void:
	_generate()
	
func _generate() -> void:
	#HUB
	
	var hubCenter = room.instantiate()
	add_child(hubCenter)
	hubCenter.position = Vector2i(spaceStart,-spaceStart)
	for i in range(-1,2):
		for j in range(-1,2):
			if ((i == 0 && abs(j) == 1) || j == 0 && abs(i) == 1) :
				var roomNode = room.instantiate()
				add_child(roomNode)
				roomNode.position = Vector2i(spaceStart+i*space,-spaceStart+j*space)

	#for i in range(size):
		#Rooms.append([]) 
		#for j in range(size):
			#Rooms[i].append(j)
			#var roomNode = room.instantiate()
			#add_child(roomNode)
			#roomNode.position = Vector2i(i*space,j*space)
			#roomNode.room_pos = Vector2i(i*space,j*space)
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit() # default behavior
