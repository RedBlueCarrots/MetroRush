extends StationGen



var station_colors = [randi()%9,randi()%9,randi()%9]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var allcols = range(9)
	allcols.shuffle()
	station_colors = allcols
	super()
	get_tree().call_group("Map", "load_map", outp, station_colors)
	for i in range(3):
		stations_lookup[i].get_node("Train").load_train(station_colors[i])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_main_game_timeout() -> void:
	get_tree().call_group("Train", "close")
	$End.start()


func _on_end_timeout() -> void:
	if stations_lookup[1].is_player_inside() or stations_lookup[1].is_player_inside():
		$Win.play()
	else:
		$Lose.play()


func _on_start_timeout() -> void:
	$MainGame.start()
