extends Area2D

onready var viewport_size = get_viewport_rect().size


func _ready():
	print("view is: " + String(viewport_size))
	print("window is: " + String(OS.get_window_size()))

	$Shape.shape.extents = Vector2(viewport_size.x , viewport_size.y)

func _process(delta):
	var gpos = get_global_transform().origin
assss
