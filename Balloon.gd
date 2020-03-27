extends Area2D

var press = false
var steer = 0
var alive = true

var x_velocity = 0

var y_velocity = 0
var screen_center_x = OS.get_window_size().x / 2
var screen_third_x = OS.get_window_size().x / 3
var model_name = OS.get_model_name()
var dpi_divisor = 1
var tst = "default"

const POWER = 11
const GRAVITY = 3
const MAX_FALL = -9
const MAX_VELOCITY = 14
const MAX_STEER = 6
const GROUND = -40

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
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

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	if model_name.left(6) == "iPhone":
		 dpi_divisor = 3

func _input(event):
	if event is InputEventScreenDrag or (event is InputEventScreenTouch and event.pressed):
		press = true
		#steer = screen_center_x / dpi_divisor - event.position.x # 3 comes from DPI on iPhone Pro - half n half steering
		if event.position.x < screen_third_x / dpi_divisor:
			steer = event.position.x - (screen_third_x / dpi_divisor)

		elif event.position.x > screen_third_x / dpi_divisor * 2:

			steer = event.position.x - (screen_third_x / dpi_divisor * 2)
		else:

			steer = 0
#	elif event is InputEventScreenTouch and event.pressed:
#		press = true
	elif (event is InputEventScreenTouch and not event.pressed):
		press = false

func _process(delta):
	y_velocity -= GRAVITY * delta
	
	var steer_decay = delta if self.position.y != GROUND else delta * 10
	
	if press:
		y_velocity = min(y_velocity + POWER * delta, MAX_VELOCITY)
		
		if self.position.y == GROUND:
			x_velocity = approach_zero(x_velocity, steer_decay)
		else:
			x_velocity = approach(x_velocity, sign(steer) * MAX_STEER, steer * delta / 2)

	else:
		y_velocity = max(y_velocity, MAX_FALL)
		var x_magnitude = abs(x_velocity)
		x_velocity = approach_zero(x_velocity, steer_decay)
		
	#write an approach and an approach_zero method in a tool file

	self.position -= Vector2(x_velocity, y_velocity)
	self.position.y = self.position.y if self.position.y < GROUND else GROUND
#	var collision = move_and_collide(-Vector2(x_velocity, y_velocity))
#
#	if collision and collision.collider.name == "Bird":
#		alive = false
#		print("dead")

	#$_DEBUG.text = String(x_velocity)


func _on_Balloon_area_entered(area):
	alive = false
