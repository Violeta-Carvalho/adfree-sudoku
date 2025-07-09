extends PanelContainer

signal pressed

@export var number: int = 0
@export var blocked: bool = false
var with_error: bool = false

@onready var label = $Label

func _ready() -> void:
	set_number(number)
	if blocked:
		block()
		
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and not blocked:
		pressed.emit(self)

func block() -> void:
	get("theme_override_styles/panel").set("bg_color", "#aeaeae")
	label.set("theme_override_colors/font_color", "#000000")
	

func select() -> void:
	get("theme_override_styles/panel").set("bg_color", "#471396")
	label.set("theme_override_colors/font_color", "#ffffff")
		
func deselect() -> void:
	get("theme_override_styles/panel").set("bg_color", "#f4f4f4")
	label.set("theme_override_colors/font_color", "#000000")
	
func add_error() -> void:
	with_error = true
	get("theme_override_styles/panel").set("bg_color", "#F7374F")
	
func remove_error() -> void:
	with_error = false
	
	if blocked:
		block()
	else:
		deselect()
	
func set_number(newNumber: int) -> void:
	self.number = newNumber
	
	if newNumber == 0:
		label.text = ""
	else:
		label.text = str(newNumber)
