extends Node

class_name Handler

var handler_machine

func initialize(handler_machine):
	rpc("add_to_handlers_group")
	self.handler_machine = handler_machine


remotesync func add_to_handlers_group():
	add_to_group(str(get_tree().get_rpc_sender_id()) + "_handlers", true)
