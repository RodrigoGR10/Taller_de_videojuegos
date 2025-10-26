extends CanvasLayer

@onready var continue_button: Button = %ContinueButton
@onready var main_menu_button: Button = %MainMenuButton
@onready var quit_button: Button = %QuitButton
@onready var botones: AudioStreamPlayer = $Botones
@onready var return_button: Button = $Panel/ReturnButton
@onready var panel: Panel = $Panel
@onready var controls: Button = %Controls

func _ready() -> void:
	panel.visible = false
	controls.pressed.connect(_on_controls_pressed)
	return_button.pressed.connect(_on_return_button_pressed)
	continue_button.pressed.connect(_on_continue_pressed)
	main_menu_button.pressed.connect(_on_MainMenu_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	visible = false
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		continue_button.disabled = false
		controls.disabled = false
		main_menu_button.disabled = false
		quit_button.disabled = false
		get_tree().paused = not get_tree().paused
		visible = get_tree().paused
		
func _on_return_button_pressed():
	botones.play()
	panel.visible = false
		
func _on_continue_pressed():
	continue_button.disabled = true
	controls.disabled = true
	main_menu_button.disabled = true
	quit_button.disabled = true
	botones.play()
	await botones.finished
	visible = false
	get_tree().paused = false
	
func _on_controls_pressed():
	panel.visible = true
	continue_button.disabled = true
	controls.disabled = true
	main_menu_button.disabled = true
	quit_button.disabled = true
	botones.play()
	get_tree().create_timer(0.4).timeout
	continue_button.disabled = false
	controls.disabled = false
	main_menu_button.disabled = false
	quit_button.disabled = false
	
func _on_MainMenu_pressed():
	continue_button.disabled = true
	controls.disabled = true
	main_menu_button.disabled = true
	quit_button.disabled = true
	botones.play()
	await botones.finished
	visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Escenas/UI/main_menu.tscn")
	
func _on_quit_pressed():
	continue_button.disabled = true
	controls.disabled = true
	main_menu_button.disabled = true
	quit_button.disabled = true
	botones.play()
	await botones.finished
	get_tree().quit()
