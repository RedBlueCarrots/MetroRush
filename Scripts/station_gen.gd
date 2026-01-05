extends Node

const DIST_MIN_PLATFORM = 7
const DIST_MIN_EXTRA = 4
const MAP_SIZE = 16

func  _ready() -> void:
	generate_station()

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
		if reps > 10:
			path = []
			cur = a
			reps = 0
		path.append(cur)
	for p in path:
		map[p.x][p.y][0] = 4
		map[p.x][p.y][1] = 4
	return path

func create_path_to_goal(path: Array[Vector2i], goal: Vector2i):
	pass

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
	create_path_to_goal(path1, exit_positions[0])
	print_map(detail_grid)
	
