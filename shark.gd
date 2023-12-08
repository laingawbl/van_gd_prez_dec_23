extends Node3D

var shark_index
var dragging: bool = false
var resting_turn_rate = 0.0

@onready var empty_mat = Material.new()
@export var shark_top: Color
@export var shark_btm: Color

var noshader_idx = 0
var vertex_idx = 0
var frag_idx = 0
var light_idx = 0

var swing_light = false

func _ready():
	cycle_noshader()
	cycle_vertex()
	cycle_fragment()
	cycle_light()
	goto_shark(0)


func _process(delta):
	$camera_orbit.rotate_object_local(Vector3.UP, delta * resting_turn_rate)
	
	if swing_light:
		$sun.visible = false
		$shark_lighting/omni_root/omni.visible = true
		$shark_lighting/omni_root.rotate_y(delta * 1.5)
		$env.environment.ambient_light_sky_contribution = 0.0
		$env.environment.ambient_light_energy = 0.25
	else:
		$sun.visible = true
		$shark_lighting/omni_root/omni.visible = false
		$env.environment.ambient_light_sky_contribution = 0.75
		$env.environment.ambient_light_energy = 2.0


func cycle_noshader():
	swing_light = false
	match noshader_idx:
		0:	# no material
			$shark_noshader.mesh.surface_set_material(0, empty_mat)
			$shark_noshader.mesh.surface_set_material(1, empty_mat)
		1:	# material
			$shark_noshader.mesh.surface_set_material(0, preload("res://shaders/shark_mat_top.tres"))
			$shark_noshader.mesh.surface_set_material(1, preload("res://shaders/shark_mat_btm.tres"))


func cycle_vertex():
	swing_light = false
	var x_mat: ShaderMaterial = preload("res://shaders/shark_vtx_explode.tres")
	var s_mat: ShaderMaterial = preload("res://shaders/shark_vtx_swim.tres")
	
	match vertex_idx:
		0:
			$shark_vertex.mesh.surface_set_material(0, preload("res://shaders/shark_mat_top.tres"))
			$shark_vertex.mesh.surface_set_material(1, preload("res://shaders/shark_mat_btm.tres"))
			$codebar.set_texture(preload("res://assets/vertex_0.png"))
		1:
			x_mat.set_shader_parameter("vcol", 0.0)
			x_mat.set_shader_parameter("explode", 0.0)
			$shark_vertex.mesh.surface_set_material(0, x_mat)
			$shark_vertex.mesh.surface_set_material(1, x_mat)
			$shark_vertex.set_instance_shader_parameter("albedo", shark_top)
			$codebar.set_texture(preload("res://assets/vertex_1.png"))
		2:
			x_mat.set_shader_parameter("vcol", 1.0)
			x_mat.set_shader_parameter("explode", 0.0)
			$shark_vertex.mesh.surface_set_material(0, x_mat)
			$shark_vertex.mesh.surface_set_material(1, x_mat)
			$shark_vertex.set_instance_shader_parameter("albedo", shark_top)
			$codebar.set_texture(preload("res://assets/vertex_2.png"))
		3:
			x_mat.set_shader_parameter("vcol", 0.5)
			x_mat.set_shader_parameter("explode", 0.5)
			$shark_vertex.mesh.surface_set_material(0, x_mat)
			$shark_vertex.mesh.surface_set_material(1, x_mat)
			$shark_vertex.set_instance_shader_parameter("albedo", shark_top)
			$codebar.set_texture(preload("res://assets/vertex_3.png"))
		4:
			s_mat.set_shader_parameter("stage", 0)
			$shark_vertex.mesh.surface_set_material(0, s_mat)
			$shark_vertex.mesh.surface_set_material(1, s_mat)
		5:
			s_mat.set_shader_parameter("stage", 1)
			$shark_vertex.mesh.surface_set_material(0, s_mat)
			$shark_vertex.mesh.surface_set_material(1, s_mat)
		6:
			s_mat.set_shader_parameter("stage", 2)
			$shark_vertex.mesh.surface_set_material(0, s_mat)
			$shark_vertex.mesh.surface_set_material(1, s_mat)
		7:
			s_mat.set_shader_parameter("stage", 3)
			$shark_vertex.mesh.surface_set_material(0, s_mat)
			$shark_vertex.mesh.surface_set_material(1, s_mat)
		8:
			s_mat.set_shader_parameter("stage", 4)
			$shark_vertex.mesh.surface_set_material(0, s_mat)
			$shark_vertex.mesh.surface_set_material(1, s_mat)
		9:
			s_mat.set_shader_parameter("stage", 5)
			$shark_vertex.mesh.surface_set_material(0, s_mat)
			$shark_vertex.mesh.surface_set_material(1, s_mat)
		10:
			s_mat.set_shader_parameter("stage", 6)
			$shark_vertex.mesh.surface_set_material(0, s_mat)
			$shark_vertex.mesh.surface_set_material(1, s_mat)


