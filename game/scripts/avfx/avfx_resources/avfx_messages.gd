class_name AVFXMessages extends AVFXResource

@export var messages: Array[MessageResource]

func _init(msgs: Array[MessageResource]):
	messages = msgs

func _do(instance: AVFXInstance):
	Events.on_avfx_messages.emit(instance)
	for message in messages:
		Events.request_log.emit(message.text)

static func fromStrings(texts: Array[String]):
	var messages_resource = AVFXMessages.new([])
	for text in texts:
		var message_resource = MessageResource.new(text)
		messages_resource.messages.append(message_resource)
	return messages_resource
