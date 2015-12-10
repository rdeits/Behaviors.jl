# Behaviors.jl

Simple finite-state-machine based behaviors, for robotics and other applications. 

	going_up = Behavior((i, x) -> x[1] += 1, [])
	going_down = Behavior((i, x) -> x[1] -= 1, [])
	final = Behavior((i, x) -> x[1], [])
	up_to_down = Transition((i, x) -> x[1] >= 10, going_down)
	down_to_up = Transition((i, x) -> x[1] < 1, going_up)
	add_transition!(going_up, up_to_down)
	add_transition!(going_down, down_to_up)
	add_transition!(going_up, Transition((i, x) -> i > 20, final))

	output = []
	i = 1
	x = [5]
	for action_results in BehaviorIterator([going_up, going_down], [going_up], final, () -> (i, x))
	    i += 1
	    push!(output, copy(x[1]))
	end

	@test all(output .== [6, 7, 8, 9, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 1, 2, 3, 4, 5, 5])