func cycle_fragment():
	swing_light = false
	var img_tex: StandardMaterial3D = preload("res://shaders/sharc_picture.tres")
	var crawl_tex: ShaderMaterial = preload("res://shaders/shark_frag_crawl.tres")
	match frag_idx:
		0:
			$shark_fragment.mesh.surface_set_material(0, preload("res://shaders/shark_mat_top.tres"))
			$shark_fragment.mesh.surface_set_material(1, preload("res://shaders/shark_mat_btm.tres"))
			$codebar.set_texture(preload("res://assets/frag_0.png"))
		1:
			img_tex.set_texture(BaseMaterial3D.TEXTURE_ALBEDO, preload("res://assets/uv_checker.jpg"))
			$shark_fragment.mesh.surface_set_material(0, img_tex)
			$shark_fragment.mesh.surface_set_material(1, img_tex)
			$codebar.set_texture(preload("res://assets/frag_1.png"))
		2:
			$shark_fragment.mesh.surface_set_material(0, crawl_tex)
			$shark_fragment.mesh.surface_set_material(1, crawl_tex)
			$codebar.set_texture(preload("res://assets/frag_2.png"))
		3:
			img_tex.set_texture(BaseMaterial3D.TEXTURE_ALBEDO, preload("res://assets/sharc.png"))
			img_tex.roughness = 1.0
			img_tex.metallic = 0.0
			$shark_fragment.mesh.surface_set_material(0, img_tex)
			$shark_fragment.mesh.surface_set_material(1, img_tex)
			$codebar.set_texture(preload("res://assets/sharc_4x.png"))
		4:
			img_tex.set_texture(BaseMaterial3D.TEXTURE_ALBEDO, preload("res://assets/sharc.png"))
			img_tex.roughness = 0.0
			img_tex.metallic = 1.0
			$shark_fragment.mesh.surface_set_material(0, img_tex)
			$shark_fragment.mesh.surface_set_material(1, img_tex)
			$codebar.set_texture(preload("res://assets/frag_4.png"))


func cycle_light():
	swing_light = false
	var types_tex: ShaderMaterial = preload("res://shaders/shark_light_types.tres")
	var toon_mat: ShaderMaterial = preload("res://shaders/shark_light_toon.tres")
	match light_idx:
		0:
			$shark_lighting.mesh.surface_set_material(0, preload("res://shaders/shark_mat_top.tres"))
			$shark_lighting.mesh.surface_set_material(1, preload("res://shaders/shark_mat_btm.tres"))
			$codebar.set_texture(preload("res://assets/light_0.png"))
		1: 
			types_tex.set_shader_parameter("stage", 0)
			$shark_lighting.mesh.surface_set_material(0, types_tex)
			$shark_lighting.mesh.surface_set_material(1, types_tex)
			swing_light = true
		2:
			types_tex.set_shader_parameter("stage", 1)
			$shark_lighting.mesh.surface_set_material(0, types_tex)
			$shark_lighting.mesh.surface_set_material(1, types_tex)
			swing_light = true
		3:
			types_tex.set_shader_parameter("stage", 2)
			$shark_lighting.mesh.surface_set_material(0, types_tex)
			$shark_lighting.mesh.surface_set_material(1, types_tex)
			swing_light = true
		4:
			types_tex.set_shader_parameter("stage", 3)
			$shark_lighting.mesh.surface_set_material(0, types_tex)
			$shark_lighting.mesh.surface_set_material(1, types_tex)
			swing_light = true
		5:
			$shark_lighting.mesh.surface_set_material(0, toon_mat)
			$shark_lighting.mesh.surface_set_material(1, toon_mat)
			swing_light = true
		6:
			$shark_lighting.mesh.surface_set_material(0, toon_mat)
			$shark_lighting.mesh.surface_set_material(1, toon_mat)
			swing_light = false

func goto_shark(idx: int):
	if shark_index == idx:
		return
	shark_index = idx
	var cam_tween = $camera_orbit.create_tween()
	cam_tween.set_trans(Tween.TRANS_ELASTIC)
	cam_tween.set_ease(Tween.EASE_OUT)
	cam_tween.tween_property($camera_orbit, "position", Vector3(idx * 5, 0, -idx), 1.5)


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
	elif event is InputEventMouseMotion and dragging:
		var motion = event.get_relative() * 0.05
		$camera_orbit.rotate_object_local(Vector3.UP, motion.x * 0.25)
		$camera_orbit/camera.position.y += motion.y
		$camera_orbit/camera.look_at($camera_orbit.global_position)


func _unhandled_key_input(event):
	var topline_prefix = "[b][i]shark[/i]: "
	if event is InputEventKey:
		match event.keycode:
			KEY_1:
				goto_shark(0)
				$codebar.visible = false
				$topline.set_text(topline_prefix + "unshaded")
				cycle_noshader()
			KEY_2:
				goto_shark(1)
				$codebar.visible = false
				$shark_vertex.visible = true
				$topline.set_text(topline_prefix + "vertex()")
				cycle_vertex()
			KEY_3:
				goto_shark(2)
				$codebar.visible = false
				$shark_fragment.visible = true
				$topline.set_text(topline_prefix + "fragment()")
				cycle_fragment()
			KEY_4:
				goto_shark(3)
				$codebar.visible = false
				$shark_lighting.visible = true
				$topline.set_text(topline_prefix + "light()")
				cycle_light()
			KEY_K:
				get_tree().change_scene_to_file("res://scene.tscn")
			KEY_TAB:
				if !event.pressed:
					return
				var rev = event.is_shift_pressed()
				match shark_index:
					0:
						if rev:
							noshader_idx = posmod(noshader_idx - 1, 2)
						else:
							noshader_idx = (noshader_idx + 1) % 2
						cycle_noshader()
					1:
						if rev:
							vertex_idx = posmod(vertex_idx - 1, 11)
						else:
							vertex_idx = (vertex_idx + 1) % 11
						cycle_vertex()
					2:
						if rev:
							frag_idx = posmod(frag_idx - 1, 5)
						else:
							frag_idx = (frag_idx + 1) % 5
						cycle_fragment()
					3:
						if rev:
							light_idx = posmod(light_idx - 1, 7)
						else:
							light_idx = (light_idx + 1) % 7
						cycle_light()
					_:
						print("can't cycle shark %d" % shark_index)
			_:
				print("unhandled keycode %d" % event.keycode)
