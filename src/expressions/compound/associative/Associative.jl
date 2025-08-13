"""
An associative operation, labelled by `Op`, which is usually the equivalent julia function. 
"""
struct Associative{Op, T} <: Compound{T}
    arguments::Vector{Expression}

    Associative{Op, T}(arguments) where {Op, T} = Associative{Op, T}(vec(collect(Expression, arguments)))

    function Associative{Op, T}(arguments::Vector{Expression}) where {Op, T}
        if isempty(arguments);
            @tryreturn identity(Associative{Op, T})
        end

        @tryreturn onlyornothing(arguments)

        if any(isinst(Associative{Op}), arguments)
            return Associative{Op, T}(Iterators.flatmap(toargs(Associative{Op}), arguments))
        end

        # TODO implement a sorting algorithm that does not require a proper ordering
        sort!(arguments; order=CentralFirst{Associative{Op}}())

        new(arguments)
    end
end

toargs(assoc) = expr -> toargs(assoc, expr)
toargs(assoc::Type{<:Associative}, expr::Expression) = expr isa assoc ? args(expr) : [ expr ]
toargs(operation::Associative) = toargs(logicaltype(operation))

Associative{Op, T}(arguments, emptyvalue::Expression) where {Op, T} = isempty(arguments) ? emptyvalue : Associative{Op, T}(arguments)
Associative{Op, T}(args::Expression...) where {Op, T} = Associative{Op, T}(args)
Associative{Op}(arg1::Expression, arg2::Expression) where Op = Associative{Op, infervaltype(Associative{Op}, valtype(arg1), valtype(arg2))}(arg1, arg2)
Associative{Op}(arg::Expression) where Op = Associative{Op, valtype(arg)}(arg)

logicaltype(::Type{<:Associative{Op}}) where Op = Associative{Op}
op(operation::Associative) = op(typeof(operation))
op(::Type{<:Associative{Op}}) where Op = Op

args(operation::Associative) = operation.arguments

print(io::IO, associative::Associative) = print(io, infixstr(associative))

identity(::Type{<:Associative}) = nothing
identity(assoc::Associative) = identity(typeof(assoc))

isidentity(assoc, ::Expression) = false
isidentity(assoc::Associative) = element -> isidentity(typeof(assoc), element)

isabsorbing(assoc, ::Expression) = false
isabsorbing(assoc::Associative) = element -> isabsorbing(typeof(assoc), element)

iscentral(assoc, element::Expression) = isidentity(assoc, element) || isabsorbing(assoc, element)
iscentral(assoc::Associative) = element -> iscentral(typeof(assoc), element)

isplitargs(operation::Associative) = ipartition(iscentral(operation), operation.arguments)

struct CentralFirst{Assoc} <: Ordering end
CentralFirst(assoc::Associative) = CentralFirst{logicaltype(assoc)}()

function Order.lt(::CentralFirst{Assoc}, a::Expression, b::Expression) where Assoc
    if !iscentral(Assoc, a); return false end

    if !iscentral(Assoc, b); return true end

    isless(a, b)
end
