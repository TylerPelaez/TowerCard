extends Area2D
class_name BaseTower

const RED_TRANSPARENT_COLOR: Color = Color(1, 0, 0, 0.5)
const GREEN_TRANSPARENT_COLOR: Color = Color(0, 1, 0, 0.5)
const DEFAULT_COLOR: Color = Color(1, 1, 1, 1)

export (PackedScene) var Projectile
export var attack_range: float = 30.0
export var projectile_speed: float = 50.0
export var base_damage: int = 4
export var max_damage: int = 999999
export var damage: int = base_damage setget set_damage

onready var sprite: Sprite = $Sprite
onready var attackRange: Area2D = $AttackRange
onready var attackRangeCollider: CollisionShape2D = $AttackRange/CollisionShape2D
onready var fireBulletTimer: Timer = $FireBulletTimer

var active: bool = false
export var draw_range: bool = false

func _ready() -> void:
	sprite.modulate = GREEN_TRANSPARENT_COLOR
	draw_range = true

func _physics_process(delta: float) -> void:
	if !active:
		return
	
	if fireBulletTimer.time_left <= 0:
		var target = find_target()
		if target != null:
			_fire(target.global_position)
	
	# Force _draw() to be called
	update()
	

func _draw() -> void:
	if draw_range || Utils.DRAW_DEBUG:
		draw_circle(Vector2.ZERO, attack_range, Color(0, 0, 1, 0.25))

func set_damage(value: int) -> void:
	damage = clamp(value, base_damage, max_damage)

func set_range_collider_size() -> void:
	if attackRangeCollider.shape is CircleShape2D:
		attackRangeCollider.shape.radius = attack_range

func build_tower() -> void:
	sprite.modulate = DEFAULT_COLOR
	active = true
	draw_range = false
	attackRangeCollider.disabled = false
	set_range_collider_size()
	fireBulletTimer.start()

# This returns a BaseEnemy, or null if none found
# TODO: make this not be so terribly inefficient.
func find_target():
	var overlappingAreas = attackRange.get_overlapping_areas()
	if overlappingAreas.empty():
		return null
	
	var maxUnitOffset: float = -1.0
	var target = null
	for area in overlappingAreas:
		var areaParent = area.get_parent()
		if areaParent is BaseEnemy && areaParent.unit_offset > maxUnitOffset:
			maxUnitOffset = areaParent.unit_offset
			target = areaParent
	
	return target

func _fire(targetPosition: Vector2) -> void:
	var projectile = Utils.instance_scene_on_main(Projectile, global_position)
	projectile.velocity = (targetPosition - global_position) * projectile_speed
	projectile.rotation = projectile.velocity.angle()
	projectile.set_damage(damage)
	fireBulletTimer.start()

func set_cant_place_color() -> void:
	sprite.modulate = RED_TRANSPARENT_COLOR
	
func set_can_place_color() -> void:
	sprite.modulate = GREEN_TRANSPARENT_COLOR
