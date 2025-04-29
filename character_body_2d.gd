extends CharacterBody2D


const SPEED = 800.0
const JUMP_VELOCITY = -400.0
@onready var textbox = get_parent().get_parent().get_parent().get_child(0).get_child(1).get_child(0)
var grappleLoaded = 0
var Grapple : grapple
var maxSpeed = 1500
var gravVel = Vector2.ZERO

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
			if get_multiplayer_authority() == 1:
				useGrapple(get_viewport().get_mouse_position() * 2)
			else:
				rpc("useGrapple", get_viewport().get_mouse_position() * 2)
			get_parent().add_child(Grapple)
			grappleLoaded = 1
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
		swing2(delta)
	var pastPos = global_position
	velocity = velocity.normalized() * min(velocity.length(), maxSpeed)
	move_and_slide()
	
	
	#playerVel = playerVel + pullVel
	
	#velocity += pastPos - global_position
	
#func swing(delta : float):
	#if playerVel.length() < 0.01:
		#return 
	#var rVel = playerVel + pullVel
	#var angle = acos(rVel.dot(global_position - Grapple.global_position) / (Grapple.distFromPlayer * rVel.length()))
	#var rad_vel = cos(angle) * rVel.length()
	#var swingVel = ((global_position - Grapple.global_position).normalized() * -rad_vel) + ((global_position - Grapple.global_position).normalized() * SPEED * delta)
	#playerVel += swingVel
	#print(str(swingVel) + "swingVel")
	#if Grapple.global_position.distance_to(global_position) > Grapple.distFromPlayer:
		#var lentomove = Grapple.global_position.distance_to(global_position) - Grapple.distFromPlayer
		#var dirtomove = (Grapple.global_position - global_position).normalized()
		##velocity -= get_gravity() * rad_vel * delta
		##tlerp = lerp(global_position, Grapple.global_position, (Grapple.global_position.distance_to(global_position) - Grapple.distFromPlayer)/Grapple.distFromPlayer)
		##vlerp = tlerp - global_position
		#var vercomp = (global_position - Grapple.global_position).normalized().y * lentomove
		#print(vercomp)
		#playerVel -= ((global_position - Grapple.global_position).normalized() * SPEED * delta)
		#pullVel = lentomove * dirtomove
		#if vercomp > 0:
			#playerVel -= get_gravity() * delta * vercomp
		#
	##if pullVel.length() > Grapple.global_position.distance_to(global_position) - Grapple.distFromPlayer:
		##pullVel = (Grapple.global_position.distance_to(global_position) - Grapple.distFromPlayer) * (Grapple.global_position - global_position).normalized()

func swing2(delta : float):
	velocity += (Grapple.position - position) * 10000 * delta
	if position.distance_to(Grapple.position) <= 100:
		Grapple.queue_free()
		grappleLoaded = 0
	
	#counters pull of gravity
	#velocity += (Grapple.global_position - global_position).normalized() * get_gravity().length() * delta
	
	
	#var pNF = (position + velocity)
	#if pNF.distance_to(Grapple.position) > Grapple.distFromPlayer + 50 and position.y > Grapple.position.y:
		#print(str(velocity) + "preVel")
		#velocity += (Grapple.position - position).normalized() * velocity.y
		#var wPNF = lerp(global_position, Grapple.global_position, ( Grapple.distFromPlayer - Grapple.global_position.distance_to(global_position))/Grapple.distFromPlayer)
		#velocity = (position - wPNF)
		#print(str(velocity) + "realVel")
	#takes cur vel (after adding gravity)


@rpc("authority", "call_local")
func useGrapple(dir):
	Grapple = grapple.create(dir, self)

@rpc()
func chat(text : String):
	print(self)
	get_tree().root.get_child(0).chat(self, text)

@rpc()
func blue():
	print(self)
	get_tree().root.get_child(0).blue()
