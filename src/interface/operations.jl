import Base: +, *, ^, -, /

macro extend_binary_op(opfun)
    opfun = esc(opfun)

    quote
        $opfun(expr::Expression, value) = $opfun(expr, express(value))
        $opfun(value, expr::Expression) = $opfun(express(value), expr)
    end
end

macro implement_binary_op(opfun, Optype)
    opfun = esc(opfun)
    Optype = esc(Optype)

    quote
        $opfun(args::Expression...) = simplify($Optype(args...))
        @extend_binary_op($opfun)
    end 
end

macro implement_assoc_op(opfun)
    opfun = esc(opfun)
    quote @implement_binary_op($opfun, Associative{$opfun}) end
end

macro implement_binary_op(opfun)
    opfun = esc(opfun)
    quote @implement_binary_op($opfun, NFunc{$opfun, 2}) end
end

@implement_assoc_op(+)
@implement_assoc_op(*)
@implement_binary_op(^)

-(expression::Expression) = NEG * expression
-(first::Expression, second::Expression) = first + -second
@extend_binary_op(-)

inv(expression::Expression) = expression ^ NEG
/(first::Expression, second::Expression) = first * inv(second)
@extend_binary_op(/)