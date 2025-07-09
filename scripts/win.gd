extends Node2D

@onready var playtime_label = $MarginContainer/VBoxContainer/PlaytimeLabel
@onready var highscore_label = $MarginContainer/VBoxContainer/HighScoreLabel

func _ready():
	var time_minutes = int(Global.TIME / 60)
	var time_seconds = int(Global.TIME) % 60
	playtime_label.text = "You took %02d:%02d!" % [time_minutes, time_seconds]
	
	if Global.save_data.high_score == 0 or Global.TIME < Global.save_data.high_score:
		Global.save_data.high_score = Global.TIME
		highscore_label.text = "Congratulations! This is your new highscore!"
	else:
		var highscore_minutes = int(Global.save_data.high_score / 60)
		var highscore_seconds = int(Global.save_data.high_score) % 60
		highscore_label.text = "Your highscore is still %02d:%02d!" % [highscore_minutes, highscore_seconds]
	
	Global.save_data.current_game = []
	Global.save_data.current_blocks = []
	Global.save_data.save()
		
		
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
