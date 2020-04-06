extends Area2D

var speed = 200
var direction:int
var window_size = OS.get_window_size()
var offscreen = false

var target = null

func _ready() -> void:

	position.y = -500
	var coin_toss = randi() % 2 == 0
	direction = 1 if coin_toss else -1

func _physics_process(delta) -> void:
	position += Vector2(direction * speed * delta, 0)

func _process(_delta):
	$Sprite.flip_h = direction < 0

func init(origin):
	position.x = origin.x
	position.y = origin.y
	direction = 1 if origin.x > 0 else -1

func direction_to_target():
	return sign(target.position.x - position.x)

func _on_found(balloon): # assumes signal only detects balloons
	if balloon.name == 'Balloon':
		target = balloon
	else:
		print("Bird saw something not named Balloon")

func _on_screen_exited(): 
	if target and target.position.y > position.y: #offscreen but above balloon
		direction = - direction_to_target()
		position.y += 40
		position.x -= direction * window_size.x * 1.5
	
	else:
		queue_free()
	#offscreen = true
	
	#position.x -= direction * window_size.x * 1.5

func _on_screen_entered():
	#offscreen = false
	pass
	
func _on_time_to_turn():
	direction *= -1
	$Vision/Shape.position.x *= -1
