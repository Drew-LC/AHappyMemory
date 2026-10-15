extends Control

var CursorDefault = load("res://GFX/UI/Cursor1.png")
var CursorHighlightDefault = load("res://GFX/UI/Cursor2.png")
var CursorHighlightSlider = load("res://GFX/UI/Cursor3.png")
var ishighlight : bool = false
var isslider : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if !GlobalStats.cursordisabled:
		if !ishighlight and !isslider:
			Input.set_custom_mouse_cursor(CursorDefault, 0, Vector2(30, 0))
		elif isslider:
			Input.set_custom_mouse_cursor(CursorHighlightSlider, 0, Vector2(30, 0))
		else:
			Input.set_custom_mouse_cursor(CursorHighlightDefault, 0, Vector2(30, 0))
	else:
		Input.set_custom_mouse_cursor(null)

func _on_button_mouse_entered() -> void:
	isslider = true

func _on_button_mouse_exited() -> void:
	isslider = false
