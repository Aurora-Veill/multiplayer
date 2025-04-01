extends Node

var peer = ENetMultiplayerPeer.new()
@export var chat : PackedScene
@export var player_scene: PackedScene

func host():
	peer.create_server(777)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	add_player()

func add_player(id = 1):
	var player = player_scene.instantiate()
	DisplayServer.window_set_title(str(id))
	player.name = str(id)
	$Players.add_child(player)
	$"../Control/VBoxContainer3/Chat".add_message("Server", str(player.name) + " joined")

func on_join_pressed():
	peer.create_client("localhost", 777)
	multiplayer.multiplayer_peer = peer
