extends Node

enum Teams {BLUE, RED, YELLOW, CYAN, PURPLE}

var teams = []
var team_curr_turn : int

var ships = []

func _ready():
	_init_ships()
	_set_turn()

func _set_turn():
	# Allow ships to set vectors
	pass

func _move_turn():
	# Set ships and turrets to move state
	pass

func _end_turn():
	# Set ships to idle, stop timer?
	for ship in ships:
		ship.turn_reset()
		
	# Decide if game is over
	
	# Update things

func _init_ships():
	var children : Array = get_children()
	
	for child in children:
		if child is Ship:
			ships.append(child)
	
	print("Ship count: ", ships.size())
