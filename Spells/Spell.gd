extends Node
class_name Spell

var single_target: bool= false
var aoe: float = 0.0
var spell_name: String = ""
var damage: int = 0
var spell_projectile_class

func initialize(spellName: String, area: float, spellDamage: int, st: bool, spellProjectileClass: PackedScene ) -> void:
	single_target = st
	aoe = area
	spell_name = spellName
	damage = spellDamage
	spell_projectile_class = spellProjectileClass

func cast(target_pos: Vector2) -> void:
	if single_target or spell_projectile_class == null:
		return
	
	var start_position = Vector2(target_pos.x + rand_range(-100, 100), -10)
	var instance = Utils.instance_scene_on_main(spell_projectile_class, start_position)
	instance.initialize(target_pos - start_position, target_pos, start_position, self )
