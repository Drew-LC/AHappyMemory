extends Control

var CursorDefault = load("res://GFX/UI/Cursor1.png")
var CursorHighlightDefault = load("res://GFX/UI/Cursor3.png")
var ishighlight : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_custom_mouse_cursor(CursorDefault, 0, Vector2(3, 3))

func _process(delta: float) -> void:
	if !ishighlight:
		Input.set_custom_mouse_cursor(CursorDefault, 0, Vector2(3, 3))
	else:
		Input.set_custom_mouse_cursor(CursorHighlightDefault, 0, Vector2(3, 3))
