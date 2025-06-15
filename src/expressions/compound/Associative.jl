"""
An associative operation, labelled by `Op`, which is usually the equivalent julia function. 
"""
struct Associative{Op, T, Commutes} <: CompoundExpression{T}
    arguments::Vector{Expression}
end

Associative{Op, T}(arguments) where {Op, T} = Associative{Op, T, allcommute(Op, arguments)}(arguments)
Associative{Op}(arguments) where Op = Associative{Op, assoc_valtype(Op, arguments)}(arguments)
Associative{Op}(arguments::Expression...) where Op = Associative{Op, assoc_valtype(Op, arguments)}(collect(arguments))

similar(::Associative{Op}, arguments...) where Op = Associative{Op}(arguments...)
args(operation::Associative) = operation.arguments

isequal(first::Associative{Op}, second::Associative{Op}) where Op = isequal(args(first), args(second))
isless(first::Associative{Op}, second::Associative{Op}) where Op = isless(args(first), args(second))

commuterule(Op, first::Expression, second::Expression) = isequal(first, second)
iscentral(Op, element::Expression) = isidentity(Op, element)
function commutesunder(Op, first::Expression, second::Expression)
    iscentral(Op, first) || iscentral(Op, second) || commuterule(Op, first, second) || commuterule(Op, second, first)
end
allcommute(Op, args) = all(x -> iscentral(Op, x), args)

iscommutative(::Associative{Op, T, Commutes}) where {Op, T, Commutes} = Commutes 

hasidentity(Op) = false

isidentity(Op, ::Expression) = false
isidentity(::Associative{Op}) where Op = element -> isidentity(Op, element)

function print(io::IO, (; arguments)::Associative{Op}) where Op
    if isempty(arguments)
        return print(io, "`EMPTY $Op`")
    end

    args = join(map(string, arguments), " $Op ")

    print(io, "($args)")
end
