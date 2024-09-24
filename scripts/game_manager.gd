extends Node

var score = 0

@onready var score_label = $ScoreLabel
@onready var Camera = %Camera2DMain
@onready var EscMenuNode = %EscMenu # Grabs the EscMenu Scene

var esc_pressed = false
var is_scene_visible = false

# Function to toggle the scene on/off
func _toggle_scene():
	is_scene_visible = !is_scene_visible
	if EscMenuNode != null:
		
		EscMenuNode.visible = is_scene_visible


# Function to call when the Esc key is pressed
func _on_esc_pressed():
	_toggle_scene()
	#stops the game from running when the menu is present
	if is_scene_visible:
		Engine.time_scale = 0
	elif !is_scene_visible:
		Engine.time_scale = 1

func _on_esc_released():
	pass

# Detect key input
func _input(event):
	if event is InputEventKey:
		# Detect initial press of Esc key
		if event.keycode == KEY_ESCAPE and event.pressed and not esc_pressed:
			esc_pressed = true
			_on_esc_pressed()
		
		# Detect release of Esc key
		elif event.keycode == KEY_ESCAPE and not event.pressed and esc_pressed:
			esc_pressed = false
			_on_esc_released()

func _ready():
	EscMenuNode.connect("return_button_pressed", Callable(self, "settings_return_button_pressed"))
	EscMenuNode.visible = false # Start with it hidden
	
func settings_return_button_pressed():
	_on_esc_pressed()
	
func add_point():
	score += 1
	score_label.text = "You collected " + str(score) + " coins."


func _on_esc_menu_visibility_changed() -> void:
	#called deferred so that the @onready
	#can load in the Nodes and Godot dosent throw an error
	call_deferred("_update_camera_position")

func _update_camera_position() -> void:
	if Camera != null and EscMenuNode != null:
		# need to offset because the positions dont match but thankfully it just
		#just needs to be adjusted aspect ratio dosen't affect this
		EscMenuNode.position = Camera.global_position + Vector2(-135, -90)
	else:
		print("Camera or EscMenuNode is null!")
	
