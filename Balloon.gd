extends Area2D

class_name Balloon, "res://balloon.png"

var press = false
var steer = 0

var steer_tracker = 0 # track how much we've steered for animation purposes
var steer_flip = 18 # we flip to the next frame when tracker reaches this

var alive = true # for now

var x_velocity = 0
var y_velocity = 0

var screen_center_x = OS.get_window_size().x / 2

var model_name = OS.get_model_name()

onready var dpi_divisor = OS.get_window_size() / get_viewport_rect().size
onready var screen_third_x = OS.get_window_size().x / dpi_divisor.x / 3
onready var screen_width = OS.get_window_size().x / dpi_divisor.x

onready var sprite = $Sprite
var tst = "default"

const POWER = 9
const GRAVITY = 5
const MAX_FALL = -4
const MAX_VELOCITY = 6
const MAX_STEER = 6
const GROUND = -40

func _ready():
	print(get_viewport_rect())
	randomize()
#	if model_name.left(6) == "iPhone":
#		 dpi_divisor = 3

func _input(event):
	if event is InputEventScreenDrag or (event is InputEventScreenTouch and event.pressed):
		press = true
		var screen_two_thirds = screen_third_x * 2
		
		#steer = screen_center_x / dpi_divisor - event.position.x # 3 comes from DPI on iPhone Pro - half n half steering
		
		if event.position.x < screen_third_x: #left third

			var distance_to_steer = - (screen_third_x - event.position.x) / screen_third_x # between -1 and 0
			steer = distance_to_steer

		elif event.position.x > screen_two_thirds: #right third
			
			#var distance_to_steer = event.position.x - (screen_third_x / dpi_divisor.x * 2)
			var distance_to_steer = (event.position.x - screen_two_thirds) / (screen_width - screen_two_thirds)
			steer = distance_to_steer
		else:
			steer = 0
		


	elif (event is InputEventScreenTouch and not event.pressed):
		press = false


	
func _process(delta):
	var simple_accel = (Input.get_accelerometer() * 10).round()/10
	var simple_gyro = (Input.get_gyroscope()).round()
	$_DEBUG.text = String(simple_accel)
	$_DEBUG2.text = String(simple_gyro)
	if alive:
		y_velocity -= GRAVITY * delta
		
		var steer_decay = delta if self.position.y != GROUND else delta * 10 #ground friction
		
		if press:
			y_velocity = min(y_velocity + POWER * delta, MAX_VELOCITY)
			
			if self.position.y == GROUND:
				x_velocity = approach_zero(x_velocity, steer_decay)
			else:
				x_velocity = approach(x_velocity, steer * MAX_STEER, steer * delta * 10)
	
		else:
			y_velocity = max(y_velocity, MAX_FALL)
	
			x_velocity = approach_zero(x_velocity, steer_decay)
			
		#write an approach and an approach_zero method in a tool file
		steer_tracker += x_velocity
		var last_frame = sprite.hframes - 1
		while steer_tracker > steer_flip:
			steer_tracker -= steer_flip
			sprite.frame =  sprite.frame + 1 if sprite.frame < last_frame else 0
		while steer_tracker < -steer_flip:
			steer_tracker += steer_flip
			sprite.frame = sprite.frame - 1 if sprite.frame > 0 else last_frame
	
		
		
		position -= Vector2(x_velocity, y_velocity)
		position.y = min(GROUND, position.y)
	else:
		pass
	

func _on_Balloon_area_entered(_area):
	alive = false
#UTILITY

func approach(start, end, step = 1):
	#if step <= 0: return ("approach step shouldnt be zero or negative")
	step = abs(step)
	if start < end:
		return start + step if start + step < end else end
	elif start > end:
		return start - step if start - step > end else end
	else:
		return start
		
func approach_zero(start, step = 1):
	return approach(start, 0, step)
