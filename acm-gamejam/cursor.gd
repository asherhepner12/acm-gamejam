extends Node2D
const Balloon = preload("res://Dialogue/balloon.tscn")
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
@onready var all_interactions = []
var inventory = []
var location_class = load("res://Location.gd")
var location_node_class = load("res://LocationNode.gd")
var location = location_class.new()
var location_node = location_node_class.new()
var location_list = [null,null,null,null,null,null,null,null,null,null]
var location_list_index = 0
func _ready():
	#SignalBus Connections
	SignalBus.connect("dialogue_enabled", _on_dialogue_enabled)
	SignalBus.connect("dialogue_disabled", _on_dialogue_disabled)
	SignalBus.connect("show_object", _on_show_object)
	SignalBus.connect("hide_object", _on_hide_object)
	SignalBus.connect("show_npc", _on_show_npc)
	SignalBus.connect("hide_npc", _on_hide_npc)
	
	#Intro monologue
	DialogueManager.show_dialogue_balloon(dialogue_resource,dialogue_start)
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
			"object":
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
			"npc": 
				current_interaction.action()
				print(current_interaction.interact_value)
			"movement": match current_interaction.interact_value:
				"forward": update_location("forward")
				"back": update_location("back")
				"left": update_location("left")
				"right": update_location("right")
			"object":
				current_interaction.action()
				if current_interaction.is_equippable == true:
					inventory.add(current_interaction)
					
func _on_dialogue_enabled(exception):
	print("Dialogue Started")
	$"../MovementDetection/ForwardDetection".visible = false
	$"../MovementDetection/BackDetection".visible = false
	$"../MovementDetection/LeftDetection".visible = false
	$"../MovementDetection/RightDetection".visible = false
	hide_values(location_node, false, exception)

func _on_dialogue_disabled():
	print("Dialogue Ended")
	enable_values()
	
func _on_show_object(object_name):
	for i in range (0,10):
		if location_node.objects[i] != null:
			if location_node.objects[i].interact_value == object_name:
				location_node.objects[i].available = true
				location_node.objects[i].visible = true
		
func _on_hide_object(object_name):
	for i in range (0,10):
		if location_node.objects[i] != null:
			if location_node.objects[i].interact_value == object_name:
				location_node.objects[i].available = false
				location_node.objects[i].visible = false

func _on_show_npc(npc_name):
	for i in range (0,10):
		if location_node.npcs[i] != null:
			if location_node.npcs[i].interact_value == npc_name:
				location_node.npcs[i].available = true
				location_node.npcs[i].visible = true
				
func _on_hide_npc(npc_name):
	for i in range (0,10):
		if location_node.npcs[i] != null:
			if location_node.npcs[i].interact_value == npc_name:
				location_node.npcs[i].available = false
				location_node.npcs[i].visible = false
			
func update_location(direction):
	#Process depending on direction chosen
	match direction:
		"forward":
			if (location_node.forward != null):
				hide_values(location_node, true, "none")
				location_node = location_node.forward
				print("Went forward!")
			else:
				print("Cannot go forward!")
		"back":
			if(location_node.back != null):
				hide_values(location_node, true, "none")
				location_node = location_node.back
				print("Went back!")
			else:
				print("Cannot go back!")
		"left":
			if(location_node.left != null):
				hide_values(location_node, true, "none")
				location_node = location_node.left
				print("Went left!")
			else:
				print("Cannot go left!")
		"right":	
			if(location_node.right != null):
				hide_values(location_node, true, "none")
				location_node = location_node.right
				print("Went right!")
			else:
				print("Cannot go right!")
	enable_values()
	#If the location you are moving to is a transition point
	if location_node.transition != -1: 
		print("Went to " + location_list[location_node.transition].title+"!")
		hide_values(location_node, true, "none")
		location_node = location_list[location_node.transition].head
		update_location(location_node)
		
func enable_values():
	location_node.backdrop.visible = true
	#Enable NPCs/Objects in the location
	for i in range (0,10):
		if location_node.npcs[i] != null and location_node.npcs[i].available == true:
			location_node.npcs[i].visible = true
		if location_node.objects[i] != null and location_node.objects[i].available == true:
			location_node.objects[i].visible = true
	#Enable movement detection in the location
	if location_node.forward != null and location_node.forward.accessible == true:
		$"../MovementDetection/ForwardDetection".visible = true
	if location_node.back != null and location_node.back.accessible == true:
		$"../MovementDetection/BackDetection".visible = true
	if location_node.left != null and location_node.left.accessible == true:
		$"../MovementDetection/LeftDetection".visible = true
	if location_node.right != null and location_node.right.accessible == true:
		$"../MovementDetection/RightDetection".visible = true
		
func hide_values(location_node, hide_bg, exception):
	if hide_bg == true:
		location_node.backdrop.visible = false
	for i in range (0,10):
		if location_node.npcs[i] != null and location_node.npcs[i].interact_value != exception:
			location_node.npcs[i].visible = false
		if location_node.objects[i] != null and location_node.objects[i].interact_value != exception:
			location_node.objects[i].visible = false
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
	location_node.npcs[0].available = false
	location_node.objects[0] = $"../Locations/Office/Objects/Telephone"
	location_node.back = location_node_class.new()
	location_node.back.backdrop = $"../Locations/Office/Backdrops/IntroRoomBack"
	location_node.back.forward = location_node
	location_node.back.back = location_node_class.new()
	location_node.back.back.backdrop = $"../Locations/Office/Backdrops/Entryway"
	location_node.back.back.left = location_node_class.new()
	location_node.back.back.left.backdrop = $"../Locations/Office/Backdrops/HallwayTurned"
	location_node.back.back.left.accessible = false #Use as flag, set true after interactions are done
	location_node.back.back.left.forward = location_node_class.new()
	location_node.back.back.left.forward.backdrop = $"../Locations/Office/Backdrops/Transition"
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
