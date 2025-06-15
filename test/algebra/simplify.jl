@var x R
@var z C
@var A Matrix{Real}
@var B Matrix{Real}

@testset "associative" begin
    @test isequal((x + 1) + z, x + (1 + z))
    @test isequal((x * 2) * z, x * (2 * z))
end

@testset "commutative" begin
    @test isequal(x + 1 + z, z + 1 + x)
    @test isequal(x * 2 * z, z * 2 * x)
    @test !isequal(A * B, B * A)
    @test isequal(A * x^2 * B, A * x * B * x)
end

@testset "constants combine" begin
    @test isequal(x + z + 3, x + 2 + z + 1)
    @test isequal(x + π + z + 1, Sum(sort([x, z, Literal(π), Literal(1)])))
end

@testset "compound" begin
    @test isequal(simplify(Prod(z, Sum(2x, 2x))), 4x*z)
end

@testset "square" begin
    @test isequal(x * x, x^2)
    @test isequal(x^2 * y * x^2, y * x^4)
    @test isequal(x * x * x, x^3)
end