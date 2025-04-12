extends Interactable
const Balloon = preload("res://Dialogue/balloon.tscn")
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

var available = true
func action() -> void:
	var balloon: Node = Balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resource, dialogue_start)

func _init():
	interact_type = "npc"
	interact_value = "NPC: Hello!"
	interact_label = "npc"
