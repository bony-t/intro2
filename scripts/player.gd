extends CharacterBody2D

const SPEED = 130.0
var JUMP_VELOCITY = -300.0
var canDoubleJump = false
var hasDoubleJumped = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	# Add the gravity.
	if !is_on_floor():
		velocity.y += gravity * delta

	# Handle jump and double jump dosent need to check if on floor first time
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			hasDoubleJumped = false
		elif (!is_on_floor()) and canDoubleJump and (!hasDoubleJumped):
			velocity.y = JUMP_VELOCITY
			hasDoubleJumped = true
		

	# Get the input direction: -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_double_jump_power_up_body_entered(body: Node2D) -> void:
	canDoubleJump = true
	#used to get rid of the jump coin
	var parent = self.get_parent()
	for n in parent.get_child_count():
		if parent.get_child(n).name == "PickUps":
			var PickUps = parent.get_child(n)
			var powerUp = PickUps.get_child(0)
			powerUp.queue_free()
