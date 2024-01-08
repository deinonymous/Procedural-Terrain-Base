extends State

class_name RunState
var classname = "RunState"

func _ready():
  persistent_state.animation.play("run")
  run()

func run():
  persistent_state.animation.speed_scale = (-1 if persistent_state.input_direction.y > 0 else 1) * persistent_state.velocity.length() / 3
  persistent_state.velocity.x = clampf(
    persistent_state.direction.x * persistent_state.run_speed,
    persistent_state.velocity.x - (0.1 + abs(persistent_state.direction.x * persistent_state.run_speed / 5)),
    persistent_state.velocity.x + (0.1 + abs(persistent_state.direction.x * persistent_state.run_speed / 5))
  )
  persistent_state.velocity.z = clampf(
    persistent_state.direction.y * persistent_state.run_speed,
    persistent_state.velocity.z - (0.1 + abs(persistent_state.direction.y * persistent_state.run_speed / 5)),
    persistent_state.velocity.z + (0.1 + abs(persistent_state.direction.y * persistent_state.run_speed / 5))
  )
  persistent_state.face_movement_direction()


func jump():
  change_state.call("jump")

func fall():
  change_state.call("fall")

func idle():
  change_state.call("idle")

func walk():
  change_state.call("walk")
