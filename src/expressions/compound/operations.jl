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

macro implement_assoc_op(opfun)
    opfun = esc(opfun)

    quote
        @implement_binary_op($opfun, Associative{$opfun})
    end
end

macro implement_binary_op(opfun)
    opfun = esc(opfun)

    quote
        @implement_binary_op($opfun, Simple{$opfun, 2})
    end
end

macro implement(expr::Expr)
    if expr.head !== :curly
        throw(ArgumentError("Malformed Expression type to implement: $expr"))
    end

    Optype = esc(expr)
    opfun = esc(expr.args[2])

    quote @implement_binary_op($opfun, $Optype) end
end