extends StationGen



var station_colors = range(9)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	station_colors = [Materials.COLS[Global.lvl],Materials.COLS[Global.lvl+1], Materials.DEAD_COL]
	get_tree().call_group("Map", "load_map", outp, station_colors)
	for i in range(3):
		if i == 2:
			stations_lookup[i].get_node("Train").queue_free()
		else:
			stations_lookup[i].get_node("Train").load_train(station_colors[i])
	if Global.lvl == 1:
		print(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_main_game_timeout() -> void:
	get_tree().call_group("Train", "close")
	$End.start()


func _on_end_timeout() -> void:
	if stations_lookup[1].is_player_inside() or stations_lookup[1].is_player_inside():
		$Win.play()
		await $Win.finished
		$UI.fade_out()
	else:
		$Lose.play()


func _on_start_timeout() -> void:
	$MainGame.start()
	get_tree().call_group("Train", "open")
