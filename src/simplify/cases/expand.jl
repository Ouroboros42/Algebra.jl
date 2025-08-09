function trycombine(simplifier, ::Type{<:Prod}, sum1::Sum, sum2::Sum)
    if expands(simplifier)
        Sum(map(Prod, Iterators.product(args(sum1), args(sum2))))
    end
end