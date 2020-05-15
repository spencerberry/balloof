extends Area2D

class_name Balloon, "res://balloon.png"

## screen knowledge for input
onready var dpi_divisor = OS.get_window_size() / get_viewport_rect().size
onready var screen_third_x = OS.get_window_size().x / dpi_divisor.x / 3
onready var screen_width = OS.get_window_size().x / dpi_divisor.x
onready var screen_center_x = OS.get_window_size().x / 2

var press = false # is the finger on the screen?

# Draw data
onready var sprite = $Sprite
onready var powerMeter = $Sprite/RectOfPower

var steer_tracker = 0 # track how much we've steered for animation purposes
var steer_flip = 18 # we flip to the next frame when tracker reaches this

# Speed data

const RAMP_DURATION = 30 # How many frames does ramp last
var ramp_count = RAMP_DURATION # Counter to track these frames
const RAMP_POWER = .1 # Added to thrust while in ramp

const BOOST_DURATION = 20 # How many frames a boost lasts
var boost_count = BOOST_DURATION # Counter to track boost frames
const BOOST_POWER = .44 # Added to thrust while in boost

const CRUISE_MAX = 12 # speed while held down

const DECAY = .2

var thrust: float = 0
var speed:float = 0

#debug
var state: String
# refactor above this line

#not implemented yet
var steer = 0
var press_duration = 0
var direction:float = 0

var alive = true # for now
const GRAVITY = 4
const MAX_FALL = -4
const GROUND = -40


##To retire? 
#const BOOST_MAX = 16
#var x_velocity = 0
#var y_velocity = 0
#var model_name = OS.get_model_name()
#const MAX_STEER = 6

func _ready():
	#print(get_viewport_rect())
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

	var delta_frames = delta * 60
#	var simple_accel = (Input.get_accelerometer() * 10).round()/10
#	var simple_gyro = (Input.get_gyroscope()).round()
#	$_DEBUG.text = String(simple_accel)
#	$_DEBUG2.text = String(simple_gyro)
	if alive:
		if press and ramp_count > 0:
			ramp(delta_frames)
		elif press and boost_count > 0:
			boost(delta_frames)
		elif press:
			cruise(delta_frames)
		else:
			decay(delta_frames)

		
		set_position(get_position() + Vector2(0, - thrust))
	
#
#		var steer_decay = delta if self.position.y != GROUND else delta * 10 #ground friction
#
#		if press:
#
#			speed = approach(speed, MAX_VELOCITY, POWER * delta)
#			press_duration += delta * 60
#
#			if press_duration < BOOST_DURATION:
#
#				y_velocity = min(y_velocity + BOOST_POWER * delta, BOOST_MAX)
#			else:
#				y_velocity = min(y_velocity + POWER * delta, MAX_VELOCITY)
#
#			if self.position.y == GROUND:
#				x_velocity = approach_zero(x_velocity, steer_decay)
#			else:
#				x_velocity = approach(x_velocity, steer * MAX_STEER, steer * delta * 10)
#
#		else:
#			speed = approach(speed, MAX_FALL, GRAVITY * delta )
#			#if press_duration !=0: $_DEBUG.text = String(press_duration)
#			press_duration = 0
#			y_velocity = max(y_velocity, MAX_FALL)
#
#			x_velocity = approach_zero(x_velocity, steer_decay)
#
#		#write an approach and an approach_zero method in a tool file
#
#		steer_tracker += x_velocity
#		var last_frame = sprite.hframes - 1
#		while steer_tracker > steer_flip:
#			steer_tracker -= steer_flip
#			sprite.frame =  sprite.frame + 1 if sprite.frame < last_frame else 0
#		while steer_tracker < -steer_flip:
#			steer_tracker += steer_flip
#			sprite.frame = sprite.frame - 1 if sprite.frame > 0 else last_frame
#
#		y_velocity -= GRAVITY * delta
#		position -= Vector2(x_velocity, y_velocity)
#		position.y = min(GROUND, position.y)
		pass
	#
	powerMeter.rect_size.y = abs(speed) * 10
	if speed > 0: powerMeter.set_frame_color(Color.bisque)
	else: powerMeter.set_frame_color(Color.darkorchid)
	
	$_DEBUG.text = state
	$_DEBUG2.text = String(thrust)
	
func ramp(delta_frames):
	thrust += RAMP_POWER
	ramp_count -= delta_frames
	state = "ramp"
	
func boost(delta_frames):
	thrust += BOOST_POWER
	boost_count -= delta_frames
	state = "boost"
	
func cruise(delta_frames):
	thrust = approach(thrust, CRUISE_MAX, DECAY)
	state = "cruise"
	
func decay(delta_frames):
	thrust = approach_zero(thrust, DECAY)
	state = "decay"
	boost_count = BOOST_DURATION
	if thrust == 0:
		ramp_count = RAMP_DURATION
	
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
