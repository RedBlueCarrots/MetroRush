class_name Stairs
extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_enter_body_entered(body: Node3D) -> void:
	body.stairs_enter()
	print("in")


func _on_exit_body_entered(body: Node3D) -> void:
	body.stairs_exit()
