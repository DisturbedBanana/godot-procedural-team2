extends Node2D


@export var Rooms:Array[String]

var _loadedRooms:Array[PackedScene]
var _BiomeSeparator:Array[int]

var _mapMaxSize = 10
var _posedRoom:Array[Array]
	

var space = 32*16; # 16 is the number of tile SPACE IS ROOM SIZE DEPENDENT /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\

func _ready() -> void:
	_loadAllRoom()
	_generate()

func _printMap() -> void:
	var toPrint = ""
	var size = _posedRoom.size()
	for i in range(_mapMaxSize):
		for j in range(_mapMaxSize):
			if(i < size && j < size):
				toPrint += "["+str(_posedRoom[i][j])+"]"
		toPrint += "\n"
	
	print(toPrint)

func _loadAllRoom() -> void:
	for i in range(_mapMaxSize):
		_posedRoom.append([]) 
		for j in range(_mapMaxSize):
			_posedRoom[i].append(-1)

	for i in Rooms.size():
		_loadedRooms.push_back(load(Rooms[i]))


func _generate() -> void:
	var center = _mapMaxSize / 2
	var walker_pos := Vector2i(center, center)
	var next_pos := Vector2i(0,0)
	#HUB
	var hub = _loadedRooms[0].instantiate()
	add_child(hub)
	hub.position = Vector2i.ZERO
	(hub as Room).room_pos = walker_pos
	(hub as Room).doors_states = [0, 0, 0, 0]

	_posedRoom[center][center] = 0

	var steps := 25
	var directions := [
		Vector2i.UP,
		Vector2i.DOWN,
		Vector2i.LEFT,
		Vector2i.RIGHT
	]

	for i in steps:
		var dir = directions.pick_random()
		next_pos = walker_pos + dir

		if next_pos.x < 0 or next_pos.y < 0:
			continue
		if next_pos.x >= _mapMaxSize or next_pos.y >= 	_mapMaxSize:
			continue

		if _posedRoom[next_pos.x][next_pos.y] != -1:
			walker_pos = next_pos
			continue

		#need to  select bioms
		var room:Room = _loadedRooms[randi_range(0,_loadedRooms.size()-1)].instantiate() as Room
		add_child(room)

		room.position = (next_pos - Vector2i(center, center)) * space
		#(room as Room).room_pos = next_pos
		#Need to do doors
		#Midi Ouest Down Tridbord	
		room.doors_states = [2, 2, 2, 2]
		match dir:
			Vector2i.UP:
				room.doors_states[0] = 0
			Vector2i.LEFT:
				room.doors_states[1] = 0
			Vector2i.DOWN:
				room.doors_states[2] = 0
			Vector2i.RIGHT:
				room.doors_states[3] = 0
		

		_posedRoom[next_pos.x][next_pos.y] = 1
		walker_pos = next_pos
	_printMap();
	#for i in range(-1,2):
		#for j in range(-1,2):
			#if ((i == 0 && abs(j) == 1) || j == 0 && abs(i) == 1) :
				#var roomNode = _loadedRooms[0].instantiate()
				#(roomNode as Room).doors_states = [0,0,0,0]
				#add_child(roomNode)
				#roomNode.position = Vector2i(i*space,j*space)
				
	
	#doors_state 0/2 - N O S E 
	


func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit() 
