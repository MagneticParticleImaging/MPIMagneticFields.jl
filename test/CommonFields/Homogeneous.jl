@testset "HomogeneousField" begin
  @testset "IdealHomogeneousField" begin
    field = IdealHomogeneousField([1, 0, 0])

    @test FieldStyle(field) isa HomogeneousField
    @test FieldDefinitionStyle(field) isa MethodBasedFieldDefinition
    @test FieldTimeDependencyStyle(field) isa TimeConstant
    @test isTimeVarying(field) == false
    @test FieldMovementStyle(field) isa NoMovement
    @test isRotatable(field) == false
    @test isTranslatable(field) == false

    @test all(value(field, [1, 0, 0]) .≈ [1, 0, 0])
    @test all(value(field, [0.5, 0, 0]) .≈ [1, 0, 0])
  end

  @testset "IdealXYRotatedHomogeneousField" begin
    field = IdealXYRotatedHomogeneousField(1)

    @test FieldStyle(field) isa HomogeneousField
    @test FieldDefinitionStyle(field) isa MethodBasedFieldDefinition
    @test FieldTimeDependencyStyle(field) isa TimeConstant
    @test isTimeVarying(field) == false
    @test FieldMovementStyle(field) isa RotationalMovement
    @test isRotatable(field) == true
    @test isTranslatable(field) == false

    @test all(value(field, [1, 0, 0], 0) .≈ [0, 1, 0])
    @test all(value(field, [0.5, 0, 0], 0) .≈ [0, 1, 0])

    @test all(isapprox.(value(field, [1, 0, 0], π/2), [1, 0, 0], atol=1e-10))
    @test all(isapprox.(value(field, [0.5, 0, 0], π/2), [1, 0, 0], atol=1e-10))
  end
end