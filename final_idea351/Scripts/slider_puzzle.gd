extends Area2D

var tiles = [0, 1, 2, 3,
			 4, 5, 6, 7,
			 8, 9, 10, 11,
			 12, 13, 14, 15]
var tilesA = []
var tilesB = []
var tilesC = []
var solvedA = []
var solvedB = []
var solvedC = []
var mouse = false
var emptytileA
var emptytileB
var emptytileC
var numtiles = len(tiles)
var numrowcol = sqrt(numtiles)
var tilesize = 250
var numAtiles = 5
var numBtiles = 6
var numCtiles = 5
var nullAtile = 16
var nullBtile = 17
var nullCtile = 18

# Called when the node enters the scene tree for the first time.
func _ready():
	start_game()

func start_game():
	tiles.shuffle()
	tilesA = [$A/Tile1, $A/Tile2, $A/Tile3, $A/Tile4,
			 $A/Tile5, $A/Tile6, $A/Tile7, $A/Tile8,
			 $A/Tile9, $A/Tile10, $A/Tile11, $A/Tile12,
			 $A/Tile13, $A/Tile14, $A/Tile15, $A/Tile16]
	tilesB = [$B/Tile1, $B/Tile2, $B/Tile3, $B/Tile4,
			 $B/Tile5, $B/Tile6, $B/Tile7, $B/Tile8,
			 $B/Tile9, $B/Tile10, $B/Tile11, $B/Tile12,
			 $B/Tile13, $B/Tile14, $B/Tile15, $B/Tile16]
	tilesC = [$C/Tile1, $C/Tile2, $C/Tile3, $C/Tile4,
			 $C/Tile5, $C/Tile6, $C/Tile7, $C/Tile8,
			 $C/Tile9, $C/Tile10, $C/Tile11, $C/Tile12,
			 $C/Tile13, $C/Tile14, $C/Tile15, $C/Tile16]
	solvedA = [$Null, $Null, $Null, $Null,
			   $Null, $Null, $Null, $Null,
			   $Null, $Null, $Null, $Null,
			   $Null, $Null, $Null, $Null]
	solvedB = [$Null, $Null, $Null, $Null,
			   $Null, $Null, $Null, $Null,
			   $Null, $Null, $Null, $Null,
			   $Null, $Null, $Null, $Null]
	solvedC = [$Null, $Null, $Null, $Null,
			   $Null, $Null, $Null, $Null,
			   $Null, $Null, $Null, $Null,
			   $Null, $Null, $Null, $Null]
	choose_tiles(tilesA, solvedA, numAtiles)
	choose_tiles(tilesB, solvedB, numBtiles)
	choose_tiles(tilesC, solvedC, numCtiles)
	emptytileA = tilesA[solvedA.find($Null)]
	emptytileA.modulate.a = 0
	emptytileB = tilesB[solvedB.find($Null)]
	emptytileB.modulate.a = 0
	emptytileC = tilesC[solvedC.find($Null)]
	emptytileC.modulate.a = 0
	shuffle_tiles(tilesA, emptytileA)
	shuffle_tiles(tilesB, emptytileB)
	shuffle_tiles(tilesC, emptytileC)

func choose_tiles(tilesset, solvedtiles, num):
	var currtiles = []
	var currindex
	for i in num:
		currindex = tiles.pop_back()
		solvedtiles[currindex] = tilesset[currindex]
		currtiles.append(tilesset[currindex])
	for i in tilesset:
		if solvedtiles == solvedA and !currtiles.has(i):
			i.frame = nullAtile
		elif solvedtiles == solvedB and !currtiles.has(i):
			i.frame = nullBtile
		elif solvedtiles == solvedC and !currtiles.has(i):
			i.frame = nullCtile

