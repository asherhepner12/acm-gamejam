extends Node2D

@onready var all_interactions = []
var location_class = load("res://Location.gd")
var location_node_class = load("res://LocationNode.gd")
var location = location_class.new()
var location_node = location_node_class.new()
var location_list = [null,null,null,null,null,null,null,null,null,null]
var location_list_index = 0
func _ready():
	update_interactions()
	location_setup()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$"../MovementDetection/BackDetection".visible = false
	$"../MovementDetection/LeftDetection".visible = false
	$"../MovementDetection/RightDetection".visible = false
	$"InteractionArea/CollisionShape2D/Inspect".visible = false
	
func _process(delta: float) -> void:
	position = get_viewport().get_mouse_position()
	
	if Input.is_action_just_pressed("left_click"):
		execute_interaction()
	#Handle movement	
	if Input.is_action_just_pressed("right"):
		update_location("right")
	if Input.is_action_just_pressed("left"):
		update_location("left")
	if Input.is_action_just_pressed("forward"):
		update_location("forward")
	if Input.is_action_just_pressed("back"):
		update_location("back")

func _on_interaction_area_area_entered(area: Area2D) -> void:
	all_interactions.insert(0, area)
	update_interactions()

func _on_interaction_area_area_exited(area: Area2D) -> void:
	all_interactions.erase(area)
	update_interactions()

func update_interactions():
	if all_interactions:
		$"InteractionArea/CollisionShape2D/Idle".visible = false
		match all_interactions[0].interact_label:
			"forward":
				$"InteractionArea/CollisionShape2D/Up".visible = true
			"back":
				$"InteractionArea/CollisionShape2D/Down".visible = true
			"left":
				$"InteractionArea/CollisionShape2D/Left".visible = true
			"right":
				$"InteractionArea/CollisionShape2D/Right".visible = true
			"npc":
				$"InteractionArea/CollisionShape2D/Inspect".visible = true
	else:
		$"InteractionArea/CollisionShape2D/Idle".visible = true
		$"InteractionArea/CollisionShape2D/Up".visible = false
		$"InteractionArea/CollisionShape2D/Down".visible = false
		$"InteractionArea/CollisionShape2D/Left".visible = false
		$"InteractionArea/CollisionShape2D/Right".visible = false
		$"InteractionArea/CollisionShape2D/Inspect".visible = false
		
func execute_interaction():
	if all_interactions:
		var current_interaction = all_interactions[0]
		match current_interaction.interact_type:
			"none": return
			"npc": print(current_interaction.interact_value)
			"movement": match current_interaction.interact_value:
				"forward": update_location("forward")
				"back": update_location("back")
				"left": update_location("left")
				"right": update_location("right")

			
func update_location(direction):
	match direction:
		"forward":
			if (location_node.forward != null):
				hide_values(location_node)
				location_node = location_node.forward
				print("Went forward!")
			else:
				print("Cannot go forward!")
		"back":
			if(location_node.back != null):
				hide_values(location_node)
				location_node = location_node.back
				print("Went back!")
			else:
				print("Cannot go back!")
		"left":
			if(location_node.left != null):
				hide_values(location_node)
				location_node = location_node.left
				print("Went left!")
			else:
				print("Cannot go left!")
		"right":	
			if(location_node.right != null):
				hide_values(location_node)
				location_node = location_node.right
				print("Went right!")
			else:
				print("Cannot go right!")
	location_node.backdrop.visible = true
	for i in range (0,10):
		if location_node.npcs[i] != null:
			location_node.npcs[i].visible = true
	if location_node.forward != null and location_node.forward.accessible == true:
		$"../MovementDetection/ForwardDetection".visible = true
	if location_node.back != null and location_node.back.accessible == true:
		$"../MovementDetection/BackDetection".visible = true
	if location_node.left != null and location_node.left.accessible == true:
		$"../MovementDetection/LeftDetection".visible = true
	if location_node.right != null and location_node.right.accessible == true:
		$"../MovementDetection/RightDetection".visible = true
	if location_node.transition != -1:
		hide_values(location_node)
		location_node = location_list[location_node.transition].head
		update_location(location_node)
			
func hide_values(location_node):
	location_node.backdrop.visible = false
	for i in range (0,10):
		if location_node.npcs[i] != null:
			location_node.npcs[i].visible = false
	$"../MovementDetection/ForwardDetection".visible = false
	$"../MovementDetection/BackDetection".visible = false
	$"../MovementDetection/LeftDetection".visible = false
	$"../MovementDetection/RightDetection".visible = false

func location_setup():
	#Create map of Outside
	location_node.backdrop = $"../Locations/Outside/Backdrops/CityHall"
	location_node.right = location_node_class.new()
	location_node.right.backdrop = $"../Locations/Outside/Backdrops/Wilshire"
	location_node.right.left = location_node
	location.head = location_node
	location.title = "Outside"
	location_list[1] = location
	#Create map of office
	location_node = location_node_class.new()
	location_node.backdrop = $"../Locations/Office/Backdrops/IntroRoom"
	location_node.npcs[0] = $"../Locations/Office/NPCS/Woman1NPC"
	location_node.back = location_node_class.new()
	location_node.back.backdrop = $"../Locations/Office/Backdrops/IntroRoomBack"
	location_node.back.forward = location_node
	location_node.back.back = location_node_class.new()
	location_node.back.back.backdrop = $"../Locations/Office/Backdrops/Entryway"
	location_node.back.back.left = location_node_class.new()
	location_node.back.back.left.backdrop = $"../Locations/Office/Backdrops/HallwayTurned"
	location_node.back.back.left.accessible = true
	location_node.back.back.left.forward = location_node_class.new()
	location_node.back.back.left.forward.backdrop = $"../Locations/Office/Backdrops/Transition"
	print(location_node.back.back.left.forward.backdrop)
	location_node.back.back.left.forward.transition = 1
	location_node.back.back.left.right = location_node.back.back
	location_node.back.back.forward = location_node.back
	location_node.back.back.back = location_node_class.new()
	location_node.back.back.back.backdrop = $"../Locations/Office/Backdrops/Hallway"
	location_node.back.back.back.forward = location_node.back.back
	location_node = location_node.back.back.back
	location = location_class.new()
	location.head = location_node
	location.title = "Office"
	location_list[0] = location
