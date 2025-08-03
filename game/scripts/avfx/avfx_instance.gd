class_name AVFXInstance extends Node

var target: Monster
var user: Monster
var resource: AVFXResource

func _init(res, targ, usr):
	target = targ
	resource = res
	user = usr

func execute():
	resource._do(self)

func finish():
	AVFXManager.remove_effect(self)
