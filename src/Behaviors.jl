module Behaviors

import Base: start, next, done
export Behavior, 
       Transition,
       transitions,
       destination,
       check,
       action,
       add_transition!,
       next,
       BehaviorIterator,
       start,
       done

type Behavior
    action::Function
    transitions::Vector
end

type Transition
    check::Function
    destination::Behavior
end

transitions(b::Behavior) = b.transitions
destination(t::Transition) = t.destination
check(t::Transition, inputs...) = t.check(inputs...)
action(b::Behavior, inputs...) = b.action(inputs...)

function add_transition!(behavior::Behavior, transition::Transition)
    push!(behavior.transitions, transition)
end

function next(behavior::Behavior, inputs...)
    for t in transitions(behavior)
        if check(t, inputs...)
            behavior = destination(t)
            break
        end
    end
    behavior
end


type BehaviorIterator
    behaviors::Vector{Behavior}
    start::Vector{Behavior}
    final::Behavior
    input_getter::Function
end

input(biter::BehaviorIterator) = biter.input_getter()
start(biter::BehaviorIterator) = biter.start
done(biter::BehaviorIterator, behaviors::Vector{Behavior}) = any(behaviors .== biter.final)

function next(bset::BehaviorIterator, behaviors::Vector{Behavior})
    input_data = input(bset)
    for i in 1:length(behaviors)
        behaviors[i] = next(behaviors[i], input_data...)
    end
    [action(behaviors[i], input_data...) for i in 1:length(behaviors)], behaviors
end

end