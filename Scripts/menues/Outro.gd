extends Control

func _on_retry_pressed():
	SCORE.restart_game()
	get_tree().change_scene_to_file("res://Scenes/level_one.tscn")


func _on_quit_pressed():
	get_tree().quit()
