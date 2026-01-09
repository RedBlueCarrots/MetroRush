extends CharacterBody3D


const ACCEL = 2.8
const JUMP_VELOCITY = 20
const GRAVITY = 140
const FRICTION = 0.005
const MOUSE_SENSITIVITY = 0.0035

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
func _physics_process(delta: float) -> void:
	velocity.y -= GRAVITY*delta
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	input_dir = input_dir.rotated(-$SpringArm3D.rotation.y)
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x += direction.x * ACCEL
		velocity.z += direction.z * ACCEL
	velocity.x *= pow(FRICTION, delta)
	velocity.z *= pow(FRICTION, delta)

	move_and_slide()
	
	$Meshes.rotation.y = Vector2(-velocity.x, velocity.z).angle()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		$SpringArm3D.rotation.y -= event.relative.x * MOUSE_SENSITIVITY
		$SpringArm3D.rotation.x -= event.relative.y * MOUSE_SENSITIVITY
