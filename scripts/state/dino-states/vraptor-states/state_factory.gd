class_name StateFactory

var states

func _init():
  states = {
    "idle": IdleState,
    "walk": WalkState,
    "run": RunState,
    "fall": FallState,
    "jump": JumpState,
    "crouch": CrouchState,
    "sneak": SneakState
  }

func get_state(state_name):
  if states.has(state_name):
    return states.get(state_name)
  else:
    printerr("No state ", state_name, " in state factory!")
