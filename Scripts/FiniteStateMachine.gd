extends Node2D  # 继承自Node2D，表示这是一个2D节点

var current_state: State  # 当前状态
var previous_state: State  # 上一个状态

# 节点准备完毕时调用的方法
func _ready():
	current_state = get_child(0) as State  # 初始化时，将第一个子节点作为当前状态
	previous_state = current_state  # 设置当前状态为上一个状态
	current_state.enter()  # 调用当前状态的enter方法

# 更改状态的方法
func change_state(state):
	current_state = find_child(state) as State  # 查找并设置新的状态
	current_state.enter()  # 进入新状态
	
	previous_state.exit()  # 退出上一个状态
	previous_state = current_state  # 更新上一个状态的引用为当前状态
