extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if randf() < 0.6:
		$Puddle.queue_free()
	else:
		$Puddle.position.x += randf()*14-7
		$Puddle.position.z += randf()*14-7


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass # Replace with function body.
