extends CanvasLayer

@onready var retry_button: Button = %RetryButton
@onready var continue_button: Button = %ContinueButton
@onready var main_menu_button: Button = %MainMenuButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	retry_button.pressed.connect(_on_retry_pressed)
	continue_button.pressed.connect(_on_continue_pressed)
	main_menu_button.pressed.connect(_on_MainMenu_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	visible = false
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = not get_tree().paused
		visible = get_tree().paused
		
func _on_continue_pressed():
	visible = false
	get_tree().paused = false
	
func _on_retry_pressed():
	visible = false
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_MainMenu_pressed():
	visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Escenas/UI/main_menu.tscn")
	
func _on_quit_pressed():
	get_tree().quit()
