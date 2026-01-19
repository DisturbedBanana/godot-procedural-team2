class_name InteractExample extends InteractableBase

func _set_interactable():
	print_debug("set player interactable object : " + self.name)
	Player.Instance.Interactable = self

func on_interact():
	print_debug("Interacted : " + self.name)
