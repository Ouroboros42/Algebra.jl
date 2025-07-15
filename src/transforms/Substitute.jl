const ExpressionMap = Dict{Expression, Expression}

struct Substitute <: Transform
    mapping::ExpressionMap
end

expressionpair(pair::Pair{<:Expression, <:Expression}) = pair
expressionpair(pair::Pair) = Expression(pair.first) => Expression(pair.second)

Substitute(arg) = Substitute(ExpressionMap(expressionpair(arg)))
Substitute(args...) = Substitute(ExpressionMap(map(expressionpair, args)...))

substitute(expression::Expression, args...) = apply(TRIVIAL_CHAIN, apply(Substitute(args...), expression))

tryapply(substitute::Substitute, expression::Expression) = get(substitute.mapping, expression, nothing)