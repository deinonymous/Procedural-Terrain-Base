extends Node

var origin
var sun_rotation
var day_length = 60.0*10.0
var time = day_length / 2
var dayness = 0.0
var nightness = 0.0

func _process(delta):
  time += delta
  sun_rotation = 2 * PI * time / day_length
  dayness = clampf(-sin(sun_rotation), 0.0, 1.0)
  nightness = clampf(-sin(sun_rotation), -1.0, 0.0)
