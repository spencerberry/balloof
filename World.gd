extends Node2D

var game_over = false
var score = 0

var Bird = preload("res://Bird.tscn")
var bird_count = 12
var birds = []

var Cloud = preload("res://Cloud.tscn")
var cloud_count = 40
var clouds = []


var window_size = OS.get_window_size()
var active_area = Rect2()

var active_range_x = window_size.x
var active_range_y = window_size.y

var rng = RandomNumberGenerator.new()

func _ready():
	$HUD/Label.text  = String(window_size)
	
	active_area.size.x = active_range_x * 2
	active_area.size.y = active_range_y * 2
	
	rng.randomize()
	update_active_area()
	
	for _i in range(cloud_count):
		var x = rng.randf_range(active_area.position.x, active_area.position.x + active_area.size.x)
		var y = rng.randf_range(active_area.position.y - 1200, active_area.position.y - active_area.size.y)
		var starting_position = Vector2(x, y)

		create_cloud(starting_position)
	for _i in range(bird_count): create_bird()

func _physics_process(_delta):
	pass
	
func _process(_delta):
#TO PLAY DEATH ANIMATION?
	if not $Balloon.alive:
		game_over = true
		
	if game_over:
		print('game over')
		get_tree().set_pause(true)
		$HUD/Label.text = " Game Over \n you flew " + String(score) + " high"
	else:
#GAME LOOP
		update_active_area()
		var balloon_x = $Balloon.position.x
		var balloon_y = $Balloon.position.y
		if score > balloon_y:
			score = int(balloon_y)

#BIRDS
		for bird in birds:
			var bird_x = bird.get_position().x
			var bird_y = bird.get_position().y
			
			if bird.position.y > balloon_y + active_range_y:
				bird.set_position(Vector2(bird_x, balloon_y - active_range_y))

#CLOUDS
		for cloud in clouds:
			var cloud_x = cloud.get_position().x
			var cloud_y = cloud.get_position().y #+ rng.randf_range(balloon_y, balloon_y - 200)
			
			if cloud_x < balloon_x - active_range_x:
				cloud.set_position(Vector2(cloud_x + active_range_x * 3, cloud_y))
	
				
			elif cloud_x > balloon_x + active_range_x:
				cloud.set_position(Vector2(cloud_x - active_range_x * 3, cloud_y))
	
	
			elif cloud_y > balloon_y + active_range_y:
				cloud.set_position(Vector2(cloud_x, cloud_y - active_range_y * 2))		
			elif cloud_y < balloon_y - active_range_y:
				cloud.set_position(Vector2(cloud_x, cloud_y + active_range_y * 2 ))
		
		
#GROUND
		$GroundRect.set_position(Vector2(balloon_x - 600, 0))
		#$DEBUG.text = String(active_area)

func create_cloud(position = Vector2(0, -100), _depth = 1):
	var new_cloud = Cloud.instance()
	new_cloud.init(position)
	clouds.append(new_cloud)
	$ParallaxBackground/Mid.add_child(new_cloud)

func create_bird():
	var new_bird = Bird.instance()
	var balloon_x = $Balloon.position.x
	var balloon_y = $Balloon.position.y

	new_bird.init(Vector2(
			rand_range(balloon_x - active_range_x, balloon_x + active_range_x),
			rand_range(balloon_y - active_range_y, balloon_y - active_range_y * 1.5)
			))

	birds.append(new_bird)
	add_child(new_bird)

func update_active_area():
	active_area.position.x = $Balloon.position.x - active_range_x
	active_area.position.y = $Balloon.position.y - active_range_y
	
