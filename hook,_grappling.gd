extends Node2D
class_name grapple

const my_scene = preload("res://hook,_grappling.tscn")
const speed = 1000
# Called when the node enters the scene tree for the first time.
var dir : Vector2
var flying = true
var controller : CharacterBody2D
var distFromPlayer : float
var retracting = false

static func create(direction : Vector2, controller : CharacterBody2D) -> grapple:
	var temp = my_scene.instantiate()
	temp.dir = direction
	temp.position = controller.global_position
	temp.controller = controller
	print("yippee")
	return temp

func _ready() -> void:
	print(dir) # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if flying:
		position += dir * speed * delta
		distFromPlayer = max(global_position.distance_to(controller.global_position) + 25, 100)		
	else:
		if global_position.distance_to(controller.global_position) > distFromPlayer:
			controller.global_position = lerp(controller.global_position, global_position, (global_position.distance_to(controller.global_position)-distFromPlayer)/global_position.distance_to(controller.global_position))
	if retracting and global_position.distance_to(controller.global_position) > 50:
		distFromPlayer -= 1


func _on_grapple_box_area_entered(area: Area2D) -> void:
	flying = false

func retract():
	retracting = true
