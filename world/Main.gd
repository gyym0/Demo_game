extends Node2D

var noise
var map_size = Vector2(60, 40)
var grass_cap = 0.5
var road_caps = Vector2(0.3, 0.05)
var enviroment_caps = Vector3(0.4, 0.3, 0.04)

func _ready():
	randomize()
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 1.0
	noise.period = 12
	noise.persistence = 0.7
	make_grass_map()
	make_background()

	
func make_grass_map():
	for x in map_size.x:
		for y in map_size.y:
			var a = noise.get_noise_2d(x,y)
			if a < grass_cap:
				$YSort/GrassGround.set_cell(x,y,0)
				
	$YSort/GrassGround.update_bitmask_region(Vector2(0.0, 0.0), Vector2(map_size.x, map_size.y))
	
		
func make_background():
	for x in map_size.x:
		for y in map_size.y:
			if $YSort/GrassGround.get_cell(x,y) == -1:
				if $YSort/GrassGround.get_cell(x,y-1) == 0:
					$YSort/GrassWall.set_cell(x,y,0)
				
	$YSort/GrassWall.update_bitmask_region(Vector2(0.0, 0.0), Vector2(map_size.x, map_size.y))
				

