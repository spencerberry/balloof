extends Area2D

var speed = randi() % 200 + 100
var direction:int = -1
var window_size = OS.get_window_size()
var offscreen = false

var target = null

onready var shape = $ShapeToKill.shape

func _ready() -> void:
	pass
	
func _physics_process(delta) -> void:
	position += Vector2(direction * speed * delta, 0)

func _process(_delta):
	
	if target and direction_to_target() != direction and $TimeToTurn.time_left == 0:
		print($TimeToTurn.time_left)
		$TimeToTurn.start()

	$Sprite.flip_h = direction < 0

#func init(origin):
#	position.x = origin.x
#	position.y = origin.y
#	direction = 1 if origin.x > 0 else -1

func direction_to_target():
	return sign(target.position.x - position.x)

func _on_found(balloon): # assumes signal only detects balloons
	if balloon.name == 'Balloon':
		target = balloon
	else:
		print("Bird saw something not named Balloon")

func _on_screen_exited(): 
#	if target and target.position.y > position.y: #offscreen but above balloon
#		direction = direction_to_target()
#		#position.y += 40
#		#position.x -= direction * window_size.x * 1.5
	pass
func _on_screen_entered():
	#offscreen = false
	pass
	
func _on_time_to_turn():
	direction = direction_to_target()


func move_within(rectangle: Rect2):
	var new_position = Vector2(
			Global.rng.randi_range(rectangle.position.x, rectangle.position.x + rectangle.size.x - shape.extents.x * 2),
			Global.rng.randi_range(rectangle.position.y, rectangle.position.y + rectangle.size.y - shape.extents.y * 2))
	set_position(new_position)


func _on_area_exited(area):
	move_within(area.get_top_bumper())
	#make sure that bird is only monitoring active_area and we should be good here
	#if position.y > area.position.y + area.size.y:
		#https://a8c.slack.com/archives/C03TY6J1A/p1587679050045000print("bird left bottom")
