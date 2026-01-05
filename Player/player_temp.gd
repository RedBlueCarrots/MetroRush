extends CharacterBody3D


const SPEED = 50.0
const JUMP_VELOCITY = 40


func _physics_process(delta: float) -> void:
	# Add the gravity.
	velocity *= 0

	# Handle jump.
	if Input.is_action_pressed("ui_accept"):
		velocity.y = -JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#input_dir = input_dir.rotated(PI)
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
