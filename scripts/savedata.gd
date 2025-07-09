class_name SaveData extends Resource

@export var high_score: float = 0.0
@export var current_game: Array = []
@export var current_blocks: Array = []

const SAVE_PATH = "user://save_data.tres"

func save():
	ResourceSaver.save(self, SAVE_PATH)
	
static func load_or_create():
	var res: SaveData
	
	if FileAccess.file_exists(SAVE_PATH):
		res = load(SAVE_PATH) as SaveData
	else:
		res = SaveData.new()
		res.save()
		
	return res
	
