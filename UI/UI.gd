extends Control

onready var handButton = $HandButton
onready var hand = $Hand
onready var tooltip = $Tooltip
onready var cardsInDeck = $CardsInDeck
onready var cardsInDiscard = $CardsInDiscard
onready var startWave = $StartWave
onready var waveNumber = $WaveNumber
onready var cardRewardScreen = $CardRewardScreen
onready var mana = $Mana
onready var play = $HBoxContainer/Play
onready var fastForward = $HBoxContainer/FastForward

var player_controller
var selected_card

signal start_wave

# Called when the node enters the scene tree for the first time.
func _ready():
	hand.connect("show_tooltip", self, "_on_ShowTooltip")
	hand.connect("hide_tooltip", self, "_on_HideTooltip")
	hand.connect("card_clicked", self, "_on_CardClicked")


func set_player_controller(playerController: PlayerController) -> void:
	player_controller = playerController
	player_controller.connect("card_played", self, "_on_CardPlayed")
	player_controller.connect("card_deselected", self, "_on_CardDeselected")
	mana.text = "Mana: " + str(playerController.current_mana)

func _on_ShowTooltip(tooltip_text):
	tooltip.text = tooltip_text
	tooltip.visible = true
	
func _on_HideTooltip():
	tooltip.text = "Hidden"
	tooltip.visible = false

func _on_CardClicked(uiCard: UICard) -> void:
	selected_card = uiCard
	player_controller.select_card(uiCard.card_data)
	hide_hand_ui()
	tooltip.text = uiCard.card_data.text
	tooltip.visible = true
	handButton.visible = false
	handButton.mouse_filter = MOUSE_FILTER_IGNORE
	
	uiCard.select()

func _on_CardPlayed() -> void:
	if selected_card == null:
		print("ERROR - selected_card is null, but card was played")
		return

	hand.discard_card(selected_card, true)
	
	hand.update_playable_cards(player_controller.current_mana)
	mana.text = "Energy: " + str(player_controller.current_mana)
	
	_on_CardDeselected()

func _on_CardDeselected() -> void:
	if selected_card == null:
		print("ERROR - selected_card is null, but card was deselected")
		return
	
	show_hand_ui()
	selected_card.deselect()
	selected_card = null
	handButton.visible = true
	handButton.mouse_filter = MOUSE_FILTER_PASS
	_on_HideTooltip()

func start_wave():
	startWave.visible = false

func end_wave(current_wave: int, total_waves: int) -> void:
	waveNumber.text = "Wave: " + str(current_wave) + "/" + str(total_waves)
	
	if selected_card != null:
		player_controller.cancel_card_play()
		
	player_controller.reset_mana()
	mana.text = "Energy: " + str(player_controller.current_mana)
	hide_hand_ui()
	cardRewardScreen.show()
	

func _on_StartWave_pressed():
	emit_signal("start_wave")

func hide_hand_ui():
	cardsInDeck.visible = false
	cardsInDiscard.visible = false
	hand.visible = false
	hand.mouse_filter = Control.MOUSE_FILTER_STOP

func show_hand_ui():
	cardsInDeck.visible = true
	cardsInDiscard.visible = true
	hand.visible = true
	hand.mouse_filter = Control.MOUSE_FILTER_PASS


func _on_CardRewardScreen_card_clicked(ui_card: UICard):
	if ui_card != null:
		Deck.discardCard(ui_card.card_data)
	
	startWave.visible = true
	cardRewardScreen.hide()
	hand.draw_new_hand()
	show_hand_ui()


func _on_Play_pressed():
	fastForward.visible = true
	fastForward.mouse_filter = MOUSE_FILTER_STOP
	play.visible = false
	play.mouse_filter = MOUSE_FILTER_IGNORE
	Engine.time_scale = 1.0


func _on_FastForward_pressed():
	fastForward.visible = false
	fastForward.mouse_filter = MOUSE_FILTER_IGNORE
	play.visible = true
	play.mouse_filter = MOUSE_FILTER_STOP
	Engine.time_scale = 2.0
