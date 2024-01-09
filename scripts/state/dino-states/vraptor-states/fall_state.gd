extends State

class_name FallState
var classname = "FallState"

func _ready():
  persistent_state.animation.speed_scale = 1.0
  persistent_state.animation.play("fall")
  fall()

func fall():
  persistent_state.velocity.y -= Physics.gravity
  persistent_state.face_camera_direction()

func jump():
  if persistent_state.is_on_floor():
    change_state.call("jump")

func walk():
  if persistent_state.is_on_floor():
    change_state.call("walk")

func run():
  if persistent_state.is_on_floor():
    change_state.call("run")

func idle():
  if persistent_state.is_on_floor():
    change_state.call("idle")

func sneak():
  if persistent_state.is_on_floor():
    change_state.call("sneak")

func crouch():
  if persistent_state.is_on_floor():
    change_state.call("crouch")
