import Base.promote_rule
import Base: +, *

promote_rule(::Type{<:Expression}, ::Type) = Expression

macro implement_algebraic_op(OP)
    OP = esc(OP)

    quote
        ($OP)(args::Expression...) = simplify(AssociativeOperation{$OP}(args...))

        ($OP)(expr::Expression, value) = ($OP)(expr, convert(Expression, value))
        ($OP)(value, expr::Expression) = ($OP)(convert(Expression, value), expr)
    end
end

@implement_algebraic_op(+)
@implement_algebraic_op(*)
