extends MarginContainer
class_name UICard

onready var image = $ImageRect

signal show_tooltip(tooltip_text)
signal hide_tooltip

var card_data

# Called when the node enters the scene tree for the first time.
func _ready():
	# For debugging
	if Utils.is_main_scene(self):
		initialize(CardsDatabase.create_card_from_data(CardsDatabase.DATA[CardsDatabase.Bunker]))
	
func initialize(cardData: Card) -> void:
	card_data = cardData
	image.texture = load(card_data.image)


func _on_UICard_mouse_entered():
	emit_signal("show_tooltip", card_data.text)


func _on_UICard_mouse_exited():
	emit_signal("hide_tooltip")
