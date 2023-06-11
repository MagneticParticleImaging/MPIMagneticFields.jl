using MPIMagneticFields
using Test
using Aqua
using JuliaFormatter
using LinearAlgebra

isCIRun =
  haskey(ENV, "GITHUB_ACTIONS") ||
  haskey(ENV, "TRAVIS") ||
  haskey(ENV, "CIRCLECI") ||
  haskey(ENV, "GITLAB_CI")

@testset "MPIMagneticFields.jl" begin
  @testset "Formatting" begin
    formatted = format(pwd(); verbose = false)

    if !formatted && !isCIRun
      @info "Please re-run tests since now everything should be formatted."
    end
    @test formatted == true
  end

  @testset "Aqua" begin
    Aqua.test_all(MPIMagneticFields)
  end

  include("Type.jl")
  include("Traits.jl")
  include("Common.jl")
  include("Superposition.jl")
  include("CommonFields/CommonFields.jl")
  include("Experimental.jl")
end
