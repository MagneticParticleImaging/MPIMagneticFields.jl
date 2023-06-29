@testset "IdealXYRotatedFFL" begin
  field = IdealXYRotatedFFL(1)

  @test FieldStyle(field) isa GradientField
  @test FieldDefinitionStyle(field) isa MethodBasedFieldDefinition
  @test FieldTimeDependencyStyle(field) isa TimeConstant
  @test GradientFieldStyle(field) isa FFLGradientField
  @test FieldMovementStyle(field) isa RotationalMovement
  @test isRotatable(field) == true

  @test all(value(field, [0.5, 0, 0], 0) .≈ [0, 0, 0])
  @test all(value(field, [0, 0.5, 0], 0) .≈ [0, 0.5, 0])

  @test all(isapprox.(value(field, [0.5, 0, 0], π / 2), [0.5, 0, 0], atol = 1e-10))
  @test all(isapprox.(value(field, [0, 0.5, 0], π / 2), [0, 0, 0], atol = 1e-10))
end

@testset "IdealXYRotatedTranslatedFFL" begin
  field = IdealXYRotatedTranslatedFFL(1)

  @test FieldStyle(field) isa GradientField
  @test FieldDefinitionStyle(field) isa MethodBasedFieldDefinition
  @test FieldTimeDependencyStyle(field) isa TimeConstant
  @test GradientFieldStyle(field) isa FFLGradientField
  @test FieldMovementStyle(field) isa RotationalTranslationalMovement
  @test isRotatable(field) == true

  @test all(value(field, [0.5, 0, 0], 0, 0) .≈ [0, 0, 0])
  @test all(value(field, [0, 0.5, 0], 0, 0) .≈ [0, 0.5, 0])

  @test all(isapprox.(value(field, [0.5, 0, 0], π / 2, 0), [0.5, 0, 0], atol = 1e-10))
  @test all(isapprox.(value(field, [0, 0.5, 0], π / 2, 0), [0, 0, 0], atol = 1e-10))
end
