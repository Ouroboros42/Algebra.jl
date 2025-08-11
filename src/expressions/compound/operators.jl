function mixed_bit_combinations(nbits, include_all = false, include_none = false)
    """Return an iterator of all combinations of `nbits` bits, excluding all false and all true."""

    start = ifelse(include_none, 0, 1)
    stop = 2^nbits - ifelse(include_all, 1, 2)

    Iterators.map(i -> digits(Bool, i, base = 2, pad = nbits), start:stop)
end

macro extend_op(opfun, nargs = 2, callfun = opfun, include_base = false)
    opfun = esc(opfun)

    argnames = map(_ -> gensym(:oparg), 1:nargs)

    funcdefs = map(mixed_bit_combinations(nargs, include_base)) do whichexprs
        opdefargs = map(argnames, whichexprs) do argname, isexpr
            isexpr ? :($argname::Expression) : argname
        end

        opdef = Expr(:call, opfun, opdefargs...)

        opcallargs = map(argnames, whichexprs) do argname, isexpr
            isexpr ? argname : :(Expression($argname))
        end

        opcall = Expr(:call, callfun, opcallargs...)

        Expr(:(=), opdef, opcall)
    end

    Expr(:block, funcdefs...)
end

macro implement_op(opfun, Optype, nargs)
    opfun = esc(opfun)
    Optype = esc(Optype)

    quote
        @extend_op($opfun, $nargs, $Optype, true)
        
        $Optype
    end 
end

macro operator(expr::Expr, nargs = @ordefault(firstornothing(isinst(Integer), expr.args), 2))
    if expr.head !== :curly || length(expr.args) < 2
        throw(ArgumentError("Malformed operator Expression type: $expr"))
    end

    Optype = esc(expr)
    opfun = esc(expr.args[2])

    :( @implement_op($opfun, $Optype, $nargs) )
end