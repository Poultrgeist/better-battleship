extends Line2D

onready var Game = get_node("/root/Game")
onready var ship = get_parent()

func _ready():
	_connect_signals()
	add_point(get_position())
	add_point(get_position())

func _process(delta):

	if is_visible():
		var target_pos = ship.target_pos
		set_rotation(-ship.get_rotation())
		set_point_position(0, Vector2.ZERO)
		if target_pos != Vector2.ZERO:
			set_point_position(1, target_pos - ship.get_position())

func _connect_signals():
	Game.connect("start_turn", self, "_on_Game_start_turn")
	Game.connect("start_sim", self, "_on_Game_start_sim")
	Game.connect("end_sim", self, "_on_Game_end_sim")

func _on_Game_start_turn():
	set_visible(true)

func _on_Game_start_sim():
	set_visible(false)

func _on_Game_end_sim():
	pass
