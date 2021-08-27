extends Control
class_name Health

onready var health : int = 100
onready var max_health : int = 100

onready var health_bar = $HealthBar
onready var update_tween = $UpdateTween

export (Color) var green_color = Color.green
export (Color) var yellow_color = Color.yellow
export (Color) var red_color = Color.red
export (float, 0, 1, 0.05) var yellow_percentage = 0.65
export (float, 0, 1, 0.05) var red_percentage = 0.3

func _ready():
	pass

func set_max_health(m : int):
	max_health = m
	update_max_health()

func reset_health():
	health = max_health
	update_health()

func add_health(h : int):
	health += h
	update_health()

func sub_health(h : int):
	health -= h
	update_health()

func is_dead() -> bool:
	if health <= 0:
		return true
	else:
		return false
		
func update_health():
	_assign_color()
	update_tween.interpolate_property(health_bar, "value", health_bar.value, health, 0.3)
	update_tween.start()

func update_max_health():
	health_bar.max_value = max_health

func _assign_color():
	if health < health_bar.max_value * red_percentage:
		health_bar.tint_progress = red_color
	elif health < health_bar.max_value * yellow_percentage:
		health_bar.tint_progress = yellow_color
	else:
		health_bar.tint_progress = green_color
