class_name Enemy extends CharacterBase
const Data = preload("res://scripts/quest/quest_data.gd")
const QuestManager = preload("res://scripts/quest/quest_system.gd")
@onready var anim = $AnimatedSprite2D

static var all_enemies : Array[Enemy]
var dic_biome : Dictionary = {
	"hub" : "Forest",
	"Forest" : "Forest",
	"LostWoods" : "ForgottenWood",
	"Desert1" : "Desert",
	"Desert2" : "Desert",
	"Desert3" : "Desert",
	"Steppe1" : "Steppe",
	"Steppe2" : "Steppe",
	"Steppe3" : "Steppe",
	"Ruin" : "Ruins",
	"LostCity" : "LostCity",
	"Swamp" : "Swamp",
	"Bayou" : "Bayou"
}

@export var entity_quest_type : Data.QuestEntity

@export var attack_warm_up : float = 0.5
@export var attack_distance : float = 0.5

var _state_timer : float = 0.0

var _current_biome : BiomeData


func _ready() -> void:
	anim.play("idle")
	all_enemies.push_back(self)
	for room in Room.all_rooms:
		if room.contains(global_position):
			_room = room
			
			_current_biome = QuestManager.Instance.biome_list.find_biome(get(_room.biome))
			break
	_set_state(STATE.IDLE)


func _process(delta: float) -> void:
	super(delta)
	update_AI()


func _exit_tree() -> void:
	all_enemies.erase(self)


func update_AI() -> void:
	if _can_move() && Player.Instance._room == _room:
		var enemy_to_player = Player.Instance.global_position - global_position
		if enemy_to_player.length() < attack_distance:
			_attack()
		else:
			anim.play("walk")
			_direction = enemy_to_player.normalized()
	else:
		anim.play("idle")
		_direction = Vector2.ZERO


func _set_state(state : STATE) -> void:
	super(state)
	_state_timer = 0.0

	match _state:
		STATE.STUNNED:
			anim.play("idle")
			_current_movement = stunned_movemement
		STATE.DEAD:
			anim.play("death")
			QuestManager.Instance._update_data(entity_quest_type)
			_end_blink()
			queue_free()
			_current_movement = default_movement

	if !_can_move():
		anim.play("idle")
		_direction = Vector2.ZERO


func _update_state(delta : float) -> void:
	_state_timer += delta
	match _state:
		STATE.ATTACKING:
			if _state_timer >= attack_warm_up:
				_spawn_attack_scene()
				_set_state(STATE.IDLE)
