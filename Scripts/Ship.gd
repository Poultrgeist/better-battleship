extends RigidBody2D

class_name Ship

export (int) var team
export (int) var max_health
export (int) var speed = 50
export (int) var spin_speed = 1
var torpedoes : int
var turrets : Array

var target_pos : Vector2
var thrust : Vector2 = Vector2()
var spin_dir : int = 0
var selected : bool = false
enum {INIT, IDLE, MOVING, INVULNERABLE, DEAD}
var state = INIT

onready var _health_system = $Health
onready var Game = get_node("/root/Game")

func _ready():
	target_pos = Vector2.ZERO
	_init_health()
	_connect_signals()

#func turn_reset():
#	state = IDLE
#	print("Turn reset")

func move():
	pass

func _process(delta):
	thrust = Vector2()
	spin_dir = 0
	
	if state == MOVING:
		thrust = Vector2(speed, 0)
		spin_dir = sign(linear_velocity.angle_to(get_position().direction_to(target_pos)))

func _input(event):
	if (event is InputEventMouseButton && event.is_pressed() && event.button_index == BUTTON_LEFT):
		var mouse_pos = get_global_mouse_position()
		if mouse_pos != Vector2.ZERO:
			target_pos = mouse_pos
			print("target set: ", target_pos)

func _on_TurnTimer_timeout():
	state = IDLE

func _integrate_forces(physics_state):
	# Moves RB forward based on rotation
	set_applied_force(thrust.rotated(rotation))
	
	if state == IDLE:
		# slows velocity to 0
		if (linear_velocity.length_squared() == 0):
			pass
		elif (linear_velocity.length_squared() < 0.01):
			linear_velocity = Vector2(0, 0)
		else:
			add_central_force(-linear_velocity * 4)
		
		# slows angular_velocity to 0, prob can use some curve for this
		if (angular_velocity == 0):
			set_applied_torque(0)
		elif (angular_velocity < 0.1):
			angular_velocity = 0
		else:
			add_torque(-angular_velocity * 6) # change to set velo?
			
	if state == MOVING:
		var right_dir = Vector2(1, 0)
		var angle_to_point = right_dir.rotated(rotation).angle_to(get_position().direction_to(target_pos))
		if (abs(angle_to_point) < 0.01):
			# Point at the target
			set_applied_torque(0)
			look_follow(physics_state, get_position(), target_pos)
		elif (abs(angle_to_point) < 0.25):
			# Reduce speed
			set_angular_velocity(angle_to_point / physics_state.get_step() * 0.02)
		else:
			# When not close to wanted angle, add max force
			set_angular_velocity(spin_dir * spin_speed / physics_state.get_step() * 0.01)
		
func look_follow(physics_state, current_transform, target_position):
	# Points rigidbody directly at a point
	var right_dir = Vector2(1, 0)
	var rotation_angle = right_dir.rotated(rotation).angle_to(current_transform.direction_to(target_position))
	physics_state.set_angular_velocity(rotation_angle / physics_state.get_step())

func _init_health():
	_health_system.set_max_health(max_health)
	_health_system.reset_health()

func _connect_signals():
	Game.connect("start_turn", self, "_on_Game_start_turn")
	Game.connect("start_sim", self, "_on_Game_start_sim")
	Game.connect("end_sim", self, "_on_Game_end_sim")

func _on_Game_start_turn():
	state = IDLE
	
func _on_Game_start_sim():
	state = MOVING

func _on_Game_end_sim():
	state = IDLE

