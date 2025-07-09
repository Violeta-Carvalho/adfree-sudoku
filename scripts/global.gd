extends Node

var TIME = 0.0

var save_data: SaveData

func _ready():
	save_data = SaveData.load_or_create()
