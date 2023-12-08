extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$School.multimesh.set_instance_count(2000)
	for i in range($School.multimesh.instance_count):
		var position = Transform3D()
		var randscale = randf()
		var scale = 0.01 + (randscale - 0.5) * 0.004
		var scalev3 = Vector3(scale, scale, scale)
		position = position.scaled(scalev3)
		var base_pos = Vector3(randf() * 1.5 - .75, randf() * .6 - .3, randf() * 1.5 - .75)
		var maybe_jitter = Vector3(randf() * .05, randf() * .05, randf() * .05)
		position = position.translated(base_pos + maybe_jitter)
		$School.multimesh.set_instance_transform(i, position)
		$School.multimesh.set_instance_custom_data(i, Color(randf(), randf(), randf(), randf()))
		$School.multimesh.set_instance_color(i, Color.GREEN_YELLOW.lerp(Color.AZURE, randscale))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$School.rotate_object_local(Vector3.UP, delta * 0.05)
