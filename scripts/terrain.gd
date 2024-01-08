extends Node3D

@onready var terrain_coll: CollisionShape3D = $CollisionShape3D
@onready var terrain_mesh: MeshInstance3D = $MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready():
  var terrain_shape: Shape3D = terrain_coll.shape
  var terrain_f32_arr: PackedFloat32Array = terrain_shape.map_data
  for i in terrain_f32_arr.size():
    if i == 1:
      terrain_f32_arr[i] = randf() + 1
    elif i < terrain_shape.map_depth or i % terrain_shape.map_depth == 0:
      var previous = 0.006 + randf() * terrain_f32_arr[i-1] * 2
      terrain_f32_arr[i] = clampf(previous, previous-3*sqrt(previous), previous+sqrt(previous))
    else:
      var previous = 0.006 + randf() * (terrain_f32_arr[i-1] + terrain_f32_arr[i-int(terrain_shape.map_depth)])
      terrain_f32_arr[i] = clampf(previous, previous-3*sqrt(previous), 1.4*sqrt(previous))
  terrain_shape.map_data = terrain_f32_arr
  #var terrain_vec3_arr: PackedVector3Array = []
  var st = SurfaceTool.new()
  st.begin(Mesh.PRIMITIVE_TRIANGLES)
  for i in terrain_f32_arr.size():
    var row = floor((i) / terrain_shape.map_depth)
    var next_row = row + 1
    var col = (i) - row * terrain_shape.map_depth
    var next_col = col + 1
    #terrain_vec3_arr.push_back(Vector3(row, terrain_f32_arr[i],col))
    if i+int(terrain_shape.map_depth)+1 < terrain_f32_arr.size():
      st.set_color(Color(0.1, 0.2, 0.15))
      st.add_vertex(Vector3(row, terrain_f32_arr[i],col))
      st.set_color(Color(0.1, 0.2, 0.15))
      st.add_vertex(Vector3(next_row, terrain_f32_arr[i+int(terrain_shape.map_depth)],col))
      st.set_color(Color(0.1, 0.2, 0.15))
      st.add_vertex(Vector3(row, terrain_f32_arr[i+1],next_col))
      st.set_color(Color(0.1, 0.2, 0.15))
      st.add_vertex(Vector3(next_row, terrain_f32_arr[i+int(terrain_shape.map_depth)],col))
      st.set_color(Color(0.1, 0.2, 0.15))
      st.add_vertex(Vector3(next_row, terrain_f32_arr[i+int(terrain_shape.map_depth)+1],next_col))
      st.set_color(Color(0.1, 0.2, 0.15))
      st.add_vertex(Vector3(row, terrain_f32_arr[i+1],next_col))
    var terrain_obj = null
    var terrain_obj_scale = 0.0
    var terrain_obj_rng = randf()
    if terrain_f32_arr[i] < 0.5 and terrain_obj_rng > 0.8:
      terrain_obj = preload("res://scenes/tree.tscn")
      terrain_obj_scale = randf() + 0.25
    elif terrain_f32_arr[i] < 0.4 and terrain_obj_rng > 0.6:
      terrain_obj = preload("res://scenes/bush.tscn")
      terrain_obj_scale = (randf() + 0.25) / 3
    elif terrain_obj_rng > 0.5 and terrain_f32_arr[i] < 0.1:
      terrain_obj = preload("res://scenes/lake.tscn")
      terrain_obj_scale = (randf() + 0.75) / 3
    elif terrain_f32_arr[i] < 0.3:
      terrain_obj = preload("res://scenes/grass.tscn")
      terrain_obj_scale = (randf()/4 + 0.5)
    if terrain_obj:
      var terrain_obj_instance: TerrainObject = terrain_obj.instantiate()
      terrain_mesh.add_child(terrain_obj_instance)
      terrain_obj_instance.position = Vector3(row, terrain_f32_arr[i], col)
      terrain_obj_instance.scale = Vector3(terrain_obj_scale, terrain_obj_scale, terrain_obj_scale)

  #terrain_vec3_arr.push_back(Vector3(terrain_f32_arr.size()/2, 0, terrain_f32_arr.size()/2))
  #var terrain_arr_mesh = ArrayMesh.new()
  #var arrays = []
  #arrays.resize(Mesh.ARRAY_MAX)
  #arrays[Mesh.ARRAY_VERTEX] = terrain_vec3_arr
  #terrain_arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
  st.generate_normals()
  terrain_mesh.mesh = st.commit()
  terrain_mesh.position = Vector3(-terrain_shape.map_depth/2 + 0.5, 0, -terrain_shape.map_depth/2 + 0.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
  pass
