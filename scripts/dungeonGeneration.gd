class_name DungeonGenerator extends Node2D

var currentRoom: Room
@export var BiomsAndRooms = {"hub":["res://scenes/rooms/room_Enzo_1.tscn"],"Forest" : []}
@export var BiomNameListInOrder:Array[String]
var _loadedRooms = {}

var _mapMaxSize = 100.0
var _posedRoom:Array[Array]


var space = 32*16; # 16 is the number of tile SPACE IS ROOM SIZE DEPENDENT /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\

var ForestRooms:Array[Room]
var RuinRooms:Array[Room]
var SwampRooms:Array[Room]
var BayouRooms:Array[Room]
var CityRooms:Array[Room]
var LostWoodsRooms:Array[Room]
var D1Rooms:Array[Room]
var D2Rooms:Array[Room]
var D3Rooms:Array[Room]
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
			_posedRoom[i].append(9)

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
	(hub as Room).doors_states = [0, 2, 0, 0]
	(hub as Room).is_start_room = true
	_posedRoom[center][center] = 0
	var directions := [
		Vector2.UP,
		Vector2.DOWN,
		Vector2.LEFT,
		Vector2.RIGHT
	]
	
	var oldDir:Vector2 = Vector2.ZERO
	currentRoom=(hub as Room)
	
	var dir = directions.pick_random()
	for biome in BiomNameListInOrder:
		currentRoom=(hub as Room)
		walker_pos=Vector2(center, center)
		print(biome)
		if biome=="Forest":
			dir = Vector2.DOWN
		elif biome=="Swamp":
			dir = Vector2.RIGHT		
		elif biome=="Ruin":
			dir = Vector2.UP	
		else:
			continue
			#else rand sur biome precedent
			continue
		var steps := randi_range(5,10)
		for i in steps:
			print(dir)
			next_pos = walker_pos + dir

			if next_pos.x < 0 or next_pos.y < 0:
				continue
			if next_pos.x >= _mapMaxSize or next_pos.y >= 	_mapMaxSize:
				continue

			if _posedRoom[next_pos.x][next_pos.y] != 9:
				dir = directions.pick_random()
				continue

		#need to  select bioms with their names
		#Relaunch the func from the line 64 and gfy 
		# - and change the biome name to another thing and the zero to random
		
			var room = (_loadedRooms[biome][0]).instantiate()
			add_child(room)
			room.position = (Vector2i(next_pos.x,next_pos.y) - Vector2i(center, center)) * space
		#print("olddir", (new_po - oldDir).normalized)
			match -dir:
				Vector2.UP:
					(room as Room).doors_states[0] = 0
				Vector2.LEFT:
					(room as Room).doors_states[1] = 0
				Vector2.DOWN:
					(room as Room).doors_states[2] = 0
				Vector2.RIGHT:
					(room as Room).doors_states[3] = 0
			match dir:
				Vector2.UP:
					currentRoom.doors_states[0] = 0
				Vector2.LEFT:
					currentRoom.doors_states[1] = 0
				Vector2.DOWN:
					currentRoom.doors_states[2] = 0
				Vector2.RIGHT:
					currentRoom.doors_states[3] = 0
			print((room as Room).doors_states)
			_posedRoom[next_pos.x][next_pos.y] = 1
			dir = directions.pick_random()
			if biome=="Forest" :
				ForestRooms.append((room as Room))				
				currentRoom=ForestRooms[randi_range(0,ForestRooms.size()-1)]
				if dir==Vector2.UP:
					dir = Vector2.DOWN
			elif biome=="Swamp": 
				SwampRooms.append((room as Room))
				currentRoom=SwampRooms[randi_range(0,SwampRooms.size()-1)]
				if dir==Vector2.LEFT:
					dir = Vector2.RIGHT		
			elif biome=="Ruin":
				RuinRooms.append((room as Room))
				currentRoom=SwampRooms[randi_range(0,SwampRooms.size()-1)]
				if dir==Vector2.DOWN:
					dir = Vector2.UP	
			walker_pos=currentRoom.room_pos
	_printMap();


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit() 
