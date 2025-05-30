(A::Type{<:Associative})(arguments...) = A(map(express, arguments)...)
(F::Type{<:NFunc})(arguments...) = F(map(express, arguments)...)
