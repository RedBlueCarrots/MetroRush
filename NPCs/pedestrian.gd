extends CharacterBody3D

const JUMP_VELOCITY = 15
const GRAVITY = 140
var count = 0
@onready var navigation_agent := $NavigationAgent3D
var movement_speed = randf_range(8, 14)
var override := false
func set_dest(spot: Vector3, spawn: Vector3):
	position = spawn
	$NavigationAgent3D.target_position = spot
	$NavigationAgent3D.max_speed = movement_speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.y -= get_physics_process_delta_time()*GRAVITY
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer3D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return 
	if navigation_agent.is_navigation_finished():
		navigation_agent.target_position = Global.all_room_pos.pick_random()

	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var new_velocity: Vector3 = global_position.direction_to(next_path_position) * movement_speed
	new_velocity.y = velocity.y
	navigation_agent.set_velocity(new_velocity)
	
	if abs(velocity.x) < 1 and abs(velocity.z) < 1:
		count += 1
	else:
		count = 0
	if count >= 30:
		count = 0



func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity#+Vector3.UP*velocity.y
	if is_on_wall() and $RayCast3D.is_colliding():
		velocity.y = JUMP_VELOCITY
	elif is_on_wall():
		velocity.y = 0.1
	move_and_slide()
