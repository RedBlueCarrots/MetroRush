#extends StaticBody3D
#
#func load_train(idx: int):
	#$Front.mesh = load("res://Models/Trains/train-"+str(idx)+".vox")
	#$Back.mesh = load("res://Models/Trains/train-"+str(idx)+".vox")
#
#func _ready() -> void:
	#for i in range(9):
		#load_train(i)
		#var data_path := "res://Models/Trains/Materials/mat-"+str(i)+".tres"
		#ResourceSaver.save($Front.mesh.get("surface_0/material"), data_path)
#


extends StaticBody3D

func load_train(col: Color):
	$Front.set_surface_override_material(0, Materials.TRAIN_MAT)
	$Front.set_instance_shader_parameter("train_col", col)
	$Back.set_surface_override_material(0, Materials.TRAIN_MAT)
	$Back.set_instance_shader_parameter("train_col", col)
	for d in $Doors.get_children():
		var todo = [d.get_node("AnimatableBody3D/MeshInstance3D"), d.get_node("AnimatableBody3D2/MeshInstance3D")]
		for c in todo:
			c.set_surface_override_material(0, Materials.TRAIN_MAT)
			c.set_instance_shader_parameter("train_col", col)

func _ready() -> void:
	pass

func open():
	for c in $Doors.get_children():
		c.get_node("AnimationPlayer").play("Open")
func close():
	for c in $Doors.get_children():
		c.get_node("AnimationPlayer").play("Close")
