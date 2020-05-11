extends Area2D

onready var view_size: Vector2 = get_viewport_rect().size # extents go from center to edge
onready var width: float = view_size.x * 3
onready var height: float = view_size.y * 3

#onready var global_position = get_global_transform().origin

func _ready():
#	print("view is: " + String(view_size))
#	print("window is: " + String(OS.get_window_size()))

	#$Shape.shape.extents = Vector2(10 , 20)
	$Shape.shape.extents = Vector2(width / 2, height / 2) #active area is 3 x 3 of view

func _process(_delta):

	var red_rect = get_top_full()
	$ColorRect.rect_global_position = red_rect.position
	$ColorRect.rect_size = red_rect.size
#	$ColorRect.rect_global_position = get_right_bumper().position
#	$ColorRect.rect_size = get_right_bumper().size
#	global_position = get_global_transform().origin

	#print(global_position)

func get_all() -> Rect2:
	var top_left_position = Vector2(
			global_position.x - width / 2,
			global_position.y - height / 2 )
	var size = Vector2(
			width,
			height)
	return Rect2(top_left_position, size)
	
func get_top_half() -> Rect2:
	var top_left_position = Vector2(
			global_position.x - view_size.x,
			global_position.y - view_size.y )
	var top_view_size = Vector2(
			view_size.x * 2,
			view_size.y )
	return Rect2(top_left_position, top_view_size)

func get_top_full() -> Rect2:
	var top_left_position = Vector2(
			global_position.x - view_size.x * 1.5,
			global_position.y - view_size.y - height )
	var top_view_size = Vector2(
			view_size.x * 3,
			view_size.y * 3)
	return Rect2(top_left_position, top_view_size)
	
func get_top_bumper() -> Rect2:
	var top_left_position = Vector2(
			global_position.x - view_size.x,
			global_position.y - view_size.y)
	var bumper_size = Vector2(
			view_size.x * 2,
			view_size.y / 2 )
	return Rect2(top_left_position, bumper_size)
	
func get_bottom_bumper() -> Rect2:
	var top_left_position = Vector2(
			global_position.x - view_size.x,
			global_position.y + view_size.y / 2)
	var bumper_size = Vector2(
			view_size.x * 2,
			view_size.y / 2 )
	return Rect2(top_left_position, bumper_size)

func get_left_bumper() -> Rect2:
	var top_left_position = Vector2(
			global_position.x - view_size.x,
			global_position.y - view_size.y)
	var bumper_size = Vector2(
			view_size.x / 2,
			view_size.y * 2 )
	return Rect2(top_left_position, bumper_size)

func get_right_bumper() -> Rect2:
	var top_left_position = Vector2(
			global_position.x + width / 6,
			global_position.y - height / 2)
	var bumper_size = Vector2(
			width / 3,
			height )
	return Rect2(top_left_position, bumper_size)

func get_camera_rect(camera):
	var rect = {"x": 0, "y": 0, "w": 0, "h": 0}
	var cameraPos = camera.get_camera_screen_center()
	var viewportRect = get_viewport_rect().size / 2 
	rect.x = cameraPos.x - viewportRect.x
	rect.y = cameraPos.y - viewportRect.y
	rect.w = viewportRect.x * 2
	rect.h = viewportRect.y * 2
	return rect
