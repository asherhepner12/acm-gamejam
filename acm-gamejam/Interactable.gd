class_name Interactable extends Area2D
signal dialogue_enabled #Does a thing
@export var interact_label = "label"
@export var interact_type = "default"
@export var interact_value = "default"

func _process(delta: float) -> void:
	if !visible:
		if interact_type == "movement":
			$CollisionPolygon2D.disabled = true
		else:
			$CollisionShape2D.disabled = true
	else:
		if interact_type == "movement":
			$CollisionPolygon2D.disabled = false
		else:
			$CollisionShape2D.disabled = false
	return
