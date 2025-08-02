extends Control



func _on_link_button_pressed() -> void:
	OS.shell_open("https://soundcloud.com/messedup-murphy")


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Active Scenes/UI/main_menu.tscn")
	pass # Replace with function body.


func _on_game_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Active Scenes/test_course.tscn")
	pass # Replace with function body.


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://Active Scenes/UI/credits.tscn")
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
