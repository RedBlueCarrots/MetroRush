extends Node

const ALL_ROOM = preload("res://Rooms/all_room.tscn")
const CORNER_ROOM = preload("res://Rooms/corner_room.tscn")
const STATION = preload("res://Rooms/station.tscn")
const STRAIGHT_ROOM = preload("res://Rooms/straight_room.tscn")
const T_ROOM = preload("res://Rooms/t_room.tscn")

const ROOMS = [ALL_ROOM, CORNER_ROOM, STATION, STRAIGHT_ROOM, T_ROOM]

#up, right, down, left
const ROOM_LOOKUP = {
	"1100": [1, 0],
	"0110": [1, 1],
	"0011": [1, 2],
	"1001": [1, 3],
	"1010": [3, 0],
	"0101": [3, 1],
	"1110": [4, 0],
	"0111": [4, 1],
	"1011": [4, 2],
	"1101": [4, 3],
	"1111": [0, 0],
	"station": [2,0]
}
const DIST_MIN_PLATFORM = 7
const DIST_MIN_EXTRA = 3
const MAP_SIZE = 16

var current_grid: Array[Array]

func  _ready() -> void:
	current_grid = generate_station()
	instance_grid(current_grid)

func get_grid_config(grid: Array[Array], sq: Vector2i):
	var config := ""
	if sq.y == MAP_SIZE-1:
		config += "0"
	else:
		if grid[sq.x][sq.y+1][0] != 0:
			config += "1"
		else:
			config += "0"
	if sq.x == MAP_SIZE-1:
		config += "0"
	else:
		if grid[sq.x+1][sq.y][0] != 0:
			config += "1"
		else:
			config += "0"
	if sq.y == 0:
		config += "0"
	else:
		if grid[sq.x][sq.y-1][0] != 0:
			config += "1"
		else:
			config += "0"
	if sq.x == 0:
		config += "0"
	else:
		if grid[sq.x-1][sq.y][0] != 0:
			config += "1"
		else:
			config += "0"
	return config

func instance_grid(grid: Array[Array]):
	for x in range(MAP_SIZE):
		for y in range(MAP_SIZE):
			if grid[x][y][0] in [0, 2]:
				continue
			var conf = get_grid_config(grid, Vector2i(x, y))
			if grid[x][y][0] == 1:
				conf = "station"
			if not conf in ROOM_LOOKUP:
				continue
			var new_room: StaticBody3D = ROOMS[ROOM_LOOKUP[conf][0]].instantiate()
			$Rooms.add_child(new_room)
			new_room.position = Vector3(x*30, 0, y*30)
			new_room.rotation.y = TAU/4 * ROOM_LOOKUP[conf][1]

func print_map(map):
	for g in map:
		var out = ""
		for d in g:
			if d[0] == 0:
				out += "."
			else:
				out += str(d[1])
		print(out)

func create_path(a: Vector2i, b: Vector2i, map: Array[Array]) -> Array[Vector2i]:
	var cur = a
	var path : Array[Vector2i] = [a]
	var dir := Vector2i(1, 1)
	var repcount = 0
	if b.x < a.x:
		dir.x = -1
	if b.y < a.y:
		dir.y = -1
	var reps = 0
	while cur != b:
		var opt = []
		if b.x != cur.x:
			opt.append("x")
		if b.y != cur.y:
			opt.append("y")
		var c = opt.pick_random()
		var old_cur = cur
		if c == "x":
			cur.x += dir.x
		else:
			cur.y += dir.y
		if map[cur.x][cur.y][0] not in [0, 4]:
			cur = old_cur
			reps += 1
		else:
			reps = 0
			path.append(cur)
		if reps > 10:
			path = []
			cur = a
			reps = 0
			repcount += 1
			if repcount == 30:
				return []
	for p in path:
		map[p.x][p.y][0] = 4
		map[p.x][p.y][1] = 4
	return path

