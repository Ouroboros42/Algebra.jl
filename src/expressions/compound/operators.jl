function mixed_bit_combinations(nbits)
    """Return an iterator of all combinations of `nbits` bits, excluding all false and all true."""
    ints = 1:(2^nbits-2)

    Iterators.map(i -> digits(Bool, i, base = 2, pad = nbits), ints)
end

macro extend_op(opfun, nargs = 2)
    opfun = esc(opfun)

    argnames = map(i -> Symbol("arg$i"), 1:nargs)

    funcdefs = map(mixed_bit_combinations(nargs)) do whichexprs
        opdefargs = map(argnames, whichexprs) do argname, isexpr
            isexpr ? :($argname::Expression) : argname
        end

        opdef = Expr(:call, opfun, opdefargs...)

        opcallargs = map(argnames, whichexprs) do argname, isexpr
            isexpr ? argname : :(Expression($argname))
        end

        opcall = Expr(:call, opfun, opcallargs...)

        Expr(:(=), opdef, opcall)
    end

    Expr(:block, funcdefs...)
end

macro implement_op(opfun, Optype, nargs)
    opfun = esc(opfun)
    Optype = esc(Optype)

    quote
        $opfun(args::Expression...) = $Optype(args...)
        @extend_op($opfun, $nargs)
        
        $Optype
    end 
end

macro operator(expr::Expr, nargs = get(expr.args, 3, 2))
    if expr.head !== :curly || length(expr.args) < 2
        throw(ArgumentError("Malformed operator Expression type: $expr"))
    end

    Optype = esc(expr)
    opfun = esc(expr.args[2])

    :( @implement_op($opfun, $Optype, $nargs) )
end