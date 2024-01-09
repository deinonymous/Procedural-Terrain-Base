extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
  body_entered.connect(func (body):
    if body is PlayerPersistentState:
      body.run_speed /= 2
      body.walk_speed /= 2
      body.sneak_speed /= 2
      body.jump_velocity /= 4
  )
  body_exited.connect(func (body):
    if body is PlayerPersistentState:
      body.run_speed *= 2
      body.walk_speed *= 2
      body.sneak_speed *= 2
      body.jump_velocity *= 4
  )


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
  pass
