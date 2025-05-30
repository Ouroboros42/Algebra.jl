(::Type{A})(arguments...) where {A <: Associative} = A(map(express, arguments)...)
# (::Type{F})(arguments...) where {F <: NFunc} = F(map(express, arguments)...)
