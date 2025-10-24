extends CanvasLayer

@onready var continue_button: Button = %ContinueButton
@onready var main_menu_button: Button = %MainMenuButton
@onready var quit_button: Button = %QuitButton
@onready var botones: AudioStreamPlayer = $Botones

func _ready() -> void:
	continue_button.pressed.connect(_on_continue_pressed)
	main_menu_button.pressed.connect(_on_MainMenu_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	visible = false
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = not get_tree().paused
		visible = get_tree().paused
		
func _on_continue_pressed():
	continue_button.disabled = true
	main_menu_button.disabled = true
	quit_button.disabled = true
	botones.play()
	await botones.finished
	visible = false
	get_tree().paused = false

func _on_MainMenu_pressed():
	continue_button.disabled = true
	main_menu_button.disabled = true
	quit_button.disabled = true
	botones.play()
	await botones.finished
	visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Escenasw/UI/main_menu.tscn")
	
func _on_quit_pressed():
	continue_button.disabled = true
	main_menu_button.disabled = true
	quit_button.disabled = true
	botones.play()
	await botones.finished
	get_tree().quit()
