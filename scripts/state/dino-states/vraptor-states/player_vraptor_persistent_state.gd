extends PlayerPersistentState

class_name PlayerVraptorPersistentState

#physics/motion
func _ready():
  inertia = 0.7
  run_speed = 12
  walk_speed = 8
  sneak_speed = 4
  midair_correction_speed = 0.2
  jump_velocity = 16
  state_factory = VraptorStateFactory.new()
  super._ready()
