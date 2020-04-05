extends Area2D

onready var viewport_size = get_viewport_rect().size
#onready var global_position = get_global_transform().origin

func _ready():
	print("view is: " + String(viewport_size))
	print("window is: " + String(OS.get_window_size()))

	$Shape.shape.extents = Vector2(viewport_size.x , viewport_size.y)
func _process(delta):
	#global_position = get_global_transform().origin
	pass
	#print(global_position)
	
func get_top_half() -> Rect2:
	var top_left_position = Vector2(
			global_position.x - viewport_size.x,
			global_position.y - viewport_size.y )
	var top_half_size = Vector2(
			viewport_size.x * 2,
			viewport_size.y )
	return Rect2(top_left_position, top_half_size)
	

