import Base: +, *, ^

macro implement_binary_op(Optype, opfun)
    Optype = esc(Optype)
    opfun = esc(opfun)

    quote
        $opfun(args::Expression...) = simplify($Optype(args...))

        $opfun(expr::Expression, value) = $opfun(expr, express(value))
        $opfun(value, expr::Expression) = $opfun(express(value), expr)
    end
end

macro implement_assoc_op(opfun)
    opfun = esc(opfun)

    quote
        @implement_binary_op(Associative{$opfun}, $opfun)
    end
end

macro implement_binary_op(opfun)
    opfun = esc(opfun)

    quote
        @implement_binary_op(NFunc{$opfun, 2}, $opfun)
    end
end

@implement_assoc_op(+)
@implement_assoc_op(*)
@implement_binary_op(^)