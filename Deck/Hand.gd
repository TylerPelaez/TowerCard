extends HBoxContainer
class_name Hand

# This class instantiates UICards from Card objects
const UICardScene: PackedScene = preload("res://Cards/UICard.tscn")

export var hand_limit: int = 5

signal show_tooltip(tooltip_text)
signal hide_tooltip
signal card_clicked(ui_card)

func _ready() -> void:
	visible = false
	draw_new_hand()

func draw_new_hand() -> void:
	if get_child_count() > 0:
		for child in get_children():
			if child is UICard:
				discard_card(child)
	
	while not _is_at_hand_limit():
		add_card(Deck.drawCard())

func add_card(cardData: Card) -> bool:
	if _is_at_hand_limit():
		return false
	
	var uiCard: UICard = UICardScene.instance()
	add_child(uiCard)
	uiCard.initialize(cardData)
	uiCard.connect("show_tooltip", self, "_on_ShowTooltip")
	uiCard.connect("hide_tooltip", self, "_on_HideTooltip")
	uiCard.connect("clicked", self, "_on_CardClicked")
	return true

# This calls queue free on the ui card, don't use the passed in card after calling this function
func discard_card(card: UICard) -> bool:
	# If the card isn't a trash card, add it to the discard pile
	if (card.card_data.trashes == false):
		Deck.discardCard(card.card_data.duplicate())
	for child in get_children():
		if child == card:
			remove_child(card)
			card.queue_free()
			return true
	return false
	
func _is_at_hand_limit() -> bool:
	return get_child_count() >= hand_limit

# Toggles hand show/hide when button is pressed
func _on_HandButton_pressed():
	visible = !visible
	mouse_filter = Control.MOUSE_FILTER_PASS if visible else Control.MOUSE_FILTER_STOP
	
func _on_ShowTooltip(tooltip_text):
	emit_signal("show_tooltip", tooltip_text)
	
func _on_HideTooltip():
	emit_signal("hide_tooltip")
	
func _on_CardClicked(uiCard: UICard) -> void:
	emit_signal("card_clicked", uiCard)
