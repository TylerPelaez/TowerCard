extends Node

var drawPile = []
var discardPile = []
var trashPile = []
var hand = []

func _ready():
	drawPile.push_back(CardsDatabase.create_card_from_data(CardsDatabase.DATA[CardsDatabase.Bunker]))
	drawPile.push_back(CardsDatabase.create_card_from_data(CardsDatabase.DATA[CardsDatabase.Bunker]))
	drawPile.push_back(CardsDatabase.create_card_from_data(CardsDatabase.DATA[CardsDatabase.Bunker]))

# Draw the top card of the deck
# Puts it in the hand
func drawCard():
	# Return discards if no cards left in draw pile
	if drawPile.size() < 1:
		returnDiscards()
	var drawnCard = drawPile.pop_front()
	return drawnCard
	
# Puts the card passed in as an argument on top of the discard pile
func discardCard(card):
	discardPile.push_front(card)
	
# Trashes the card passed in as argument
# Trashing is akin to exiling a card in magic - You can't get it back
func trashCard(card):
	trashPile.push_front(card)
	
# Shuffles the deck
func shuffleDeck():
	drawPile.shuffle()
	
# Shuffles the discard pile back into the deck
func returnDiscards():
	for card in discardPile:
		drawPile.push_front(card)
	shuffleDeck()
	
# Plays the specified card from the hand
func playCard(index):
	hand.remove(index)
