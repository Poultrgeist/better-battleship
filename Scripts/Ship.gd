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
enum {INIT, IDLE, MOVING, INVULNERABLE, DEAD}
var state = INIT

onready var _health_system = $Health

func _ready():
	target_pos = Vector2(-10, -100)
	_init_health()
	$Game.connect("start_turn", self, "_on_Game_start_turn")
	$Game.connect("start_sim", self, "_on_Game_start_sim")
	$Game.connect("end_sim", self, "_on_Game_end_sim")

func turn_reset():
	state = IDLE
	print("Turn reset")

func move():
	pass

func _process(delta):
	thrust = Vector2()
	spin_dir = 0
	
	if state == MOVING:
		thrust = Vector2(speed, 0)
		spin_dir = sign(linear_velocity.angle_to(self.position.direction_to(target_pos)))

func _input(event):
	if (event is InputEventMouseButton && event.is_pressed() && event.button_index == BUTTON_LEFT):
		target_pos = get_global_mouse_position()
		print("target set: ", target_pos)
	elif (Input.is_action_just_released("ui_accept")):
		if state == IDLE:
			state = MOVING
		else:
			state = IDLE

func _on_TurnTimer_timeout():
	state = IDLE

func _integrate_forces(physics_state):
	# Moves RB forward based on rotation
	set_applied_force(thrust.rotated(rotation))
	
	if state == IDLE:
		if (linear_velocity.length_squared() == 0):
			pass
		elif (linear_velocity.length_squared() < 0.01):
			linear_velocity = Vector2(0, 0)
		else:
			add_central_force(-linear_velocity * 4)

		if (angular_velocity == 0):
			set_applied_torque(0)
		elif (angular_velocity < 0.1):
			angular_velocity = 0
		else:
			add_torque(-angular_velocity * 2)
			print("flipping")
			
	if state == MOVING:
		var right_dir = Vector2(1, 0)
		var angle_to_point = right_dir.rotated(rotation).angle_to(self.position.direction_to(target_pos))
		#var angle_error = right_dir.rotated(rotation).angle() / self.position.direction_to(target_pos).angle()
		if (abs(angle_to_point) < 0.01):
			# Actual setting of the angle
			set_applied_torque(0)
			look_follow(physics_state, self.position, target_pos)
			#print(angular_velocity)
		elif (abs(angle_to_point) < 0.25):
			# Reduce speed
			set_angular_velocity(angle_to_point / physics_state.get_step() * 0.02)
			# Graveyard
			#set_angular_velocity(spin_dir * abs(angle_error - 1) * 1 / physics_state.get_step())
			#set_applied_torque(spin_dir * abs(angle_error) * 10)
			#print("small angle: ", angle_to_point)
		else:
			# When not close to wanted angle, add max force
			set_angular_velocity(spin_dir * spin_speed / physics_state.get_step() * 0.01)
		
func look_follow(physics_state, current_transform, target_position):
	
	var right_dir = Vector2(1, 0)
	#var rotation_angle = physics_state.linear_velocity.angle_to(current_transform.direction_to(target_position))
	var rotation_angle = right_dir.rotated(rotation).angle_to(current_transform.direction_to(target_position))

	physics_state.set_angular_velocity(rotation_angle / physics_state.get_step())
	#print("this is suck")

#func _integrate_forces(state):
#	var target_position = $my_target_spatial_node.get_global_transform().origin
#	look_follow(state, get_global_transform(), target_position)

func _init_health():
	_health_system.set_max_health(max_health)
	_health_system.reset_health()



func _on_Game_start_turn():
	pass # Replace with function body.
