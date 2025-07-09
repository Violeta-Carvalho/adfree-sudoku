extends Node2D

@onready var playtime_label = $PlaytimeLabel

func _ready():
	var minutes = int(Global.TIME / 60)
	var seconds = int(Global.TIME) % 60
	playtime_label.text = "You took %02d:%02d" % [minutes, seconds]

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
