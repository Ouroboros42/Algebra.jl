"""
Base for all expressions containing sub-expressions.
Should implement `args` to return a collection of the sub-expressions.
"""
abstract type CompoundExpression{T} <: Expression{T} end

isequal(first::C, second::C) where {C <: CompoundExpression} = isequal(args(first), args(second))

isless(first::C, second::C) where {C <: CompoundExpression} = isless(args(first), args(second))

const NyTuple{T} = NTuple{N, T} where N

unionise_recursive(type, ::Tuple{}) = type
unionise_recursive(type, (expr, others...)::NyTuple{Expression}) = unionise_recursive(Union{type, valuetype(expr)}, others)

unionise(expressions::NyTuple{Expression}) = unionise_recursive(Union{}, expressions)
unionise(::NyTuple{Expression{T}}) where T = T
unionise(expressions::Vector{E}) where {E <: Expression} = unionise(Tuple(expressions))
unionise(::Vector{E}) where {T, E <: Expression{T}} = T
