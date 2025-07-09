extends Control

var selected_square
var elapsed_time = 0.0

@onready var grid = $MarginContainer/VBoxContainer/GridContainer
@onready var all_squares: Array = grid.get_children()
@onready var playtime_label = $MarginContainer/VBoxContainer/HBoxContainer2/PlaytimeLabel
@onready var timer = $Timer

func _ready():
	for square in all_squares:
		square.pressed.connect(on_select_square)
		
	timer.timeout.connect(_on_timer_timeout)
	timer.start()
	
func _on_timer_timeout():
	elapsed_time += 1
	var minutes = int(elapsed_time / 60)
	var seconds = int(elapsed_time) % 60
	playtime_label.text = "%02d:%02d" % [minutes, seconds]  # Format as mm:ss
		
func check_done():
	for square in all_squares:
		square.remove_error()
		
	var subgrid_indexes = [0, 3, 6]
		
	for i in range(9):
		check_row(i)
		check_col(i)
		
	for x in subgrid_indexes:
		for y in subgrid_indexes:
			check_subgrid(x, y)
			
	var won = true
	
	for square in all_squares:
		if square.number == 0 or square.with_error:
			won = false
			break

	if won == true:
		timer.stop()
		get_tree().change_scene_to_file("res://scenes/win.tscn")
		
func check_row(row: int):
	var numbers = []
	var errors = []
	
	for x in range(9):
		var square = get_square(x, row)
		if square.number != 0:
			if square.number in numbers:
				errors.append(square.number)
			else:
				numbers.append(square.number)
				
	for x in range(9):
		var square = get_square(x, row)
		if square.number != 0 and square.number in errors:
			square.add_error()
			
func check_col(col: int):
	var numbers = []
	var errors = []
	
	for y in range(9):
		var square = get_square(col, y)
		if square.number != 0:
			if square.number in numbers:
				errors.append(square.number)
			else:
				numbers.append(square.number)
				
	for y in range(9):
		var square = get_square(col, y)
		if square.number != 0 and square.number in errors:
			square.add_error()
			
func check_subgrid(x: int, y: int):
	var numbers = []
	var errors = []
	
	for i in range(3):
		for j in range(3):
			var square = get_square(x + j, y + i)
			if square.number != 0:
				if square.number in numbers:
					errors.append(square.number)
				else:
					numbers.append(square.number)
				
	for i in range(3):
		for j in range(3):
			var square = get_square(x + j, y + i)
			if square.number != 0 and square.number in errors:
				square.add_error()
		
func get_square(x: int, y: int):
	return grid.get_child(y * 9 + x)
	
func on_select_square(square):
	if selected_square:
		selected_square.deselect()
		
	square.select()
	selected_square = square

func on_button_pressed(number: int):
	if selected_square:
		selected_square.set_number(number)
		selected_square.deselect()
		selected_square = null
		
	check_done()


func _on_button_1_pressed() -> void:
	on_button_pressed(1)


func _on_button_2_pressed() -> void:
	on_button_pressed(2)


func _on_button_3_pressed() -> void:
	on_button_pressed(3)


func _on_button_4_pressed() -> void:
	on_button_pressed(4)


func _on_button_5_pressed() -> void:
	on_button_pressed(5)


func _on_button_6_pressed() -> void:
	on_button_pressed(6)


func _on_button_7_pressed() -> void:
	on_button_pressed(7)


func _on_button_8_pressed() -> void:
	on_button_pressed(8)


func _on_button_9_pressed() -> void:
	on_button_pressed(9)


func _on_button_x_pressed() -> void:
	on_button_pressed(0)
