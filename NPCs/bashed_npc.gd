extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func colour(c_hair, c_hat, c_pants, c_skin, c_shirt, c_shoes):
	$Meshes/McRun.set_instance_shader_parameter("shirt", c_shirt)
	$Meshes/McRun.set_instance_shader_parameter("hair", c_hair)
	$Meshes/McRun.set_instance_shader_parameter("hat", c_hat)
	$Meshes/McRun.set_instance_shader_parameter("skin", c_skin)
	$Meshes/McRun.set_instance_shader_parameter("pants", c_pants)
	$Meshes/McRun.set_instance_shader_parameter("shoes", c_shoes)

func apply_delayed(imp:Vector3):
	await get_tree().physics_frame
	apply_impulse(imp, Vector3(0, -2, 0))
