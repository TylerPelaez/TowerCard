extends HBoxContainer

signal show_tooltip(tooltip_text)
signal hide_tooltip
signal card_clicked(ui_card)

const UICardScene: PackedScene = preload("res://Cards/UICard.tscn")

var size_limit = 2

func _ready():
	pass
	
func add_card(cardData: Card):
	if get_child_count() >= size_limit:
		return
	
	var uiCard: UICard = UICardScene.instance()
	add_child(uiCard)
	uiCard.initialize(cardData)
	
	uiCard.connect("show_tooltip", self, "_on_ShowTooltip")
	uiCard.connect("hide_tooltip", self, "_on_HideTooltip")
	uiCard.connect("clicked", self, "_on_CardClicked")

func clear():
	for child in get_children():
		child.queue_free()
	
func _on_ShowTooltip(tooltip_text):
	emit_signal("show_tooltip", tooltip_text)
	
func _on_HideTooltip():
	emit_signal("hide_tooltip")
	
func _on_CardClicked(uiCard: UICard) -> void:
	emit_signal("card_clicked", uiCard)
