extends Control
@export var load_points : Array[Vector2] = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var tw = get_tree().create_tween()
	#tw.tween_interval(1)
	#tw.tween_property($FullMap/Map, "scale", Vector2(0.5, 0.5), 0.9)
	#tw.parallel().tween_property($FullMap/Map, "position", load_points[Global.lvl], 0.9)
	#tw.tween_property($FullMap/HBoxContainer/Marker4, "modulate", Color.WHITE, 0.4)
	#tw.tween_interval(5)
	#tw.tween_property($FullMap, "scale", Vector2(0, 0), 0.7)
	#tw.play()
	$FullMap/Marker.position = load_points[Global.lvl]
	var tw2 = get_tree().create_tween()
	var col = Materials.COLS[Global.lvl+1]
	$Label.text = "GET TO THE " + Materials.COL_NAMS[Global.lvl+1] + " LINE"
	tw2.tween_property($Fade, "modulate", Color(0.0, 0.0, 0.0, 0.0), 0.5)
	for i in range(8):
		tw2.tween_property($Label, "theme_override_colors/font_color", Color.LIGHT_GRAY, 0.4)
		tw2.parallel().tween_property($FullMap/Marker, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.4)
		tw2.tween_property($Label, "theme_override_colors/font_color", col, 0.4)
		tw2.parallel().tween_property($FullMap/Marker, "modulate", Color.WHITE, 0.4)
	tw2.tween_property($FullMap, "modulate", Color(1.0, 1.0, 1.0, 0.0), 1.0)
	tw2.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fade_out():
	var tw2 = get_tree().create_tween()
	tw2.tween_property($Fade, "modulate", Color(0.0, 0.0, 0.0, 1.0), 0.5)
	tw2.tween_callback(get_tree().reload_current_scene)
	Global.lvl += 1
	tw2.play()
