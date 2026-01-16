extends Attack

@export var speed : float = 600.0
@export var damage : int = 1

func _physics_process(delta: float) -> void:
	# Move forward in the direction the bullet is facing
	# In Godot 2D, "Right" (Vector2.RIGHT) is 0 degrees.
	# transform.x is the local "Right" vector based on rotation.
	position += transform.x * speed * delta

func _on_body_entered(body: Node2D) -> void:
	# 1. Ignore the Player (so you don't shoot yourself)
	if body is Player:
		return
	
	# 2. Check if we hit an enemy (assuming your enemies share a class or group)
	if body.has_method("apply_hit"):
		body.apply_hit(self)
		
	# 3. Destroy the bullet on impact
	queue_free()

func _on_screen_exited() -> void:
	# Delete bullet when it leaves the screen
	queue_free()
