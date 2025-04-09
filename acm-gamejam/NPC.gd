class_name Interactable extends Area2D

@export var interact_label = "dialogue_1"
@export var interact_type = "npc"
@export var interact_value = "default"

func _process(delta: float) -> void:
	if !visible:
		interact_type = "none"
		interact_value = "none"
		$CollisionShape2D.disabled = true
	else:
		$CollisionShape2D.disabled = false
		interact_type = "npc"
		interact_value = "NPC: Hello!"
		
	return
