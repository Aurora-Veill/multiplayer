extends Node


func chat(player : CharacterBody2D, message : String):
	$Control/VBoxContainer3/Chat.add_message(player.name, message)
