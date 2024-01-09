extends Node3D

@onready var sun: DirectionalLight3D = $Sun

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
  sun.visible = bool(World.dayness)
  sun.rotation.x = World.sun_rotation
  sun.light_energy = 2*sqrt(World.dayness)
