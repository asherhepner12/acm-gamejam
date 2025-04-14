extends Interactable
const Balloon = preload("res://Dialogue/balloon.tscn")
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"


var is_equippable = false
var available = true
func _init():
	interact_type = "object"
	interact_value = "This is an object"
	interact_label = "object"

func action() -> void:
	SignalBus.emit_signal("dialogue_enabled","none")
	var balloon: Node = Balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resource, dialogue_start)