func shuffle_tiles(tilesset, emptytile):
	var previous = 99
	var previous_1 = 98
	var previous_2 = 97
	for t in range(0,5000):
		var tile = randi() % numtiles
		if tilesset[tile] != emptytile and tile != previous and tile != previous_1 and tile != previous_2:
			var rows = int(tilesset[tile].position.y / tilesize)
			var cols = int(tilesset[tile].position.x / tilesize)
			check_neighbours(rows,cols,tilesset,emptytile)
			previous_2 = previous_1
			previous_1 = previous
			previous = tile
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if GlobalStats.switchoneflipped:
		$A.visible = true
		$B.visible = false
		$C.visible = false
	elif GlobalStats.switchtwoflipped:
		$A.visible = false
		$B.visible = true
		$C.visible = false
	elif GlobalStats.switchthreeflipped:
		$A.visible = false
		$B.visible = false
		$C.visible = true
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and mouse and !(GlobalStats.puzzleonesolved and GlobalStats.puzzletwosolved and GlobalStats.puzzlethreesolved):
		var mouse_copy = mouse
		#print(mouse.position)
		mouse = false
		mouse_copy.position.x -= self.position.x
		mouse_copy.position.y -= self.position.y
		var rows = int(mouse_copy.position.y / tilesize)
		var cols = int(mouse_copy.position.x / tilesize)
		#print(str(rows) + ", " + str(cols))
		if $A.visible == true:
			check_neighbours(rows,cols,tilesA,emptytileA)
			check_solutions(tilesA, solvedA)
		elif $B.visible == true:
			check_neighbours(rows,cols,tilesB,emptytileB)
			check_solutions(tilesB, solvedB)
		elif $C.visible == true:
			check_neighbours(rows,cols,tilesC,emptytileC)
			check_solutions(tilesC, solvedC)
	if GlobalStats.puzzleonesolved and GlobalStats.puzzletwosolved and GlobalStats.puzzlethreesolved:
		await get_tree().create_timer(1.0).timeout
		$Complete.visible = true

func check_solutions(tilesset, solvedtiles):
	var currindex = 0
	for i in solvedtiles:
		if i != $Null and i != tilesset[currindex]:
			if solvedtiles == solvedA:
				GlobalStats.puzzleonesolved = false
			elif solvedtiles == solvedB:
				GlobalStats.puzzletwosolved = false
			elif solvedtiles == solvedC:
				GlobalStats.puzzlethreesolved = false
			return
		currindex += 1
	if solvedtiles == solvedA:
		GlobalStats.puzzleonesolved = true
	elif solvedtiles == solvedB:
		GlobalStats.puzzletwosolved = true
	elif solvedtiles == solvedC:
		GlobalStats.puzzlethreesolved = true

func check_neighbours(rows, cols, tilesset, emptytile):
	var empty = false
	var done = false
	var pos = rows * numrowcol + cols
	while !empty and !done:
		var new_pos = tilesset[pos].position
		if rows < (numrowcol - 1):
			new_pos.y += tilesize
			empty = find_empty(new_pos,pos,tilesset,emptytile)
			new_pos.y -= tilesize
		if rows > 0:
			new_pos.y -= tilesize
			empty = find_empty(new_pos,pos,tilesset,emptytile)
			new_pos.y += tilesize
		if cols < (numrowcol - 1):
			new_pos.x += tilesize
			empty = find_empty(new_pos,pos,tilesset,emptytile)
			new_pos.x -= tilesize
		if cols > 0:
			new_pos.x -= tilesize
			empty = find_empty(new_pos,pos,tilesset,emptytile)
			new_pos.x += tilesize
		done = true
			
func find_empty(newposition,pos,tilesset,emptytile):
	var new_rows = int(newposition.y / tilesize)
	var new_cols = int(newposition.x / tilesize)
	var new_pos = new_rows * numrowcol + new_cols
	if tilesset[new_pos] == emptytile:
		swap_tiles(pos, new_pos,tilesset)
		return true
	else:
		return false

func swap_tiles(tile_src, tile_dst, tilesset):
	var temp_pos = tilesset[tile_src].position
	tilesset[tile_src].position = tilesset[tile_dst].position
	tilesset[tile_dst].position = temp_pos
	var temp_tile = tilesset[tile_src]
	tilesset[tile_src] = tilesset[tile_dst]
	tilesset[tile_dst] = temp_tile
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		match randi_range(0, 2):
			0:
				Sfx.play_sound("Slide1")
			1:
				Sfx.play_sound("Slide2")
			2:
				Sfx.play_sound("Slide3")
	
func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		mouse = event

func _on_mouse_entered() -> void:
	Cursor.isslider = true

func _on_mouse_exited() -> void:
	Cursor.isslider = false

func _on_complete_visibility_changed() -> void:
	var tween = create_tween()
	tween.tween_property($Complete, "modulate:a", 1, 1.0)
