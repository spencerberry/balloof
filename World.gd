extends Node2D

var game_over = false
var score = 0

onready var active_area = $Balloon/Camera2D/ActiveArea/Shape.shape

var Bird = preload("res://Bird.tscn")
export(int) var bird_count = 12
var birds = []

var Cloud = preload("res://Cloud.tscn")
var cloud_count = 40
var clouds = []

var rng = RandomNumberGenerator.new()

func _ready():
	#screen_metrics()
	#$HUD/Label.text  = String(window_size)
	rng.randomize()
	#create_cloud()
	
#	for _i in range(cloud_count):
#		var x = rng.randf_range(active_area.position.x - active_area.extents.x, active_area.position.x + active_area.extents.x)
#		var y = rng.randf_range(active_area.position.y - 1200, active_area.position.y - active_area.size.y)
#		var starting_position = Vector2(x, y)

#		create_cloud(starting_position)

	create_bird()

func _process(_delta):
	
	if Input.is_action_just_pressed("ui_accept"):
		$Balloon/Camera2D.zoom = Vector2(1,1) if $Balloon/Camera2D.zoom.x !=1.0 else Vector2(3,3)
		print($Balloon/Camera2D.zoom)
		
#TO PLAY DEATH ANIMATION?
	if not $Balloon.alive:
		game_over = true
		
	if game_over:
		print('game over')
		get_tree().set_pause(true)
		$HUD/Label.text = " Game Over \n you flew " + String(score) + " high"
	else:
#GAME LOOP
		var balloon_x = $Balloon.position.x
		var balloon_y = $Balloon.position.y
		if score < abs(balloon_y):
			score = abs(int(balloon_y))

#BIRDS
		for bird in birds:
			var bird_x = bird.get_position().x
			var bird_y = bird.get_position().y
			
#			if bird.position.y > balloon_y + active_range_y:
#				bird.set_position(Vector2(bird_x, balloon_y - active_range_y))

#CLOUDS
		for cloud in clouds:
			var cloud_x = cloud.get_position().x
			var cloud_y = cloud.get_position().y #+ rng.randf_range(balloon_y, balloon_y - 200)

#			if cloud_x < balloon_x - active_range_x:
#				cloud.set_position(Vector2(cloud_x + active_range_x * 3, cloud_y))
#			elif cloud_x > balloon_x + active_range_x:
#				cloud.set_position(Vector2(cloud_x - active_range_x * 3, cloud_y))
#			elif cloud_y > balloon_y + active_range_y:
#				cloud.set_position(Vector2(cloud_x, cloud_y - active_range_y * 2))		
#			elif cloud_y < balloon_y - active_range_y:
#				cloud.set_position(Vector2(cloud_x, cloud_y + active_range_y * 2 ))

#GROUND
		$GroundRect.set_position(Vector2(balloon_x - 600, 0))
		#$DEBUG.text = String(active_area)

func create_cloud(position = Vector2(0, -500), _depth = 1):

	var new_cloud = Cloud.instance()

	#new_cloud.init(position)
	clouds.append(new_cloud)
	$ParallaxBackground/Mid.add_child(new_cloud)

func create_bird():
	var new_bird = Bird.instance()
	add_child(new_bird)
	
func screen_metrics():
	print("                 [Screen Metrics]")
	print("            Display size: ", OS.get_screen_size())
	print("   Decorated Window size: ", OS.get_real_window_size())
	print("             Window size: ", OS.get_window_size())
	print("             View size: ", get_viewport_rect().size)
	print("        Project Settings: Width=", ProjectSettings.get_setting("display/window/size/width"), " Height=", ProjectSettings.get_setting("display/window/size/height")) 

