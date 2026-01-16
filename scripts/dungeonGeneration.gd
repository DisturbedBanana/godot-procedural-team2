extends Node2D


@export var BiomsAndRooms = {"hub":["res://scenes/rooms/room_Enzo_1.tscn"],"Forest" : []}

var _loadedRooms = {}

var _mapMaxSize = 10.0
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

	for bioms in BiomsAndRooms:
		_loadedRooms.get_or_add(bioms)
		_loadedRooms[bioms] = []
		for j in BiomsAndRooms[bioms]:	
			_loadedRooms[bioms].push_back(load(j))


func _generate() -> void:
	var center = _mapMaxSize / 2
	var walker_pos := Vector2(center, center)
	var next_pos := Vector2(0,0)
	#HUB
	var hub = _loadedRooms["hub"][0].instantiate()
	add_child(hub)
	hub.position = Vector2i.ZERO
	(hub as Room).room_pos = walker_pos
	(hub as Room).doors_states = [0, 0, 0, 0]
	(hub as Room).is_start_room = true
	_posedRoom[center][center] = 0

	var steps := 10
	var directions := [
		Vector2.UP,
		Vector2.DOWN,
		Vector2.LEFT,
		Vector2.RIGHT
	]
	
	var oldDir:Vector2 = Vector2.ZERO
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

		#need to  select bioms with their names
		#Relaunch the func from the line 64 and gfy 
		# - and change the biome name to another thing and the zero to random
		
		var room = (_loadedRooms["Forest"][0]).instantiate()
		add_child(room)
		room.position = (Vector2i(next_pos.x,next_pos.y) - Vector2i(center, center)) * space

		match -oldDir:
			Vector2i.UP:
				(room as Room).doors_states[0] = 0
			Vector2i.LEFT:
				(room as Room).doors_states[1] = 0
			Vector2i.DOWN:
				(room as Room).doors_states[2] = 0
			Vector2i.RIGHT:
				(room as Room).doors_states[3] = 0
		match dir:
			Vector2i.UP:
				(room as Room).doors_states[0] = 0
			Vector2i.LEFT:
				(room as Room).doors_states[1] = 0
			Vector2i.DOWN:
				(room as Room).doors_states[2] = 0
			Vector2i.RIGHT:
				(room as Room).doors_states[3] = 0
		
		oldDir = dir;

		_posedRoom[next_pos.x][next_pos.y] = 1
		walker_pos = next_pos
	_printMap();


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit() 
