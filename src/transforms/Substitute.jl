const ExpressionMap = Dict{Expression, Expression}

struct Substitute <: RecursiveTransform
    mapping::ExpressionMap
end

expressionpair(pair::Pair{<:Expression, <:Expression}) = pair
expressionpair(pair::Pair) = Expression(pair.first) => Expression(pair.second)
Substitute(args::Pair...) = Substitute(ExpressionMap(map(expressionpair, args)...))

tryapply(substitute::Substitute, expression::Expression) = get(substitute.mapping, expression, nothing)

substitute(expression::Expression, args...) = simplify(apply(Substitute(args...), expression))
