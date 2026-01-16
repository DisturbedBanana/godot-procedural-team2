extends Area2D

func _init() -> void:
	connect("body_entered", _on_body_entered)


func _on_body_entered(body:Node2D) -> void:
	if Player.Instance == null:
		return
	
	if body != Player.Instance:
		return

	Player.Instance.apply_hit(null)
