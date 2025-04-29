extends CharacterBody2D
class_name grapple

const my_scene = preload("res://hook,_grappling.tscn")
const speed = 300000
# Called when the node enters the scene tree for the first time.
var target : Vector2
var initial : Vector2
var flying = true
var controller : CharacterBody2D
var distFromPlayer : float
var retracting = false
var rope : Line2D

static func create(target : Vector2, controller : CharacterBody2D) -> grapple:
	print(controller.global_position)
	var temp = my_scene.instantiate()
	temp.global_position = controller.global_position
	temp.controller = controller
	temp.target = target
	temp.initial = temp.position
	return temp

func _ready() -> void:
	rope = $Line2D
	rope.add_point(global_position)
	rope.add_point(global_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rope.set_point_position(0, Vector2(0,0))
	if controller == null:
		return
	rope.set_point_position(1, controller.position - position)
	$Sprite2D2.position = -(position - controller.position).normalized() * distFromPlayer
	if flying:
		velocity = (target - initial).normalized() * speed * delta
		distFromPlayer = max(global_position.distance_to(controller.global_position), 100)
		move_and_slide()
	#else:
		#if global_position.distance_to(controller.global_position) > distFromPlayer:
			#controller.velocity = (controller.global_position - global_position).normalized() * -1 * delta



func _on_grapple_box_area_entered(area: Area2D) -> void:
	flying = false

func retract():
	retracting = true
