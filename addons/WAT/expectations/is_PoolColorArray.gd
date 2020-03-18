extends "base.gd"

func _init(value, context: String) -> void:
	var passed: String = "%s is builtin: PoolColorArray" % value
	var failed: String = "%s is not builtin: PoolColorArray" % value
	self.context = context
	self.success = value is PoolColorArray
	self.expected = passed
	self.result = passed if self.success else failed