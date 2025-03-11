extends Label


# Called when the node enters the scene tree for the first time.
func add_message(playerName : String, msgText : String):
	text += "\n" + playerName + ": " + msgText
