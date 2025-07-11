macro extend_binary_op(opfun)
    opfun = esc(opfun)

    quote
        $opfun(expr::Expression, value) = $opfun(expr, Expression(value))
        $opfun(value, expr::Expression) = $opfun(Expression(value), expr)
    end
end

macro implement_binary_op(opfun, Optype)
    opfun = esc(opfun)
    Optype = esc(Optype)

    quote
        $opfun(args::Expression...) = $Optype(args...)
        @extend_binary_op($opfun)
        
        $Optype
    end 
end

macro operator(expr::Expr)
    if expr.head !== :curly
        throw(ArgumentError("Malformed operator type: $expr"))
    end

    Optype = esc(expr)
    opfun = esc(expr.args[2])

    :( @implement_binary_op($opfun, $Optype) )
end