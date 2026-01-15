class_name InteractableBase extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func on_interact():
	pass
	
func _set_interactable():
	pass
	
func _remove_interactable():
	Player.Instance.Interactable = null
	
func _on_body_entered(body: Node2D) -> void:
	if body is not Player:
		return
	
	_set_interactable()

func _on_body_exited(body:Node2D)->void:
	if body is not Player:
		return
	
	_remove_interactable()
