function trycombine(simplifier, ::Type{<:Pow}, base::Expression, exponent::Expression)
    if iszero(exponent); return one(base) end

    if isone(exponent); return base end

    if isone(base); return base end

    # TODO handle zero base
end

trycombine(simplifier, outer::Type{<:Pow}, base::Literal, exponent::Literal) = @invoke trycombine(simplifier, outer::Type{<:Compound}, base, exponent)

function trycombine(simplifier, outer::Type{<:Pow}, base::Pow, outerexp::Expression)
    @tryreturn @invoke trycombine(simplifier, outer, base::Expression, outerexp)

    innerbase, innerexp = base

    if isinteger(outerexp) || (isreal(innerexp) && ispositive(innerbase))
        innerbase ^ (innerexp * outerexp)
    end
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

matchingforms(simplifier, outer::Type{<:Prod}, power::Pow, single::Expression) = (single ^ ONE,)