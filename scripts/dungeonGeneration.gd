extends Node2D


@export var Rooms:Array[String]

var _loadedRooms:Array
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
				toPrint += "["+_posedRoom[i][j]+"]"
	
	print(toPrint)

func _loadAllRoom() -> void:
	for i in range(_mapMaxSize):
		_posedRoom.append([]) 
		for j in range(_mapMaxSize):
			_posedRoom[i].append(j)

	for i in Rooms.size():
		if(Rooms[i] == "/"):
			_BiomeSeparator.push_back(i)
			print(i)
		else:
			_loadedRooms.push_back(load(Rooms[i]))


func _generate() -> void:
	#HUB
	var hubCenter = _loadedRooms[0].instantiate()
	add_child(hubCenter)
	hubCenter.position = Vector2i(0,0)
	for i in range(-1,2):
		for j in range(-1,2):
			if ((i == 0 && abs(j) == 1) || j == 0 && abs(i) == 1) :
				var roomNode = _loadedRooms[0].instantiate()
				add_child(roomNode)
				roomNode.position = Vector2i(i*space,j*space)
	pass
	#Now Random Shit
	
	


func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit() 
