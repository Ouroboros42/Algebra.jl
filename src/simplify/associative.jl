toargs(type::Type{A}, expr::Expression{T}) where {T, Op, A <: AssociativeOperation{Op, T}} = [ expr ]
toargs(type::Type{A}, expr::A) where {T, Op, A <: AssociativeOperation{Op, T}} = expr.arguments
toargs(type::Type{A}) where {A <: AssociativeOperation} = expr -> toargs(type, expr) 

function flatten(operation::A) where {T, Op, A <: AssociativeOperation{Op, T}}
    A(collect(Iterators.flatmap(toargs(A), operation.arguments)))
end

@extendnullable function trysimplify(operation::A, simplifier::Trivial) where {Op, A <: AssociativeOperation{Op}}
    if any(isinst(A), operation.arguments)
        return flatten(operation)
    end
end

@extendnullable function trysimplify(operation::A, simplifier::Trivial) where {Op, A <: AssociativeOperation{Op}}
    if !iscommutative(A); return end

    # TODO Add sort for expressions

    return
end