extends WorldEnvironment


# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
  var environment_color = Color(0.25, 0.15, 0.05) + World.dayness * Color(0.5, 1.0, 0.95) + World.nightness * Color(0.05, 0.0, 0.25)
  environment.background_color = environment_color
  environment.fog_light_color = environment_color
  environment.ambient_light_color = environment_color
  environment.fog_light_energy = World.dayness
