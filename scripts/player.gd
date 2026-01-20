class_name Player extends CharacterBase

static var Instance : Player

@export_group("Input")
@export_range (0.0, 1.0) var controller_dead_zone : float = 0.3

@export_group("Combat")
@export var bullet_scene : PackedScene
@export var bullet_speed : float = 600.0
@export var fire_rate : float = 0.2
@export var muzzle_offset : Vector2 = Vector2(20, 0)

#Interaction
var Interactable : InteractableBase = null

# Collectible
var key_count : int

# Internal variables
var _shoot_timer : float = 0.0

func _init() -> void:
	Instance = self

func _ready() -> void:
	_set_state(STATE.IDLE)

func _process(delta: float) -> void:
	super(delta)
	
	# 1. ROTATION LOGIC
	# Faces the mouse cursor
	look_at(get_global_mouse_position())
	
	# Update Timers
	if _shoot_timer > 0:
		_shoot_timer -= delta
		
	_update_inputs()
	_update_room()

func _update_inputs() -> void:
	if _can_move():
		_direction = Vector2(Input.get_axis("Left", "Right"), Input.get_axis("Up", "Down"))
		
		if _direction.length() < controller_dead_zone:
			_direction = Vector2.ZERO
		else:
			_direction = _direction.normalized()

		# 2. SHOOTING INPUT
		if Input.is_action_pressed("Attack") and _shoot_timer <= 0:
			shoot_at_mouse()
			
		# Optional: Keep your melee attack if you want both
		# if Input.is_action_pressed("Attack_Melee"): 
		#    _attack()
			
		if Input.is_action_just_pressed("Interact"):
			if Interactable == null:
				return
			
			Interactable.on_interact()
			
	else:
		_direction = Vector2.ZERO

func shoot_at_mouse() -> void:
	if bullet_scene == null:
		print("Error: Bullet Scene not assigned in Player Inspector")
		return

	_shoot_timer = fire_rate
	
	var new_bullet = bullet_scene.instantiate()
	
	# Calculate global spawn position based on player rotation
	var spawn_pos = global_position + muzzle_offset.rotated(rotation)
	
	new_bullet.global_position = spawn_pos
	new_bullet.rotation = rotation
	
	get_tree().current_scene.add_child(new_bullet)

# --- RESTORED FUNCTIONS BELOW ---

func enter_room(room : Room) -> void:
	var previous = _room
	_room = room
	_room.on_enter_room(previous)

func _update_room() -> void:
	# Ensure _room is valid before accessing it to prevent crashes
	if _room == null: return

	var room_bounds : Rect2 = _room.get_world_bounds()
	var next_room : Room = null
	
	if position.x > room_bounds.end.x:
		next_room = _room.get_adjacent_room(Utils.ORIENTATION.EAST, position)
	elif position.x < room_bounds.position.x:
		next_room = _room.get_adjacent_room(Utils.ORIENTATION.WEST, position)
	elif position.y < room_bounds.position.y:
		next_room = _room.get_adjacent_room(Utils.ORIENTATION.NORTH, position)
	elif position.y > room_bounds.end.y:
		next_room = _room.get_adjacent_room(Utils.ORIENTATION.SOUTH, position)

	if next_room != null:
		enter_room(next_room)

func _set_state(state : STATE) -> void:
	super(state)
	match _state:
		STATE.STUNNED:
			_current_movement = stunned_movemement
		STATE.DEAD:
			_end_blink()
			_set_color(dead_color)
		_:
			_current_movement = default_movement

	if !_can_move():
		_direction = Vector2.ZERO

func _update_state(_delta : float) -> void:
	match _state:
		STATE.ATTACKING:
			_spawn_attack_scene()
			_set_state(STATE.IDLE)
