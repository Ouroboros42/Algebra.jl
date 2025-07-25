using Algebra
using Test
using Glob

function test_directory(dirpath)
    for testfile in glob("$dirpath/*.jl")
        @testset "$testfile" begin
            include(testfile)
        end
    end
end

@testset "Algebra" begin
    @testset "util tests" begin
        test_directory("util")
    end

    @testset "algebra tests" begin
        @var x R
        @var y, z C
        @var A, B Matrix{Real}
        @var c, d Bool

        test_directory("algebra")
    end
end
