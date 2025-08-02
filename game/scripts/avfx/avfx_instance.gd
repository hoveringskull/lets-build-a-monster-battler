class_name AVFXInstance extends Node

var target: Monster
var resource: AVFXResource

func _init(res, targ):
	target = targ
	resource = res

func execute():
	resource._do(self)
