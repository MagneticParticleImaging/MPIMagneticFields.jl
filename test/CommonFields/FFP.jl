@testset "IdealFFP" begin
  field = IdealFFP([-1,-1,2])

  @test fieldType(field) isa GradientField
  @test definitionType(field) isa MethodBasedFieldDefinition
  @test timeDependencyType(field) isa TimeConstant
  @test gradientFieldType(field) isa FFPGradientField

  @test all(value(field, [0.5, 0, 0]) .≈ [-0.5, 0, 0])
  @test all(value(field, [0.5, 0.5, 0.5]) .≈ [-0.5, -0.5, 1])
end