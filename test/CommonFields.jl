@testset "CommonFields" begin
  @testset "IdealFFP" begin
    field = IdealFFP(1)

    @test fieldType(field) isa GradientField
    @test definitionType(field) isa MethodBasedFieldDefinition
    @test timeDependencyType(field) isa TimeConstant
    @test gradientFieldType(field) isa FFPGradientField

    @test all(value(field, [0.5, 0, 0]) .≈ [0.5, 0, 0])
    @test all(value(field, [0, 0.5, 0]) .≈ [0, 0.5, 0])
  end

  @testset "IdealFFL" begin
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

  @testset "IdealHomogeneousField" begin
    field = IdealHomogeneousField(1, [1, 0, 0])

    @test fieldType(field) isa HomogeneousField
    @test definitionType(field) isa MethodBasedFieldDefinition
    @test timeDependencyType(field) isa TimeConstant
    @test isTimeVarying(field) == false
    @test fieldMovementType(field) isa NoMovement
    @test isRotatable(field) == false
    @test isTranslatable(field) == false

    @test all(value(field, [1, 0, 0]) .≈ [1, 0, 0])
    @test all(value(field, [0.5, 0, 0]) .≈ [1, 0, 0])
  end

  @testset "IdealXYRotatedHomogeneousField" begin
    field = IdealXYRotatedHomogeneousField(1)

    @test fieldType(field) isa HomogeneousField
    @test definitionType(field) isa MethodBasedFieldDefinition
    @test timeDependencyType(field) isa TimeConstant
    @test isTimeVarying(field) == false
    @test fieldMovementType(field) isa RotationalMovement
    @test isRotatable(field) == true
    @test isTranslatable(field) == false

    @test all(value(field, [1, 0, 0]) .≈ [0, 1, 0])
    @test all(value(field, [0.5, 0, 0]) .≈ [0, 1, 0])

    @test all(isapprox.(value(field, [1, 0, 0], π/2), [1, 0, 0], atol=1e-10))
    @test all(isapprox.(value(field, [0.5, 0, 0], π/2), [1, 0, 0], atol=1e-10))
  end
end