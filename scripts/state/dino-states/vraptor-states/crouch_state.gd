extends State

class_name CrouchState
var classname = "CrouchState"

func _ready():
  persistent_state.animation.speed_scale = 1
  persistent_state.animation.play("crouch")
  crouch()

func walk():
  change_state.call("walk")

func crouch():
  persistent_state.velocity *= 0.2
  persistent_state.face_camera_direction()

func sneak():
  change_state.call("sneak")

func fall():
  change_state.call("fall")

func idle():
  change_state.call("idle")
