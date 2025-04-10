extends Interactable
var current_node: String

func _init():
	interact_type = "movement"
	interact_label = "movement"

func _ready():
	current_node = get_path()
	print(current_node)
	match current_node:
		"/root/Root/MovementDetection/ForwardDetection": 
			interact_value = "forward"
			interact_label = "forward"
		"/root/Root/MovementDetection/BackDetection": 
			interact_value = "back"
			interact_label = "back"
		"/root/Root/MovementDetection/LeftDetection": 
			interact_value = "left"
			interact_label = "left"
		"/root/Root/MovementDetection/RightDetection": 
			interact_value = "right"
			interact_label = "right"
