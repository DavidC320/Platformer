extends Node

var player_score:= 0
var candy:= 0
var lives:= 3

signal player_score_updated(current_score)
signal candy_updated(current_candy)

func add_score(score:int):
	player_score += score
	player_score_updated.emit(player_score)

func add_candy(number_of_candy:int):
	candy += number_of_candy
	candy_updated.emit(candy)

func player_died():
	lives -= 1
	if lives > 0:
		get_tree().reload_current_scene()
	else:
		get_tree().change_scene_to_file("res://Scenes/Menues/GameOver.tscn")

func restart_game():
	player_score= 0
	candy= 0
	lives= 3
