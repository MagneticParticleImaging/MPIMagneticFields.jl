using MPIMagneticFields
using Test
using Aqua

@testset "MPIMagneticFields.jl" begin
  @testset "Aqua" begin
    Aqua.test_all(MPIMagneticFields, ambiguities=false)
  end


end
