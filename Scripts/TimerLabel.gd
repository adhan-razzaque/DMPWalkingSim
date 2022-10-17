extends Label

var LABEL_FORMAT: String = "Time in Backrooms: %s seconds"
var seconds: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func increment_counter() -> void:
	seconds += 1
	self.text = LABEL_FORMAT % seconds


func _on_timer_timeout():
	increment_counter()
