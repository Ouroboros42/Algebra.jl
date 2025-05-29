using Algebra: Literal

@testset "Type Conversion" begin
    @test isequal(convert(Expression, 1), Literal(1))
    @test isequal(convert(Expression, Literal(1)), Literal(1))
    @test isequal(Literal(2) + Literal(1), Literal(2) + 1)
    @test isequal(Literal(2) + Literal(1.), Literal(2) + 1.)
    @test isequal(Literal(1.) + Literal(2), 1. + Literal(2))
end