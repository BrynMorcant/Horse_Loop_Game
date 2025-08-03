extends Control

@export var main_menu: Control
@export var credits: Control

func _ready() -> void:
	main_menu = get_node("/root/horse_looper_1/Main Menu")
	credits = get_node("/root/horse_looper_1/Credits")

func _on_link_button_pressed() -> void:
	OS.shell_open("https://soundcloud.com/messedup-murphy")


func _on_back_button_pressed() -> void:
	credits.visible = false
	main_menu.visible = true
	pass # Replace with function body.


func _on_game_start_pressed() -> void:
	$Click.play()
	get_tree().change_scene_to_file("res://Scenes/test_course.tscn")
	pass # Replace with function body.
func _on_game_start_mouse_entered() -> void:
	$Hover.play()
	
func _on_credits_pressed() -> void:
	$Click.play()
	main_menu.visible = false
	credits.visible = true
	pass # Replace with function body.
func _on_credits_mouse_entered() -> void:
	$Hover.play()
	pass # Replace with function body.
	
func _on_quit_pressed() -> void:
	$Click.play()
	get_tree().quit()
	pass # Replace with function body.

func _on_quit_mouse_entered() -> void:
	$Hover.play()
	pass # Replace with function body.
