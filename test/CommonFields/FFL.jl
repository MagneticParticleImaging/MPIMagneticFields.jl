@testset "IdealXYFFL" begin
  field = IdealXYFFL(1)

  @test fieldType(field) isa GradientField
  @test definitionType(field) isa MethodBasedFieldDefinition
  @test timeDependencyType(field) isa TimeConstant
  @test gradientFieldType(field) isa FFLGradientField
  @test fieldMovementType(field) isa RotationalMovement
  @test isRotatable(field) == true

  @test all(value(field, [0.5, 0, 0]) .≈ [0, 0, 0])
  @test all(value(field, [0, 0.5, 0]) .≈ [0, -0.5, 0])

  @test all(isapprox.(value(field, [0.5, 0, 0], π/2), [-0.5, 0, 0], atol=1e-10))
  @test all(isapprox.(value(field, [0, 0.5, 0], π/2), [0, 0, 0], atol=1e-10))
end