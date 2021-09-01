extends Node

enum Teams {BLUE, RED, YELLOW, CYAN, PURPLE}

var teams = []
var team_curr_turn : int

var ships = []

enum {DEFAULT, SIM, INPUT}
var state = DEFAULT

signal start_sim
signal end_sim
signal start_turn

func _ready():
	_init_ships()
	_set_turn()

func _set_turn():
	# Allow ships to set vectors
	emit_signal("start_turn")
	pass

func _move_turn():
	# Set ships and turrets to move state
	emit_signal("start_sim")
	pass

func _end_turn():
	emit_signal("end_sim")
	# set state to default, 
	# Set ships to idle, stop timer?
	for ship in ships:
		ship.turn_reset()
		
	# Decide if game is over
	
	# Update things
	
	# run set turn
	_set_turn()

func _input(event):
	if Input.is_action_just_released("ui_accept"):
		if state == INPUT:
			_move_turn()
		elif state == SIM:
			_end_turn()

func _init_ships():
	var children : Array = get_children()
	
	for child in children:
		if child is Ship:
			ships.append(child)
	
	print("Ship count: ", ships.size())
