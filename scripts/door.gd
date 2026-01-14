class_name Door extends Node2D

enum STATE {OPEN = 0, CLOSED = 1, WALL = 2, SECRET = 3}
enum DIR {S=0,N=1,W=2,E=3}
@export var dir:DIR
@export var closedNode : Node2D
@export var openNode : Node2D
@export var wallSNode : Node2D
@export var wallWNode : Node2D
@export var wallENode : Node2D
@export var wallNNode : Node2D
@export var secretNode : Node2D

var orientation : Utils.ORIENTATION
var state : STATE

var _room : Room

@onready var collision = $"CollisionShape2D"


func _ready() -> void:
	var node = self
	while (node != null && !node is Room):
		node = node.get_parent()

	if node == null:
		push_error(node == null, "The door is not in any room")
		return

	_room = node
	_room.doors.push_back(self)

	var room_bounds : Rect2 = _room.get_local_bounds()
	var ratio : float = room_bounds.size.x / room_bounds.size.y
	var dir : Vector2 = position - room_bounds.get_center()

	if abs(dir.x) > abs(dir.y) * ratio:
		orientation = Utils.ORIENTATION.EAST if dir.x > 0 else Utils.ORIENTATION.WEST
	else:
		orientation = Utils.ORIENTATION.NORTH if dir.y < 0 else Utils.ORIENTATION.SOUTH

	rotation_degrees = Utils.OrientationToAngle(orientation)
	if closedNode.visible:
		set_state(STATE.CLOSED)
	elif openNode.visible:
		set_state(STATE.OPEN)
	elif wallSNode.visible:
		set_state(STATE.WALL)
	elif wallWNode.visible:
		set_state(STATE.WALL)
	elif wallENode.visible:
		set_state(STATE.WALL)
	elif wallNNode.visible:
		set_state(STATE.WALL)		
	elif secretNode.visible:
		set_state(STATE.SECRET)


func try_unlock() -> void:
	if state != STATE.CLOSED || Player.Instance.key_count <= 0:
		return

	Player.Instance.key_count -= 1
	set_state(STATE.OPEN)

	var next_room = _room.get_adjacent_room(orientation, position)
	if next_room:
		var next_door = next_room.get_door(Utils.OppositeOrientation(orientation), position)
		if next_door != null:
			next_door.set_state(STATE.OPEN)


func set_state(new_state : STATE) -> void:
	closedNode.visible = false
	openNode.visible = false
	wallSNode.visible = false
	wallENode.visible = false
	wallWNode.visible = false
	wallNNode.visible = false
	secretNode.visible = false

	state = new_state
	match state:
		STATE.CLOSED:
			closedNode.visible = true
			collision.set_deferred("disabled", false)
		STATE.OPEN:
			openNode.visible = true
			collision.set_deferred("disabled", true)
		STATE.WALL:
			match dir:
				DIR.N:
					wallNNode.visible = true
					collision.set_deferred("disabled", false)
				DIR.W:
					wallWNode.visible = true
					collision.set_deferred("disabled", false)
				DIR.S:
					wallSNode.visible = true
					collision.set_deferred("disabled", false)
				DIR.E:
					wallENode.visible = true
					collision.set_deferred("disabled", false)
		STATE.SECRET:
			secretNode.visible = true
			collision.set_deferred("disabled", true)
