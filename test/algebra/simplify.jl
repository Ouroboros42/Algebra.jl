@var x R
@var z C

@testset "associative" begin
    @test isequal((x + 1) + z, x + (1 + z))
    @test isequal((x * 2) * z, x * (2 * z))
end

@testset "commutative" begin
    @test isequal(x + 1 + z, z + 1 + x)
    @test isequal(x * 2 * z, z * 2 * x)
end

@testset "constants combine" begin
    @test isequal(x + z + 3, x + 2 + z + 1)
    @test isequal(x + π + z + 1, Sum(sort([x, z, Literal(π), Literal(1)])))
end

@testset "compound" begin
    @test isequal(simplify(Prod(y, Sum(2x, 2x))), 4x*y)
end