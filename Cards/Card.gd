extends Node

# enum for cardType
enum {TOWER, SPELL}

var cardName
var cardType
var image
var text

# Cards should discard, not trash by default
var trashes = false
