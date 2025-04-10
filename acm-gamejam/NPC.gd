extends Interactable

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

func action() -> void:
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)

func _init():
	interact_type = "npc"
	interact_value = "NPC: Hello!"
	interact_label = "npc"
