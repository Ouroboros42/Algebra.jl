@var x R
@var y C

@testset "iszero tests" begin
    @test iszero(Literal(0))
    @test iszero(Literal(0.0))
    @test iszero(Literal(0.0 + 0im))
    @test iszero(Literal(0//3))
    @test !iszero(Literal(0.1))
    @test !iszero(Literal(π))
    @test !iszero(x + 1)
    @test !iszero(y + x)
end

@testset "isone tests" begin
    @test isone(Literal(1))
    @test isone(Literal(1.0))
    @test isone(Literal(3//3))
    @test isone(Literal(1 + 0im))
    @test !isone(Literal(π))
    @test !isone(x + 1)
    @test !isone(y + x)
end