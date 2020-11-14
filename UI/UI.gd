extends Control

onready var handButton = $HandButton
onready var hand = $Hand
onready var tooltip = $Tooltip

var player_controller
var selected_card

# Called when the node enters the scene tree for the first time.
func _ready():
	hand.connect("show_tooltip", self, "_on_ShowTooltip")
	hand.connect("hide_tooltip", self, "_on_HideTooltip")
	hand.connect("card_clicked", self, "_on_CardClicked")


func set_player_controller(playerController: PlayerController) -> void:
	player_controller = playerController
	player_controller.connect("card_played", self, "_on_CardPlayed")
	player_controller.connect("card_deselected", self, "_on_CardDeselected")

func _on_ShowTooltip(tooltip_text):
	tooltip.text = tooltip_text
	tooltip.visible = true
	
func _on_HideTooltip():
	tooltip.text = "Hidden"
	tooltip.visible = false

func _on_CardClicked(uiCard: UICard) -> void:
	selected_card = uiCard
	player_controller.select_card(uiCard.card_data)
	hand.visible = false
	hand.mouse_filter = Control.MOUSE_FILTER_STOP
	tooltip.text = uiCard.card_data.text
	tooltip.visible = true
	handButton.visible = false
	handButton.mouse_filter = MOUSE_FILTER_IGNORE
	
	uiCard.select()

func _on_CardPlayed() -> void:
	if selected_card == null:
		print("ERROR - selected_card is null, but card was played")
		return
	
	hand.discard_card(selected_card)
	_on_CardDeselected()

func _on_CardDeselected() -> void:
	if selected_card == null:
		print("ERROR - selected_card is null, but card was deselected")
		return
	
	hand.mouse_filter = Control.MOUSE_FILTER_PASS
	hand.visible = true
	selected_card.deselect()
	selected_card = null
	handButton.visible = true
	handButton.mouse_filter = MOUSE_FILTER_PASS
	_on_HideTooltip()
