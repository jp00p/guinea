extends Control

# using @onready is basically the same as putting these in the built-in _ready() function
# node paths can't be accessed before the MAIN node is "ready"
# this way we don't have to do
#
# var butt = null
#
# func _ready():
#   butt = $Container/Node2D
#

# all the variables outside of a function in this script are accessible to all functions in this script
# aka globals (only for this script)
@onready var tick_primary : Timer = $PrimaryTick
@onready var tick_secondary : Timer = $SecondaryTick

@onready var progress_primary : ProgressBar = $MarginContainer/HBoxContainer/VBoxContainer/ProgressBar
@onready var progress_secondary : ProgressBar = $MarginContainer/HBoxContainer/VBoxContainer/ProgressBar2

# for complicated paths...
# if you literally type:
# @onready var resource_bar_1 = $ResourceBar1
# you'll see the entire path to ResourceBar1 autofills and you just press enter to choose
# so you don't have to type the whole path out!
# there is another secret trick too i'll show you IRL

@onready var resource_value_1 : Label = $MarginContainer/HBoxContainer/VBoxContainer2/ResourceValue1
@onready var resource_value_2 : Label = $MarginContainer/HBoxContainer/VBoxContainer2/ResourceValue2

# all the colons in these variable declarations are basically "optional"
# type hinting will help your autofill and you will be thankful you did it
# setter functions explained a bit more below, but only use these if you have a reason
               # type    # setter function
var resource_1 : float = 0 : set = set_resource_1
var resource_2 : float = 0 : set = set_resource_2

# but you can do this too
var _resource_3 = 0
# (underscore means it's not being used)

# how fast each tick goes (in seconds)
var tick_1_speed = 1.0
var tick_2_speed = 2.5

# how much resource per tick
var resource_1_gain = 1
var resource_2_gain = 0.5

func _ready():
    tick_primary.wait_time = tick_1_speed
    tick_secondary.wait_time = tick_2_speed

func _process(_delta:float):
    # every frame we update the progress bars' values
    # progress bars are set to have a min value of 0 and a max value of 1
    # so we just do a little percent math on the timers, without multiplying by 100
    progress_primary.value = float(tick_primary.time_left / tick_primary.wait_time)
    progress_secondary.value = float(tick_secondary.time_left / tick_secondary.wait_time)

func _on_primary_tick_timeout():
    # each time this timer finishes, we can update a resource!
    self.resource_1 += resource_1_gain

func _on_secondary_tick_timeout():
    self.resource_2 += resource_2_gain
    # we have to use SELF.resource because this variable has a setter function
    # normally you can omit `self`


# setter functions! magic
# each time the variable "resource_1" gets modified
# instead of assigning the value to the variable as normal
# this function runs, and we can do whatever we want with the new value
# but you have to manually set resource_1 to the new value as well
func set_resource_1(value:float):
    resource_1 = value # make sure we set the value!
    resource_value_1.text = str(resource_1) # then we can update the label with the new amount


func set_resource_2(value:float):
    resource_2 = value # do NOT use `self` in setter functions!
    # this way we don't fire the setter again and get stuck in a loop!
    resource_value_2.text = str(resource_2)

# some of these would be good for setter functions
# to clamp the min/max values and set the timer
# but whatever!
func _on_tick_1_faster_pressed():
    tick_1_speed -= 0.01
    tick_primary.wait_time = tick_1_speed

func _on_tick_1_slower_pressed():
    tick_1_speed += 0.01
    tick_primary.wait_time = tick_1_speed

func _on_tick_2_faster_pressed():
    tick_2_speed -= 0.01
    tick_secondary.wait_time = tick_2_speed

func _on_tick_2_slower_pressed():
    tick_2_speed += 0.01
    tick_secondary.wait_time = tick_2_speed

func _on_resource_1_gain_pressed():
    resource_1_gain += 1

func _on_resource_2_gain_pressed():
    resource_2_gain += 1
