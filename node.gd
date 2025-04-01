extends Node


func chat(player : CharacterBody2D, message : String):
	$Control/VBoxContainer3/Chat.add_message(player.name, message)


func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	$Node2D/Area2D/Sprite2D.modulate = Color(0,0,0,1)

func blue():
	$Node2D/Area2D/Sprite2D.modulate = Color(0,0,1,1)

#func _on_area_2d_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	#$Node2D/Area2D/Sprite2D.modulate = Color(1,1,1,1)
	#print("b")