func create_path_to_goal(npath: Array[Vector2i], b: Vector2i, map: Array[Array], repcount: int):
	if repcount == 20:
		return []
	var a = npath.pick_random()
	var cur = a
	var path : Array[Vector2i] = []
	var dir := Vector2i(1, 1)
	if b.x < a.x:
		dir.x = -1
	if b.y < a.y:
		dir.y = -1
	var reps = 0
	while cur != b:
		var opt = []
		if b.x != cur.x:
			opt.append("x")
		if b.y != cur.y:
			opt.append("y")
		var c = "x"
		if map[cur.x+dir.x][cur.y][0] == 4 and "x" in opt:
			c = "x"
		elif map[cur.x][cur.y+dir.y][0] == 4 and "y" in opt:
			c = "y"
		else:
			c = opt.pick_random()
		var old_cur = cur
		if c == "x":
			cur.x += dir.x
		else:
			cur.y += dir.y
		if (map[cur.x][cur.y][0] not in [0, 4]) and (cur != b):
			cur = old_cur
			reps += 1
		else:
			reps = 0
			if cur != b and cur != a:
				path.append(cur)
		if reps > 10:
			return create_path_to_goal(npath, b, map, repcount+1)
	for p in path:
		map[p.x][p.y][0] = 4
		map[p.x][p.y][1] = 4
	return path

# Called when the node enters the scene tree for the first time.
func generate_station():
	var detail_grid: Array[Array] = []
	for i in range(MAP_SIZE):
		var oop = []
		for j in range(MAP_SIZE):
			oop.append([0, 0])
		detail_grid.append(oop)
	var plaform_positions = []
	var exit_positions = []
	
	#Place platforms
	while plaform_positions.size() < 3:
		var new_pos = Vector2i(randi_range(1, MAP_SIZE-2),randi_range(1, MAP_SIZE-2))
		var valid = true
		for p in plaform_positions:
			if abs(p.x-new_pos.x) + abs(p.y-new_pos.y) < DIST_MIN_PLATFORM:
				valid = false
		if valid:
			plaform_positions.append(new_pos)
			for x in range(2):
				for y in range(2):
					detail_grid[new_pos.x+x][new_pos.y+y][0] = 1
					detail_grid[new_pos.x+x][new_pos.y+y][1] = plaform_positions.size()-1
	
	#Place Exits
	while exit_positions.size() < 3:
		var new_pos = Vector2i(randi_range(0, MAP_SIZE-2),randi_range(0, MAP_SIZE-2))
		var valid = true
		for p in plaform_positions:
			if abs(p.x-new_pos.x) + abs(p.y-new_pos.y) < DIST_MIN_PLATFORM:
				valid = false
		for p in exit_positions:
			if abs(p.x-new_pos.x) + abs(p.y-new_pos.y) < DIST_MIN_PLATFORM:
				valid = false
		if valid:
			exit_positions.append(new_pos)
			detail_grid[new_pos.x][new_pos.y][0] = 2
			detail_grid[new_pos.x][new_pos.y][1] = 3
	var path1 := create_path(plaform_positions[0]+Vector2i(1, -1), plaform_positions[1]+Vector2i(1, -1), detail_grid)
	var path2 := create_path(plaform_positions[1]+Vector2i(1, -1), plaform_positions[2]+Vector2i(1, -1), detail_grid)
	var path3 := create_path(plaform_positions[0]+Vector2i(1, -1), plaform_positions[2]+Vector2i(1, -1), detail_grid)
	if path1 == [] or path2 == [] or path3 == []:
		return generate_station()
	var path4 = create_path_to_goal(path1.duplicate(), exit_positions[0], detail_grid, 0)
	var path5 = create_path_to_goal(path2.duplicate(), exit_positions[1], detail_grid, 0)
	var path6 = create_path_to_goal(path3.duplicate(), exit_positions[2], detail_grid, 0)
	if path4 == [] or path5 == [] or path6 == []:
		return generate_station()
	var count = [0, 0, 0]
	for x in range(MAP_SIZE):
		for y in range(MAP_SIZE-1, -1, -1):
			for i in range(3):
				if detail_grid[x][y][0] == 1 and detail_grid[x][y][1] == i and count[i] < 3:
					count[i] += 1
					detail_grid[x][y][0] = 0
	print_map(detail_grid)
	return detail_grid
	
