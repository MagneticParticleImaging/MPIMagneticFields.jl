@testset "IdealFFP" begin
  field = IdealFFP([-1, -1, 2])

  @test FieldStyle(field) isa GradientField
  @test FieldDefinitionStyle(field) isa MethodBasedFieldDefinition
  @test FieldTimeDependencyStyle(field) isa TimeConstant
  @test GradientFieldStyle(field) isa FFPGradientField

  @test all(value(field, [0.5, 0, 0]) .≈ [-0.5, 0, 0])
  @test all(value(field, [0.5, 0.5, 0.5]) .≈ [-0.5, -0.5, 1])
end
