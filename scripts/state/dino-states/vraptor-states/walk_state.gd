extends State

class_name WalkState
var classname = "WalkState"

func _ready():
  persistent_state.animation.play("walk")
  walk()

func walk():
  persistent_state.animation.speed_scale = (-1 if persistent_state.input_direction.y > 0 else 1) * persistent_state.velocity.length() / 3
  persistent_state.velocity.x = clampf(
    persistent_state.direction.x * persistent_state.walk_speed,
    persistent_state.velocity.x - (0.1 + abs(persistent_state.direction.x * persistent_state.walk_speed / 10)),
    persistent_state.velocity.x + (0.1 + abs(persistent_state.direction.x * persistent_state.walk_speed / 10))
  )
  persistent_state.velocity.z = clampf(
    persistent_state.direction.y * persistent_state.walk_speed,
    persistent_state.velocity.z - (0.1 + abs(persistent_state.direction.y * persistent_state.walk_speed / 10)),
    persistent_state.velocity.z + (0.1 + abs(persistent_state.direction.y * persistent_state.walk_speed / 10))
  )
  persistent_state.face_movement_direction()

func run():
  change_state.call("run")

func jump():
  change_state.call("jump")

func fall():
  change_state.call("fall")

func idle():
  change_state.call("idle")

func sneak():
  change_state.call("sneak")

func crouch():
  change_state.call("crouch")
