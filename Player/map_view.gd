extends TileMapLayer

#up, right, down, left
const LOOKUP = {
	"1100": Vector2i(0, 3),
	"0110": Vector2i(0, 2),
	"0011": Vector2i(1, 2),
	"1001": Vector2i(1, 3),
	"1010": Vector2i(2, 3),
	"0101": Vector2i(2, 2),
	"1110": Vector2i(3, 2),
	"0111": Vector2i(3, 1),
	"1011": Vector2i(2, 0),
	"1101": Vector2i(3, 3),
	"1111": Vector2i(2, 1),
	"station": Vector2i(6, 3),
	"station0": Vector2i(6, 3),
	"station1": Vector2i(6, 3),
	"station2": Vector2i(6, 3),
	Color.SADDLE_BROWN: Vector2i(5, 0),
	Color.LIME_GREEN: Vector2i(6, 0),
	Color.YELLOW: Vector2i(6, 1),
	Color.ORANGE: Vector2i(6, 2),
	Color.RED: Vector2i(6, 3),
	Color.MEDIUM_PURPLE: Vector2i(7, 0),
	Color.MIDNIGHT_BLUE: Vector2i(7, 1),
	Color.CYAN: Vector2i(7, 2),
	Color.WEB_GREEN: Vector2i(7, 3),
} 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_map(details: Array[Array], cols: Array):
	print(cols)
	for x in range(details.size()):
		for y in range(details[0].size()-1, -1, -1):
			erase_cell(Vector2i(x, y))
			if details[x][y] in LOOKUP:
				var tile_pos: Vector2i = LOOKUP[details[x][y]]
				if details[x][y].begins_with("station"):
					print(details[x][y])
					tile_pos = LOOKUP[Materials.COLS[cols[int(details[x][y].right(1))]]]
					for xp in range(2):
						for yp in range(2):
							set_cell(Vector2i(x-xp, y+yp), 2, tile_pos)

				set_cell(Vector2i(x, y), 2, tile_pos)
