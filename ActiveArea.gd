extends Area2D

onready var half_size: Vector2 = get_viewport_rect().size # extents go from center to edge
#onready var global_position = get_global_transform().origin

func _ready():
	print("view is: " + String(half_size))
	print("window is: " + String(OS.get_window_size()))
	#$Shape.shape.extents = Vector2(10 , 20)
	$Shape.shape.extents = Vector2(half_size.x , half_size.y)
func _process(_delta):
	#global_position = get_global_transform().origin
	pass
	#print(global_position)

func get_all() -> Rect2:
	var top_left_position = Vector2(
			global_position.x - half_size.x,
			global_position.y - half_size.y )
	var size = Vector2(
			half_size.x * 2,
			half_size.y * 2)
	return Rect2(top_left_position, size)
	
func get_top_half() -> Rect2:
	var top_left_position = Vector2(
			global_position.x - half_size.x,
			global_position.y - half_size.y )
	var top_half_size = Vector2(
			half_size.x * 2,
			half_size.y )
	return Rect2(top_left_position, top_half_size)
	
func get_top_bumper() -> Rect2:
	var top_left_position = Vector2(
			global_position.x - half_size.x,
			global_position.y - half_size.y)
	var bumper_size = Vector2(
			half_size.x * 2,
			half_size.y / 2 )
	return Rect2(top_left_position, bumper_size)
	
func get_bottom_bumper() -> Rect2:
	var top_left_position = Vector2(
			global_position.x - half_size.x,
			global_position.y + half_size.y / 2)
	var bumper_size = Vector2(
			half_size.x * 2,
			half_size.y / 2 )
	return Rect2(top_left_position, bumper_size)


func get_left_bumper() -> Rect2:
	var top_left_position = Vector2(
			global_position.x - half_size.x,
			global_position.y - half_size.y)
	var bumper_size = Vector2(
			half_size.x / 2,
			half_size.y * 2 )
	return Rect2(top_left_position, bumper_size)

func get_right_bumper() -> Rect2:
	var top_left_position = Vector2(
			global_position.x + half_size.x / 2,
			global_position.y - half_size.y)
	var bumper_size = Vector2(
			half_size.x / 2,
			half_size.y * 2 )
	return Rect2(top_left_position, bumper_size)
