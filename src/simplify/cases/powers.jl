matchingforms(simplifier, outer::Type{<:Prod}, power::Pow, single::Expression) = (single ^ ONE,)

function trycombine(simplifier, outer::Type{<:Prod}, expr1::Expression, expr2::Expression)
    @tryreturn @invoke trycombine(simplifier, outer::Type{<:Compound}, expr1, expr2)

    if isvalid(Pow, expr1, TWO) && isequal(expr1, expr2)
        return Pow(expr1, TWO)
    end
end

function trycombine(simplifier, outer::Type{<:Pow}, base::Expression, exponent::Expression)
    @tryreturn @invoke trycombine(simplifier, outer::Type{<:Compound}, base, exponent)

    if isone(exponent); return base end
    if iszero(exponent); return one(base) end

    if isone(base); return base end
    if iszero(base); return ifelse(exponent == zero(exponent), one(base), base) end
end

function trycombine(simplifier, outer::Type{<:Pow}, base::Pow, outerexp::Expression)
    @tryreturn @invoke trycombine(simplifier, outer, base::Expression, outerexp)

    innerbase, innerexp = base

    if isinteger(outerexp) || (isreal(innerexp) && ispositive(innerbase))
        innerbase ^ (innerexp * outerexp)
    end
end

function trycombine(simplifier, outer::Type{<:Pow}, base::Prod, exponent::Expression)
    @tryreturn @invoke trycombine(simplifier, outer, base::Expression, exponent)
    
    separable, inseparable = partition(arg -> iscentral(Prod, arg) && (isinteger(exponent) || ispositive(arg)), args(base))

    if isempty(separable); return end

    separated = prod(x->x^exponent, separable)

    if isempty(inseparable); return separated end

    separated * prod(inseparable) ^ exponent
end

function trycombine(simplifier, outer::Type{<:Prod}, pow1::Pow, pow2::Pow)
    (base1, exponent1) = pow1
    (base2, exponent2) = pow2

    if isequal(base1, base2)
        @tryreturn mapsome(matchtrycombine(simplifier, Sum, exponent1, exponent2)) do newexponent
            base1 ^ newexponent
        end
    end

    if isequal(exponent1, exponent2)
        if isinteger(exponent1) || (ispositive(base1) && ispositive(base2)) 
            @tryreturn mapsome(matchtrycombine(simplifier, Prod, base1, base2)) do newbase
                newbase ^ exponent1
            end
        end
    end

    @tryreturn @invoke trycombine(simplifier, outer, pow1::Expression, pow2::Expression)
end