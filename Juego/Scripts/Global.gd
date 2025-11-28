extends Node

const SAVEFILE = "user://SAVEFILE.save"

var game_data: Dictionary = {
	"level": -1,
}

func _ready() -> void:
	cargar()

func guardar() -> void:
	var file = FileAccess.open(SAVEFILE, FileAccess.WRITE)
	file.store_var(game_data)
	file = null

func cargar() -> void:
	var file = FileAccess.open(SAVEFILE, FileAccess.READ)
	if file == null:
		guardar()
	else:
		game_data = file.get_var()
	guardar()
	file = null
