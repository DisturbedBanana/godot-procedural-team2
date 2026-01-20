class_name DungeonGenerator extends Node2D

var currentRoom: Room
@export var BiomsAndRooms:Dictionary = {}
@export var BiomNameListInOrder:Array[String]
var _loadedRooms = {}

var _mapMaxSize = 100.0
var _posedRoom:Array[Array]


var space = 16*16; # 16 is the number of tile SPACE IS ROOM SIZE DEPENDENT /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\ /!\

var ForestRooms:Array[Room]
var RuinRooms:Array[Room]
var SwampRooms:Array[Room]
var BayouRooms:Array[Room]
var CityRooms:Array[Room]
var LostWoodsRooms:Array[Room]
var D1Rooms:Array[Room]
var D2Rooms:Array[Room]
var D3Rooms:Array[Room]
var S1Rooms:Array[Room]
var S2Rooms:Array[Room]
var S3Rooms:Array[Room]
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
	hub.biome="hub"
	(hub as Room).room_pos = walker_pos
	(hub as Room).doors_states = [0, 2, 0, 0]
	(hub as Room).is_start_room = true
	(hub as Room).onReady()
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
		match biome:
			"Forest":
				currentRoom=(hub as Room)
				dir = Vector2.DOWN
			"Swamp":
				currentRoom=(hub as Room)
				dir = Vector2.RIGHT		
			"Ruin":
				currentRoom=(hub as Room)
				dir = Vector2.UP
			"LostWoods":
				currentRoom = ForestRooms[randi_range(0,ForestRooms.size()-1)]
				dir = Vector2.DOWN
			"Bayou":
				currentRoom = SwampRooms[randi_range(0,SwampRooms.size()-1)]
				dir = Vector2.RIGHT
			"LostCity":
				currentRoom = RuinRooms[randi_range(0,RuinRooms.size()-1)]
				dir = Vector2.UP
			"Desert1":
				currentRoom = LostWoodsRooms[randi_range(0,LostWoodsRooms.size()-1)]
				dir = Vector2.DOWN
			"Desert2":
				currentRoom = BayouRooms[randi_range(0,BayouRooms.size()-1)]
				dir = Vector2.LEFT
			"Desert3":
				currentRoom = CityRooms[randi_range(0,CityRooms.size()-1)]
				dir = Vector2.UP
			"Steppe1":
				currentRoom = D1Rooms[randi_range(0,D1Rooms.size()-1)]
				dir = Vector2.DOWN
			"Steppe2":
				currentRoom = D2Rooms[randi_range(0,D2Rooms.size()-1)]
				dir = Vector2.LEFT
			"Steppe3":
				currentRoom = D3Rooms[randi_range(0,D3Rooms.size()-1)]
				dir = Vector2.UP
		walker_pos=currentRoom.room_pos
		var steps := randi_range(5,10)
		for i in steps:
			
			next_pos = walker_pos + dir
			if next_pos.x < 0 or next_pos.y < 0:
				continue
			if next_pos.x >= _mapMaxSize or next_pos.y >= 	_mapMaxSize:
				continue
			var j=0
			while _posedRoom[next_pos.x][next_pos.y] != 9:
				j+=1
				dir = directions.pick_random()
				match biome:
					"Forest":
						currentRoom=ForestRooms[randi_range(0,ForestRooms.size()-1)]
						if dir==Vector2.UP:
							dir = Vector2.DOWN
					"Swamp":
						currentRoom=SwampRooms[randi_range(0,SwampRooms.size()-1)]
						if dir==Vector2.LEFT:
							dir = Vector2.RIGHT		
					"Ruin":
						currentRoom=RuinRooms[randi_range(0,RuinRooms.size()-1)]
						if dir==Vector2.DOWN:
							dir = Vector2.UP	
					"LostWoods":
						if LostWoodsRooms.size()==0:
							currentRoom=ForestRooms[randi_range(2,ForestRooms.size()-1)]
						else:
							currentRoom=LostWoodsRooms[randi_range(0,LostWoodsRooms.size()-1)]
						if dir==Vector2.UP:
							dir = Vector2.DOWN		
					"Bayou":
						if BayouRooms.size()==0:
							currentRoom=SwampRooms[randi_range(2,SwampRooms.size()-1)]
						else:
							currentRoom=BayouRooms[randi_range(0,BayouRooms.size()-1)]
						if dir==Vector2.LEFT:
							dir = Vector2.RIGHT		
					"LostCity":
						if CityRooms.size()==0:
							currentRoom=RuinRooms[randi_range(2,RuinRooms.size()-1)]
						else:
							currentRoom=CityRooms[randi_range(0,CityRooms.size()-1)]
						if dir==Vector2.DOWN:
							dir = Vector2.UP		
					"Desert1":
						if D1Rooms.size()==0:
							currentRoom=LostWoodsRooms[randi_range(2,LostWoodsRooms.size()-1)]
						else:
							currentRoom=D1Rooms[randi_range(0,D1Rooms.size()-1)]
						if dir==Vector2.UP:
							dir = Vector2.DOWN	
					"Desert2":
						if D2Rooms.size()==0:
							currentRoom=BayouRooms[randi_range(2,BayouRooms.size()-1)]
						else:
							currentRoom=D2Rooms[randi_range(0,D2Rooms.size()-1)]
						if dir==Vector2.RIGHT:
							dir = Vector2.LEFT	
					"Desert3":
						if D3Rooms.size()==0:
							currentRoom=CityRooms[randi_range(2,CityRooms.size()-1)]
						else:
							currentRoom=D3Rooms[randi_range(0,D3Rooms.size()-1)]
						if dir==Vector2.DOWN:
							dir = Vector2.UP
					"Steppe1":
						if S1Rooms.size()==0:
							currentRoom=D1Rooms[randi_range(2,D1Rooms.size()-1)]
						else:
							currentRoom=S1Rooms[randi_range(0,S1Rooms.size()-1)]
						if dir==Vector2.UP:
							dir = Vector2.DOWN
					"Steppe2":
						if S2Rooms.size()==0:
							currentRoom=D2Rooms[randi_range(2,D2Rooms.size()-1)]
						else:
							currentRoom=S2Rooms[randi_range(0,S2Rooms.size()-1)]
						if dir==Vector2.LEFT:
							dir = Vector2.RIGHT
					"Steppe3":
						if S3Rooms.size()==0:
							currentRoom=D3Rooms[randi_range(2,D3Rooms.size()-1)]
						else:
							currentRoom=S3Rooms[randi_range(0,S3Rooms.size()-1)]
						if dir==Vector2.DOWN:
							dir = Vector2.UP
				walker_pos=currentRoom.room_pos
				next_pos = walker_pos + dir
				if j>10:
					break
			var room = (_loadedRooms[biome][0]).instantiate()
			room.position = (Vector2i(next_pos.x,next_pos.y) - Vector2i(center, center)) * space
			(room as Room).room_pos=next_pos
			(room as Room).biome=biome
			(room as Room).onReady()
			print(next_pos)
			add_child(room)
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
			_posedRoom[next_pos.x][next_pos.y] = 1
			dir = directions.pick_random()
			match biome:
				"Forest":
					ForestRooms.append((room as Room))				
					currentRoom=ForestRooms[randi_range(0,ForestRooms.size()-1)]
					if dir==Vector2.UP:
						dir = Vector2.DOWN
				"Swamp":
					SwampRooms.append((room as Room))
					currentRoom=SwampRooms[randi_range(0,SwampRooms.size()-1)]
					if dir==Vector2.LEFT:
						dir = Vector2.RIGHT		
				"Ruin":
					RuinRooms.append((room as Room))
					currentRoom=RuinRooms[randi_range(0,RuinRooms.size()-1)]
					if dir==Vector2.DOWN:
						dir = Vector2.UP	
				"LostWoods":
					LostWoodsRooms.append((room as Room))
					currentRoom=LostWoodsRooms[randi_range(0,LostWoodsRooms.size()-1)]
					if dir==Vector2.UP:
						dir = Vector2.DOWN		
				"Bayou":
					BayouRooms.append((room as Room))
					currentRoom=BayouRooms[randi_range(0,BayouRooms.size()-1)]
					if dir==Vector2.LEFT:
						dir = Vector2.RIGHT		
				"LostCity":
					CityRooms.append((room as Room))
					currentRoom=CityRooms[randi_range(0,CityRooms.size()-1)]
					if dir==Vector2.UP:
						dir = Vector2.DOWN		
				"Desert1":
					D1Rooms.append((room as Room))
					currentRoom=D1Rooms[randi_range(0,D1Rooms.size()-1)]
					if dir==Vector2.DOWN:
						dir = Vector2.UP		
				"Desert2":
					D2Rooms.append((room as Room))
					currentRoom=D2Rooms[randi_range(0,D2Rooms.size()-1)]
					if dir==Vector2.LEFT:
						dir = Vector2.RIGHT		
				"Desert3":
					D3Rooms.append((room as Room))
					currentRoom=D3Rooms[randi_range(0,D3Rooms.size()-1)]
					if dir==Vector2.DOWN:
						dir = Vector2.UP		
				"Steppe1":
					S1Rooms.append((room as Room))
					currentRoom=S1Rooms[randi_range(0,S1Rooms.size()-1)]
					if dir==Vector2.UP:
						dir = Vector2.DOWN		
				"Steppe2":
					S2Rooms.append((room as Room))
					currentRoom=S2Rooms[randi_range(0,S2Rooms.size()-1)]
					if dir==Vector2.LEFT:
						dir = Vector2.RIGHT		
				"Steppe3":
					S3Rooms.append((room as Room))
					currentRoom=S3Rooms[randi_range(0,S3Rooms.size()-1)]
					if dir==Vector2.DOWN:
						dir = Vector2.UP			
			walker_pos=currentRoom.room_pos


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit() 
