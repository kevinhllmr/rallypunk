extends Node

var scrap = 0
var xp = 0
var rank = 0
var totalXP = 0
var uprank = (pow(2,rank))*500



func rankupgrade():
	if xp>=uprank:
		xp = 0
		rank += 1
		
func addXP(amount):
	xp =+ amount
	totalXP =+ amount
	rankupgrade()
