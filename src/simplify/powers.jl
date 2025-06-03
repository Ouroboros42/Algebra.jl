function trycombine(simplifier::Simplifier, ::typeof(*), (base1, exponent1)::Pow, (base2, exponent2)::Pow)
    if isequal(base1, base2)
        @tryreturn mapsome(trycombine(simplifier, +, exponent1, exponent2)) do newexponent
            Pow(base1, newexponent)
        end
    end

    if isequal(exponent1, exponent2)
        if isinteger(exponent1) || (ispositive(base1) && ispositive(base2)) 
            @tryreturn mapsome(trycombine(simplifier, *, base1, base2)) do newbase
                Pow(newbase, exponent1)
            end
        end
    end
end

function trycombine(simplifier::MergeSame, Op::typeof(*), pow1::Pow, pow2::Pow)
    @tryreturn @invoke trycombine(simplifier, Op, pow1::Expression, pow2::Expression)
    @tryreturn @invoke trycombine(simplifier::Simplifier, Op, pow1, pow2)
end

function trycombine(simplifier::Simplifier, Op, power::Pow, single::Expression)
    trycombine(simplifier, Op, power, Pow(single, ONE))
end

function trycombine(simplifier::Simplifier, Op, single::Expression, power::Pow)
    trycombine(simplifier, Op, Pow(single, ONE), power)
end

trycombine(simplifier::Simplifier, Op, pow1::Pow, pow2::Pow) = @invoke trycombine(simplifier, Op, pow1::Expression, pow2::Expression)
trycombine(simplifier::MergeSame, Op::RepeatableOps, power::Pow, single::Expression) = @invoke trycombine(simplifier::Simplifier, Op, power, single)
trycombine(simplifier::MergeSame, Op::RepeatableOps, single::Expression, power::Pow) = @invoke trycombine(simplifier::Simplifier, Op, single, power)