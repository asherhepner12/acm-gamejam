extends Node2D

@onready var all_interactions = []
@onready var label = $Label
@onready var cursor = get_node
var mouse_coordinates

func _ready():
	update_interactions()
	
func _process(delta: float) -> void:
	mouse_coordinates = get_viewport().get_mouse_position()
	position = mouse_coordinates
	if Input.is_action_just_pressed("left_click"):
		execute_interaction()

func _on_interaction_area_area_entered(area: Area2D) -> void:
	all_interactions.insert(0, area)
	update_interactions()

func _on_interaction_area_area_exited(area: Area2D) -> void:
	all_interactions.erase(area)
	update_interactions()

func update_interactions():
	if all_interactions:
		label.text = all_interactions[0].interact_label
	else:
		label.text = " "
		
func execute_interaction():
	if all_interactions:
		var current_interaction = all_interactions[0]
		match current_interaction.interact_type:
			"npc": print(current_interaction.interact_value)
		
