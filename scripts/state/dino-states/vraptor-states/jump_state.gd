extends State

class_name JumpState
var classname = "JumpState"

func _ready():
  persistent_state.animation.speed_scale = 1
  persistent_state.animation.play("jump")
  persistent_state.velocity.y += persistent_state.jump_velocity
  jump()

func jump():
  if persistent_state.direction:
    persistent_state.velocity.x = clampf(
      persistent_state.velocity.x + persistent_state.direction.x * persistent_state.midair_correction_speed,
      -persistent_state.run_speed,
      persistent_state.run_speed
    )
    persistent_state.velocity.z = clampf(
      persistent_state.velocity.z + persistent_state.direction.y * persistent_state.midair_correction_speed,
      -persistent_state.run_speed,
      persistent_state.run_speed
    )
  else:
    persistent_state.velocity.x /= 1.2
    persistent_state.velocity.z /= 1.2
  persistent_state.velocity.y -= Physics.gravity
  if not persistent_state.velocity.y > 0:
    fall()
  persistent_state.face_movement_direction()

func fall():
  change_state.call("fall")
