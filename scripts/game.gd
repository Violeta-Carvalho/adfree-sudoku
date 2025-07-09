extends Control

var selected_square

@onready var playtime_label = $MarginContainer/VBoxContainer/HBoxContainer2/PlaytimeLabel
@onready var high_score_label = $MarginContainer/VBoxContainer/HBoxContainer2/HighScoreLabel
@onready var timer = $Timer

@onready var grid = $MarginContainer/VBoxContainer/GridContainer
@onready var all_squares: Array = grid.get_children()

func _ready():
	for square in all_squares:
		square.pressed.connect(on_select_square)
		
	if Global.save_data.high_score:
		var minutes = int(Global.save_data.high_score / 60)
		var seconds = int(Global.save_data.high_score) % 60
		high_score_label.text = "High Score: %02d:%02d" % [minutes, seconds]
		
	if Global.save_data.current_game != []:
		for i in range(81):
			var square_value = Global.save_data.current_game[i]
			grid.get_child(i).set_number(square_value)
			
			if Global.save_data.current_blocks[i]:
				grid.get_child(i).block()
	else:
		var difficulty := 50
		var puzzle := generate_puzzle(difficulty)
		
		for i in range(81):
			var square_value = puzzle[i]
			grid.get_child(i).set_number(square_value)
			
			if square_value > 0:
				grid.get_child(i).block()
			Global.save_data.current_blocks.append(square_value > 0)
			
	check_done()
		
	timer.timeout.connect(_on_timer_timeout)
	timer.start()
	
func generate_puzzle(difficulty: int) -> Array:
	var full_board := generate_sudoku()
	var puzzle := full_board.duplicate()

	var indices := []
	for i in puzzle.size():
		indices.append(i)

	indices.shuffle()

	for i in range(difficulty):
		puzzle[indices[i]] = 0

	return puzzle

func generate_sudoku() -> Array:
	var board := []
	for i in 81:
		board.append(0)
	_fill_board(board)
	return board

func _fill_board(board: Array) -> bool:
	for i in board.size():
		if board[i] == 0:
			var numbers := _shuffle(range(1, 10))
			for num in numbers:
				if _is_valid(board, i, num):
					board[i] = num
					if _fill_board(board):
						return true
					board[i] = 0
			return false
	return true

func _is_valid(board: Array, index: int, num: int) -> bool:
	var row := index / 9
	var col := index % 9

	for i in 9:
		if board[row * 9 + i] == num or board[i * 9 + col] == num:
			return false

	var box_row := (row / 3) * 3
	var box_col := (col / 3) * 3
	for r in range(box_row, box_row + 3):
		for c in range(box_col, box_col + 3):
			if board[r * 9 + c] == num:
				return false

	return true

func _shuffle(arr: Array) -> Array:
	var shuffled := arr.duplicate()
	for i in range(shuffled.size() - 1, 0, -1):
		var j := randi() % (i + 1)
		var temp: int = shuffled[i]
		shuffled[i] = shuffled[j]
		shuffled[j] = temp
	return shuffled
	
func _on_timer_timeout():
	Global.TIME += 1
	var minutes = int(Global.TIME / 60)
	var seconds = int(Global.TIME) % 60
	playtime_label.text = "%02d:%02d" % [minutes, seconds]
		
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
	
func save_current_game():
	var current_game = []
	
	for square in all_squares:
		current_game.append(square.number)
		
	Global.save_data.current_game = current_game
	Global.save_data.save()

func on_button_pressed(number: int):
	if selected_square:
		selected_square.set_number(number)
		selected_square.deselect()
		selected_square = null
		
	check_done()
	save_current_game()

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

func _on_new_game_button_pressed() -> void:
	Global.save_data.current_game = []
	Global.save_data.save()
	timer.stop()
	Global.TIME = 0
	
	get_tree().reload_current_scene()
