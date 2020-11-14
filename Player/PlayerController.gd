extends Node2D

enum STATE {
	DEFAULT,
	PLACING_TOWER,
	CASTING
}

const BasicTowerResource: PackedScene = preload("res://Towers/BasicTower.tscn")

var ui_state = STATE.DEFAULT
var held_tower
var selected_spell

var level_placement_area

func _physics_process(delta: float) -> void:
	match ui_state:
		STATE.DEFAULT:
			if Input.is_action_just_pressed("dev_place_tower"):
				_start_placing_tower(BasicTowerResource)
			if Input.is_action_just_pressed("dev_cast_spell"):
				var spellCard = CardsDatabase.create_card_from_data(CardsDatabase.DATA[CardsDatabase.Missile])
				_start_casting_spell(spellCard)
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
		STATE.CASTING:
			if selected_spell == null:
				print("ERROR: state is CASTING, but selected_spell is null")
				return
				
			if Input.is_action_just_pressed("cancel_tower_placement"):
				selected_spell = null
				ui_state = STATE.DEFAULT
				return
			
			if Input.is_action_just_pressed("place_tower"):
				_cast_spell()

func set_level_placement_area(area: Node) -> void:
	level_placement_area = area

func _start_placing_tower(tower: PackedScene) -> void:
	ui_state = STATE.PLACING_TOWER
	var instance = tower.instance()
	get_tree().current_scene.add_child(instance)
	instance.global_position = instance.get_global_mouse_position()
	held_tower = instance
	
func _place_tower() -> void:
	held_tower.build_tower()
	held_tower = null
	ui_state = STATE.DEFAULT

func _start_casting_spell(spell: SpellCard) -> void:
	ui_state = STATE.CASTING
	selected_spell = spell.spell

func _cast_spell() -> void:
	selected_spell.cast(get_global_mouse_position())
	selected_spell = null
	ui_state = STATE.DEFAULT

func can_place_held_tower() -> bool:
	if held_tower == null || level_placement_area == null:
		return false
	
	return held_tower.overlaps_area(level_placement_area) && held_tower.get_overlapping_areas().size() == 1
