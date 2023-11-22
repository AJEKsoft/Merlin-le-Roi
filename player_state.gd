extends Node

var health = 40
var health_max = 40
var mana = 30
var mana_max = 30
var mana_regen = 3

var available_runes = [ "aries", "capricorn", "cancer", "libra" ]

var current_scene = null # This holds the current exploration scene, saved between battles

#var available_spells = [
#	SpellData.spells["flame"],
#	SpellData.spells["bandaid"],
#	SpellData.spells["quake"]
#]
