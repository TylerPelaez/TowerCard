extends Node

enum STATE {
	DEFAULT,
	PLACING_TOWER
}

const BasicTowerResource: Resource = preload("res://Towers/BasicTower.tscn")

var ui_state = STATE.DEFAULT
var held_tower

var level_placement_area

func _physics_process(delta: float) -> void:
	match ui_state:
		STATE.DEFAULT:
			if Input.is_action_just_pressed("dev_place_tower"):
				_start_placing_tower(BasicTowerResource)
		STATE.PLACING_TOWER:
			if held_tower == null:
				print("ERROR: state is PLACING_TOWER, but held_tower is null")
				return
			
			if Input.is_action_just_pressed("cancel_tower_placement"):
				held_tower.queue_free()
				held_tower = null
				ui_state = STATE.DEFAULT
				return
			
			held_tower.global_position = held_tower.get_global_mouse_position()
			
			if !can_place_held_tower():
				held_tower.set_cant_place_color()
				return
			
			if Input.is_action_just_pressed("place_tower"):
				_place_tower()
			else:
				held_tower.set_can_place_color()

func set_level_placement_area(area: Node) -> void:
	level_placement_area = area

func _start_placing_tower(tower: Resource) -> void:
	ui_state = STATE.PLACING_TOWER
	var instance = tower.instance()
	get_tree().current_scene.add_child(instance)
	instance.global_position = instance.get_global_mouse_position()
	held_tower = instance
	
func _place_tower() -> void:
	held_tower.build_tower()
	held_tower = null
	ui_state = STATE.DEFAULT

func can_place_held_tower() -> bool:
	if held_tower == null || level_placement_area == null:
		return false
	
	return held_tower.overlaps_area(level_placement_area) && held_tower.get_overlapping_areas().size() == 1
