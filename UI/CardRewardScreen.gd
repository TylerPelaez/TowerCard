extends Control

signal show_tooltip(tooltip_text)
signal hide_tooltip
signal card_clicked(ui_card)

onready var cardReward = $CardReward
onready var label = $Label
onready var button = $Button

func _ready():
	hide()

func show() -> void:
	visible = true
	mouse_filter = MOUSE_FILTER_STOP
	cardReward.visible = true
	cardReward.mouse_filter = MOUSE_FILTER_STOP
	label.visible = true
	button.visible = true
	button.mouse_filter = MOUSE_FILTER_STOP
	
	for i in range(cardReward.size_limit):
		var randomChoice = randi() % CardsDatabase.DATA.keys().size()
		var cardToAdd = CardsDatabase.create_card_from_data(CardsDatabase.DATA[randomChoice])
		cardReward.add_card(cardToAdd)
	
func hide() -> void:
	visible = false
	label.visible = false
	mouse_filter = MOUSE_FILTER_IGNORE
	cardReward.visible = false
	cardReward.mouse_filter = MOUSE_FILTER_IGNORE
	cardReward.clear()
	
	button.visible = false
	button.mouse_filter = MOUSE_FILTER_IGNORE

func _on_CardReward_card_clicked(ui_card: UICard):
	emit_signal("card_clicked", ui_card)

func _on_CardReward_hide_tooltip():
	emit_signal("hide_tooltip")

func _on_CardReward_show_tooltip(tooltip_text):
	emit_signal("show_tooltip", tooltip_text)


func _on_Button_pressed():
	emit_signal("card_clicked", null)
