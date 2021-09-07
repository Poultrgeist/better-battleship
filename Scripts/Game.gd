extends Node

enum Teams {BLUE, RED, YELLOW, CYAN, PURPLE}

var teams = []
var team_curr_turn : int

var ships = []

enum {DEFAULT, SIM, INPUT}
var state = DEFAULT

signal start_turn
signal start_sim
signal end_sim
signal mouse_click(selected_ship)

func _ready():
	_init_ships()
	_start_turn()

func _start_turn():
	# Allow ships to set vectors
	state = INPUT
	emit_signal("start_turn")
	

func _start_sim():
	# Set ships and turrets to move state
	state = SIM
	emit_signal("start_sim")
	

func _end_sim():
	# set state to default, 
	state = DEFAULT
	emit_signal("end_sim")
	
	# Set ships to idle, stop timer?
#	for ship in ships:
#		ship.turn_reset()
		
	# Decide if game is over
	
	# Update things
	
	# run set turn
	_start_turn()

func _input(event):
	if Input.is_action_just_released("ui_accept"):
		if state == INPUT:
			_start_sim()
		elif state == SIM:
			_end_sim()
	
#	if (event is InputEventMouseButton && event.is_pressed() && event.button_index == BUTTON_LEFT):
#		if mouse_pos

func _init_ships():
	var children : Array = get_children()
	
	for child in children:
		if child is Ship:
			ships.append(child)
	
	print("Ship count: ", ships.size())
