extends State

class_name SneakState
var classname = "SneakState"

func _ready():
  persistent_state.animation.play("sneak")
  sneak()

func sneak():
  persistent_state.animation.speed_scale = (-1 if persistent_state.direction.y < 0 else 1) * persistent_state.velocity.length() / 3
  persistent_state.velocity.x = persistent_state.direction.x * persistent_state.sneak_speed
  persistent_state.velocity.z = persistent_state.direction.y * persistent_state.sneak_speed
  persistent_state.face_movement_direction()

func crouch():
  change_state.call("crouch")

func walk():
  change_state.call("walk")

func fall():
  change_state.call("fall")

func idle():
  change_state.call("idle")
