extends CharacterPersistentState

class_name PlayerPersistentState

@onready var collision: CollisionShape3D = $BodyCollision
@onready var body: Node3D = $FullBody/Body
@onready var head_base: Node3D = $FullBody/Body/TorsoMesh/Neck/BaseOfHead
@onready var head_mesh: MeshInstance3D = $FullBody/Body/TorsoMesh/Neck/BaseOfHead/Head
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var camera: Node3D = $FullBody/Camera
@onready var camera3d: Camera3D = $FullBody/Camera/Camera3D
@onready var camera_occlusion_raycast: RayCast3D = $FullBody/Camera/RayCast3D

#state
var state
var state_factory
var state_elected: bool

#physics/motion
var inertia = 0
var run_speed = 0
var walk_speed = 0
var sneak_speed = 0
var midair_correction_speed = 0
var jump_velocity = 0
var input_direction: Vector2 = Vector2(0,0)
var direction: Vector2 = Vector2(0,0)

#camera
var camera_target_position: Vector3

func _ready():
  Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
  camera_target_position = camera3d.position
  camera_occlusion_raycast.add_exception(self)
  change_state("idle")

func _unhandled_input(event):
  #handle camera rotation

  if event is InputEventMouseMotion:
    camera.rotation.y -= event.relative.x/80
    camera.rotation.x = clampf(camera.rotation.x - event.relative.y/80, deg_to_rad(-60), deg_to_rad(60))
    head_base.rotation.x = camera.rotation.x / 2
  if camera.rotation.y - body.rotation.y > 2 * PI:
    camera.rotation.y -= 2 * PI
  elif camera.rotation.y - body.rotation.y < -2 * PI:
    camera.rotation.y += 2 * PI

func _process(_delta):

  #allow a new state to be elected
  state_elected = false

  #player always enters fall state if not on the ground
  if !is_on_floor() and not velocity.y > 0:
    velocity.y -= Physics.gravity
    state.do_state("fall")

  #handle player inputs
  handle_movement()
  handle_camera_zoom()

  #player always idles if no state elected
  state.do_state("idle")

func _physics_process(_delta):
  move_and_slide()

func handle_movement():
  #determine which states to attempt to transition to, according to player input

  #determine if player is trying to move f/b/l/r
  input_direction = Input.get_vector("mv_left", "mv_right", "mv_forward", "mv_backward")
  direction = input_direction.rotated(-camera.rotation.y)

  #handle jump
  if Input.is_action_just_pressed("jump") or state is JumpState:
    state.do_state("jump")

  #handle crouch/sneak
  if Input.is_action_pressed("crouch"):
    if input_direction:
      state.do_state("sneak")
    state.do_state("crouch")

  #handle plain movement
  if input_direction:
    if Input.is_action_pressed("sprint") and input_direction.y < 0:
      state.do_state("run")
    state.do_state("walk")

func change_state(new_state_name):
  #set the new state by name

  #remove any previous state
  if state != null:
    state.queue_free()

  #instantiate target state by looking up its name in the state factory
  state = state_factory.get_state(new_state_name).new()
  print(new_state_name)

  #set up the instantiated state so it can call THIS FUNCTION to change state,
  #play the appropriate player animation,
  #and modify the player's variables
  state.setup(func (state_string): change_state(state_string), self)
  state.name = "current_state"
  add_child(state)

func face_movement_direction():
  #point the body towards the input/movement direction

  if input_direction.y > 0:     #point the body opposite of the movement direction if moving backward (to "backpedal")
    body.rotation.y = clampf(camera.rotation.y-Vector2(0,-1).angle_to(-input_direction), body.rotation.y - 0.1, body.rotation.y + 0.1)
  else:                         #point the body in the direction of the movement if moving forward
    body.rotation.y = clampf(camera.rotation.y-Vector2(0,-1).angle_to(input_direction), body.rotation.y - 0.1, body.rotation.y + 0.1)
  head_base.rotation.y = clampf((camera.rotation.y - body.rotation.y) / 2.0, head_base.rotation.y - 0.05, head_base.rotation.y + 0.05)

func face_camera_direction():
  #point the body loosely towards the camera direction

  if camera3d.position.z < 0.4:     #force body to rotate somewhat with the player
    body.rotation.y = clampf(body.rotation.y, camera.rotation.y - PI/4, camera.rotation.y + PI/4)

func handle_camera_zoom():
  #set camera position based on zoom

  #set initial camera target position based on input
  var camera_zoom_input = float(
    int(Input.is_action_just_released("camera_zoom_out")) \
    -int(Input.is_action_just_released("camera_zoom_in"))
  ) / 5.0
  if camera_zoom_input:
    camera_target_position.z = clampf(camera3d.position.z + camera_zoom_input, -0.20, 2.5)

  #handle switching 1st/3rd person
  if camera_target_position.z < 0.4:      #within 1st person threshold
    if Input.is_action_just_released("camera_zoom_in"):
      camera_target_position = Vector3(0.0, 0.2, -0.1)
      var material: Material = head_mesh.get_active_material(0)
      material.albedo_color.a = 0.0
    elif Input.is_action_just_released("camera_zoom_out"):
      var material: Material = head_mesh.get_active_material(0)
      material.albedo_color.a = 1.0
      camera_target_position.z = 0.4
  else:                                   #within 3rd person threshold
    camera_target_position.x = 0.365
    camera_target_position.y = clampf((0.5 + camera3d.position.y + camera_zoom_input)/10, 0.3, 3.5)

  #handle camera occluders
  camera_occlusion_raycast.target_position = camera_target_position
  if camera_occlusion_raycast.get_collider() != null:
    camera3d.global_position = camera_occlusion_raycast.get_collision_point()
    camera3d.position *= 0.75
  else:
    camera3d.position = camera_target_position
