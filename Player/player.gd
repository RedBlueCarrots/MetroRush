extends CharacterBody3D

enum STAIRSMODE {OFF, UP, DOWN}
var stair_state := STAIRSMODE.OFF
var last_step = 0
var step_wait := false

const ACCEL = 2.8
const JUMP_VELOCITY = 20
const GRAVITY = 140
const FRICTION = 0.005
const MOUSE_SENSITIVITY = 0.0035

var init_transform : Transform3D
var map_mode := false
var slipping := 0.0

func _ready() -> void:
	init_transform = $Meshes/Map/MapCam.transform
	print(init_transform)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$Meshes/Map.mesh.material.albedo_texture.viewport_path = get_path_to($MapView)

func toggle_map():
	map_mode = !map_mode
	$Meshes/Map.visible = map_mode
	if map_mode:
		sync_cams()
	else:
		map_mode = true
		unsync_cams()

func _process(delta: float) -> void:
	$Meshes/Guitar.visible = Global.has_guitar
	if Input.is_action_just_pressed("map"):
		toggle_map()
	if Input.is_action_just_pressed("Bash") and !$AnimationPlayer2.is_playing():
		$AnimationPlayer2.play("Bash")

func _physics_process(delta: float) -> void:
	slipping -= delta
	velocity.y -= GRAVITY*delta
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if stair_state == STAIRSMODE.OFF:
		if slipping <= 0:
			var input_dir := Input.get_vector("left", "right", "forward", "back")
			input_dir = input_dir.rotated(-$SpringArm3D.rotation.y)
			var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
			if direction and !map_mode:
				velocity.x += direction.x * ACCEL
				velocity.z += direction.z * ACCEL
		velocity.x *= pow(FRICTION, delta)
		velocity.z *= pow(FRICTION, delta)
	
	
	else:
		var amount_up = JUMP_VELOCITY * 0.9
		var mult = 1
		if stair_state == STAIRSMODE.DOWN:
			amount_up = JUMP_VELOCITY*0.4
			mult = -1
		if is_on_floor():
			step_wait = false
		if not step_wait:
			if last_step != 1:
				if Input.is_action_just_pressed("step_right"):
					last_step = 1
					velocity.y = amount_up
					step_wait = true
					var tw = get_tree().create_tween()
					tw.tween_property(self, "position:z", position.z - 3 * mult, 0.1)
					tw.play()
			if last_step != -1:
				if Input.is_action_just_pressed("step_left"):
					last_step = -1
					velocity.y = amount_up
					step_wait = true
					var tw = get_tree().create_tween()
					tw.tween_property(self, "position:z", position.z - 3 * mult, 0.1)
					tw.play()

	move_and_slide()
	if abs(velocity.x) + abs(velocity.z) > 1:
		$Meshes.rotation.y = Vector2(-velocity.x, velocity.z).angle()
		if slipping <= 0.0:
			$AnimationPlayer.play("run")
	elif slipping <= 0.0:
		$AnimationPlayer.play("idle")
	for c in range(get_slide_collision_count()):
		if get_slide_collision(c).get_collider() is NPC:
			velocity *= Vector3(0,1, 0)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and !map_mode:
		$SpringArm3D.rotation.y -= event.relative.x * MOUSE_SENSITIVITY
		$SpringArm3D.rotation.x -= event.relative.y * MOUSE_SENSITIVITY

func sync_cams():
	var tw = get_tree().create_tween()
	$Meshes/Map/MapCam.global_transform = $SpringArm3D/Camera3D.global_transform
	$SpringArm3D/Camera3D.current = false
	$Meshes/Map/MapCam.current = true
	tw.tween_property($Meshes/Map/MapCam, "transform", init_transform, 0.4)
	tw.play()

func unsync_cams():
	var tw = get_tree().create_tween()
	tw.tween_property($Meshes/Map/MapCam, "global_transform", $SpringArm3D/Camera3D.global_transform, 0.4)
	tw.tween_property($SpringArm3D/Camera3D, "current", true, 0.01)
	tw.tween_property($Meshes/Map/MapCam, "current", false, 0.01)
	tw.tween_property(self, "map_mode", false, 0.01)
	tw.play()

func stairs_enter():
	if stair_state == STAIRSMODE.OFF:
		velocity.x = 0
		velocity.z = 0
		$Meshes.rotation.y = Vector2(0, 1).angle()
		stair_state = STAIRSMODE.DOWN
	if stair_state == STAIRSMODE.UP:
		stair_state = STAIRSMODE.OFF
		last_step = 0

func stairs_exit():
	if stair_state == STAIRSMODE.OFF:
		stair_state = STAIRSMODE.UP
		velocity.x = 0
		velocity.z = 0
		$Meshes.rotation.y = Vector2(0, -1).angle()
	if stair_state == STAIRSMODE.DOWN:
		stair_state = STAIRSMODE.OFF
		last_step = 0

func slip():
	slipping = 1.0
	$AnimationPlayer.play("Slip")


func _on_bash_body_entered(body: Node3D) -> void:
	if !$Meshes/Guitar/CollisionShape3D.disabled and Global.has_guitar:
		body.bash($Meshes/Guitar.global_position)
