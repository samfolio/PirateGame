extends StaticBody2D

#upgrades for sale
#item 1 equals range upgrade.
var item = 1

#vars set the item prices
var item1price = 1
var item2price = 2

#vars for if the player owns an item.
var item1owned = false
var item2owned = false

var price 

func _ready():
	#play the range upgrade animation
	$icon.play("Rangeupgradeicon")
	item = 1

#if visible then continue
func _physics_process(delta):
	if self.visible == true:
		if item == 1:
			$icon.play("Rangeupgradeicon")
		if item == 2:
			$icon.play("Lootupgradeicon")

func _on_buttonleft_pressed():
	swap_item_back()
func _on_buttonright_pressed():
	swap_item_forward()
func _on_buybutton_pressed():
	if item == 1:
		price = item1price
		if Global.loot >= price:
			if item1owned == false:
					buy()
	elif item == 2:
		price = item2price
		if Global.loot >= price:
			if item2owned == false:
					buy()

func swap_item_back():
	if item == 1:
		item = 2
	elif item == 2:
		item = 1

func swap_item_forward():
	if item == 1:
		item = 2
	elif item == 2:
		item = 1

func buy():
	print("item bought")
	pass
	
