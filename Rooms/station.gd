class_name Station
extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func is_player_inside() -> bool:
	return $PlayerDetect.get_overlapping_bodies().size() == 1
