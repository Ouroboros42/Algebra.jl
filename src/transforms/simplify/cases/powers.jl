function tryapply(::Trivial, (base, exponent)::Pow)
    if iszero(exponent); return one(base) end

    if isone(exponent); return base end

    if isone(base); return base end

    # TODO handle zero base
end

function tryapply(simplifier::Trivial, power::Pow{T, <:Tuple{Pow, Expression}}) where T
    @tryreturn @invoke tryapply(simplifier, power::Pow)

    ((base, exp1), exp2) = power

    if isinteger(exp2) || (isreal(exp1) && ispositive(base))
        base ^ (exp1 * exp2)
    end
end

function trycombine(simplifier::Simplifier, ::Type{<:Prod}, (base1, exponent1)::Pow, (base2, exponent2)::Pow)
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
end

function trycombine(simplifier::Trivial, outer::Type{<:Prod}, pow1::Pow, pow2::Pow)
    @tryreturn @invoke trycombine(simplifier, outer, pow1::Expression, pow2::Expression)
    @tryreturn @invoke trycombine(simplifier::Simplifier, outer, pow1, pow2)
end

matchingforms(::Simplifier, outer::Type{<:Prod}, power::Pow, single::Expression) = (single ^ ONE,)