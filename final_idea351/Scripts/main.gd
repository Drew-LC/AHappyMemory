extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.25).timeout
	var tween = create_tween()
	tween.tween_property($Black, "modulate:a", 0, 1.0)
	await get_tree().create_timer(3.0).timeout
	tween = create_tween()
	tween.tween_property($SplashBG, "modulate:a", 0, 0.75)
	await get_tree().create_timer(1.0).timeout
	$Black.visible = false
	$SplashBG.visible = false
	Bgm.play()
	Bgm.get_stream_playback().switch_to_clip_by_name("Main")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_next_button_pressed() -> void:
	$Opening.visible = false
	Sfx.play_sound("Whoosh")

func _on_cursor_mouse_en() -> void:
	Cursor.ishighlight = true

func _on_cursor_mouse_ex() -> void:
	Cursor.ishighlight = false

func _on_switch_1_toggled(toggled_on: bool) -> void:
	if toggled_on:
		GlobalStats.switchoneflipped = true
		Sfx.play_sound("FlipSwitch")
		$Puzzle/Switch1.disabled = true
		$Puzzle/Switch2.button_pressed = false
		$Puzzle/Switch3.button_pressed = false
	else:
		GlobalStats.switchoneflipped = false
		$Puzzle/Switch1.disabled = false

func _on_switch_2_toggled(toggled_on: bool) -> void:
	if toggled_on:
		GlobalStats.switchtwoflipped = true
		Sfx.play_sound("FlipSwitch")
		$Puzzle/Switch2.disabled = true
		$Puzzle/Switch1.button_pressed = false
		$Puzzle/Switch3.button_pressed = false
	else:
		GlobalStats.switchtwoflipped = false
		$Puzzle/Switch2.disabled = false

func _on_switch_3_toggled(toggled_on: bool) -> void:
	if toggled_on:
		GlobalStats.switchthreeflipped = true
		Sfx.play_sound("FlipSwitch")
		$Puzzle/Switch3.disabled = true
		$Puzzle/Switch1.button_pressed = false
		$Puzzle/Switch2.button_pressed = false
	else:
		GlobalStats.switchthreeflipped = false
		$Puzzle/Switch3.disabled = false

func _on_switch_1_mouse_entered() -> void:
	if !$Puzzle/Switch1.disabled:
		Cursor.ishighlight = true

func _on_switch_2_mouse_entered() -> void:
	if !$Puzzle/Switch2.disabled:
		Cursor.ishighlight = true

func _on_switch_3_mouse_entered() -> void:
	if !$Puzzle/Switch3.disabled:
		Cursor.ishighlight = true
