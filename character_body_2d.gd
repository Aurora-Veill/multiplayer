extends CharacterBody2D


const SPEED = 600.0
const JUMP_VELOCITY = -400.0
@onready var textbox = get_parent().get_parent().get_parent().get_child(2).get_child(1).get_child(0)
var grappleLoaded = 0
var Grapple : grapple

func _enter_tree() -> void:
	set_multiplayer_authority(int(str(name)))

func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority():
		return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if get_multiplayer_authority() == 1:
			blue()
		else:
			rpc("blue")
	
	if Input.is_action_just_pressed("send"):
		var temp = textbox.text
		print(textbox.text)
		if get_multiplayer_authority() == 1:
			chat(temp)
		else:
			rpc("chat", temp)
		textbox.text = ""
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if Input.is_action_just_pressed("launch_hook"):
		if grappleLoaded == 0:
			Grapple = grapple.create(Vector2(direction, Input.get_axis("up", "down")), self)
			get_parent().add_child(Grapple)
			grappleLoaded = 1
		elif grappleLoaded == 1:
			Grapple.retract()
			grappleLoaded = 2
		else:
			Grapple.queue_free()
			grappleLoaded = 0
	if Input.is_action_just_pressed("cancel_hook"):
		if grappleLoaded != 0:
			Grapple.queue_free()
			grappleLoaded = 0
	
	if direction:
		velocity.x += direction * SPEED * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
	if grappleLoaded != 0 and !Grapple.flying:
		swing(delta)
	move_and_slide()
	
func swing(delta : float):
	if velocity.length() < 0.01:
		return 
	print(velocity.length())
	var angle = acos(velocity.dot(global_position - Grapple.global_position) / (Grapple.distFromPlayer * velocity.length()))
	var rad_vel = cos(angle) * velocity.length()
	velocity += (global_position - Grapple.global_position).normalized() * -rad_vel
	velocity += (global_position - Grapple.global_position).normalized() * SPEED * delta
@rpc()
func chat(text : String):
	get_tree().root.get_child(0).chat(self, text)

@rpc()
func blue():
	get_tree().root.get_child(0).blue()
