extends MarginContainer

@onready var score_label = $VBoxContainer/Label
@onready var candy_label = $VBoxContainer/Label2
@onready var lives_label = $VBoxContainer/Label3

# Called when the node enters the scene tree for the first time.
func _ready():
	update_score(SCORE.player_score)
	update_candy(SCORE.candy)
	print(SCORE.lives)
	lives_label.text =  "Lives: "+ str(SCORE.lives)
	SCORE.player_score_updated.connect(update_score)
	SCORE.candy_updated.connect(update_candy)

func update_score(score:int):
	score_label.text =  "Score: "+ str(score*100).pad_zeros(3)

func update_candy(candy:int):
	candy_label.text =  "Candy: "+ str(candy).pad_zeros(3)