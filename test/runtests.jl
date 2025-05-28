using Algebra
using Test
using Glob

@testset "Algebra" begin
    @testset "utiltests.jl" begin
        include("utiltests.jl")
    end

    @testset "algebra tests" begin
        for testfile in glob("algebra/*.jl")
            @testset "$testfile" begin
                include(testfile)
            end
        end
    end
end
