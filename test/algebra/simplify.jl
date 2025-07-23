function simplify_equal(a, b)
    A = simplify(a)
    B = simplify(b)

    isequal(A, B) || "$A == $B"
end

function simplify_unequal(a, b)
    A = simplify(a)
    B = simplify(b)

    !isequal(A, B) || "$A != $B"
end

@var x R
@var z C
@var A Matrix{Real}
@var B Matrix{Real}

@testset "associative" begin
    @test simplify_equal((x + 1) + z, x + (1 + z))
    @test simplify_equal((x * 2) * z, x * (2 * z))
end

@testset "commutative" begin
    @test simplify_equal(x + 1 + z, z + 1 + x)
    @test simplify_equal(x * 2 * z, z * 2 * x)
    @test simplify_unequal(A * B, B * A)
    @test simplify_equal(A * x^2 * B, A * x * B * x)
end

@testset "constants combine" begin
    @test simplify_equal(x + z + 3, x + 2 + z + 1)
    @test simplify_equal(x + π + z + 1, Sum(sort([x, z, Literal(π), Literal(1)])))
end

@testset "compound" begin
    @test simplify_equal(z * (2x + 2x), 4x*z)
end

@testset "square" begin
    @test simplify_equal(x * x, x^2)
    @test simplify_equal(x^2 * y * x^2, y * x^4)
    @test simplify_equal(x * x * x, x^3)
end

@testset "polynomials" begin
    @test simplify_equal(x^2 + x + x^2 + 3 + 2 * x^2, 4 * x^2 + x + 3)
end

@testset "equality" begin
    @test simplify_equal((x == y) & (y == 1), (x == y) & (x == 1))
    @test simplify_equal((x == 1) & (x == 2), Literal(false))
end