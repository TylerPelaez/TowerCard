extends MarginContainer
class_name UICard

onready var image = $ImageRect

signal show_tooltip(tooltip_text)
signal hide_tooltip
signal clicked(ui_card)

var card_data
var selected := false
var mouse_over := false

# Called when the node enters the scene tree for the first time.
func _ready():
	# For debugging
	if Utils.is_main_scene(self):
		initialize(CardsDatabase.create_card_from_data(CardsDatabase.DATA[CardsDatabase.Bunker]))
	
func initialize(cardData: Card) -> void:
	card_data = cardData
	image.texture = load(card_data.image)

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.is_action("place_tower") and mouse_over:
			emit_signal("clicked", self)
			get_tree().set_input_as_handled()

# we can make these update the ui somehow if we get time for that
func select():
	mouse_over = false
	selected = true

func deselect():
	mouse_over = false
	selected = false
	
func _on_UICard_mouse_entered():
	mouse_over = true
	emit_signal("show_tooltip", card_data.text)


func _on_UICard_mouse_exited():
	mouse_over = false
	emit_signal("hide_tooltip")

