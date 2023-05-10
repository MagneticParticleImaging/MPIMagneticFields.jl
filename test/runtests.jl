using MPIMagneticFields
using Test
using Aqua
using LinearAlgebra

@testset "MPIMagneticFields.jl" begin
  @testset "Aqua" begin
    Aqua.test_all(MPIMagneticFields)
  end

  include("Type.jl")
  include("Traits.jl")
  include("Common.jl")
  include("Superposition.jl")
  include("CommonFields/CommonFields.jl")
end
