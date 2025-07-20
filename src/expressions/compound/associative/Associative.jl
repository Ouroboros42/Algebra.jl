"""
An associative operation, labelled by `Op`, which is usually the equivalent julia function. 
"""
struct Associative{Op, T} <: Compound{T}
    arguments::Vector{Expression}
end

Associative{Op}(arguments) where Op = Associative{Op, assoc_valtype(Op, arguments)}(arguments)
Associative{Op}(arguments::Expression...) where Op = Associative{Op, assoc_valtype(Op, arguments)}(collect(arguments))
(A::Type{<:Associative})(arguments...) = A(map(Expression, arguments)...)

optype(::Type{<:Associative{Op}}) where Op = Associative{Op}

args(operation::Associative) = operation.arguments

replacesomeargs(operation::Associative, replacements...) = similar(operation, replacesome(args(operation), replacements...))

isequal(first::Associative{Op}, second::Associative{Op}) where Op = isequal(args(first), args(second))
isless(first::Associative{Op}, second::Associative{Op}) where Op = isless(args(first), args(second))

isidentity(Op, ::Expression) = false
isidentity(::Associative{Op}) where Op = element -> isidentity(Op, element)

isabsorbing(Op, ::Expression) = false
isabsorbing(::Associative{Op}) where Op = element -> isabsorbing(Op, element)

iscentral(Op, element::Expression) = isidentity(Op, element) || isabsorbing(Op, element)
iscentral(::Associative{Op}) where Op = element -> iscentral(Op, element)

isplitargs(operation::Associative) = ipartition(iscentral(operation), operation.arguments)

function print(io::IO, (; arguments)::Associative{Op}) where Op
    if isempty(arguments)
        return print(io, "`EMPTY $Op`")
    end

    args = join(map(string, arguments), " $Op ")

    print(io, "($args)")
end

struct CentralFirst{Op} <: Ordering end

CentralFirst(::Associative{Op}) where Op = CentralFirst{Op}()

function Order.lt(::CentralFirst{Op}, a::Expression, b::Expression) where Op
    if !iscentral(Op, a); return false end

    if !iscentral(Op, b); return true end

    isless(a, b)
end
