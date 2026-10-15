extends Area2D

var tiles = []
var solved = []
var mouse = false
var emptytile
var numtiles = 25
var numrowcol = sqrt(numtiles)
var tilesize

# Called when the node enters the scene tree for the first time.
func _ready():
	start_game()

func start_game():
	tiles = [$Tile1, $Tile2, $Tile3, $Tile4, $Tile5,
			 $Tile6, $Tile7, $Tile8, $Tile9, $Tile10,
			 $Tile11, $Tile12, $Tile13, $Tile14, $Tile15,
			 $Tile16, $Tile17, $Tile18, $Tile19, $Tile20,
			 $Tile21, $Tile22, $Tile23, $Tile24, $Tile25]
	solved = tiles.duplicate()
	emptytile = $Tile25
	tilesize = emptytile.texture.get_size().x / numrowcol
	shuffle_tiles()
	
func shuffle_tiles():
	var previous = 99
	var previous_1 = 98
	var previous_2 = 97
	for t in range(0,5000):
		var tile = randi() % numtiles
		if tiles[tile] != emptytile and tile != previous and tile != previous_1 and tile != previous_2:
			var rows = int(tiles[tile].position.y / tilesize)
			var cols = int(tiles[tile].position.x / tilesize)
			check_neighbours(rows,cols)
			previous_2 = previous_1
			previous_1 = previous
			previous = tile
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and mouse:
		var mouse_copy = mouse
		print(mouse.position)
		mouse = false
		var rows = int(mouse_copy.position.y / tilesize)
		var cols = int(mouse_copy.position.x / tilesize)
		check_neighbours(rows,cols)
		if tiles == solved:
			print("You win!")

func check_neighbours(rows, cols):
	var empty = false
	var done = false
	var pos = rows * numrowcol + cols
	while !empty and !done:
		var new_pos = tiles[pos].position
		if rows < (numrowcol - 1):
			new_pos.y += tilesize
			empty = find_empty(new_pos,pos)
			new_pos.y -= tilesize
		if rows > 0:
			new_pos.y -= tilesize
			empty = find_empty(new_pos,pos)
			new_pos.y += tilesize
		if cols < (numrowcol - 1):
			new_pos.x += tilesize
			empty = find_empty(new_pos,pos)
			new_pos.x -= tilesize
		if cols > 0:
			new_pos.x -= tilesize
			empty = find_empty(new_pos,pos)
			new_pos.x += tilesize
		done = true
			
func find_empty(newposition,pos):
	var new_rows = int(newposition.y / tilesize)
	var new_cols = int(newposition.x / tilesize)
	var new_pos = new_rows * numrowcol + new_cols
	if tiles[new_pos] == emptytile:
		swap_tiles(pos, new_pos)
		return true
	else:
		return false

func swap_tiles(tile_src, tile_dst):
	var temp_pos = tiles[tile_src].position
	tiles[tile_src].position = tiles[tile_dst].position
	tiles[tile_dst].position = temp_pos
	var temp_tile = tiles[tile_src]
	tiles[tile_src] = tiles[tile_dst]
	tiles[tile_dst] = temp_tile
	
func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		mouse = event
