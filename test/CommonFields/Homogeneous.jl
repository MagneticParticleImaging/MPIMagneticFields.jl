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
  
  @testset "FunctionDefinedHomogeneousField" begin
    field = FunctionDefinedHomogeneousField(t -> [0, 1t, 2t])

    @test FieldStyle(field) isa HomogeneousField
    @test FieldDefinitionStyle(field) isa MethodBasedFieldDefinition
    @test FieldTimeDependencyStyle(field) isa TimeVarying
    @test isTimeVarying(field) == true
    @test FieldMovementStyle(field) isa NoMovement
    @test isRotatable(field) == false
    @test isTranslatable(field) == false

    @test all(value(field, 0, [1, 0, 0]) .≈ [0, 0, 0])
    @test all(value(field, 1, [1, 0, 0]) .≈ [0, 1, 2])
    @test all(value(field, 0, [0.5, 0, 0]) .≈ [0, 0, 0])
    @test all(value(field, 1, [0.5, 0, 0]) .≈ [0, 1, 2])
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
    @test RotationalDimensionalityStyle(field) isa RotationalDimensionalityStyle{OneDimensional}

    @test all(value(field, [1, 0, 0], 0) .≈ [0, 1, 0])
    @test all(value(field, [0.5, 0, 0], 0) .≈ [0, 1, 0])

    @test all(isapprox.(value(field, [1, 0, 0], π / 2), [1, 0, 0], atol = 1e-10))
    @test all(isapprox.(value(field, [0.5, 0, 0], π / 2), [1, 0, 0], atol = 1e-10))
  end

  @testset "IdealXZRotatedHomogeneousField" begin
    field = IdealXZRotatedHomogeneousField(1)

    @test FieldStyle(field) isa HomogeneousField
    @test FieldDefinitionStyle(field) isa MethodBasedFieldDefinition
    @test FieldTimeDependencyStyle(field) isa TimeConstant
    @test isTimeVarying(field) == false
    @test FieldMovementStyle(field) isa RotationalMovement
    @test isRotatable(field) == true
    @test isTranslatable(field) == false
    @test RotationalDimensionalityStyle(field) isa RotationalDimensionalityStyle{OneDimensional}

    @test all(value(field, [1, 0, 0], 0) .≈ [0, 0, 1])
    @test all(value(field, [0.5, 0, 0], 0) .≈ [0, 0, 1])

    @test all(isapprox.(value(field, [1, 0, 0], π / 2), [1, 0, 0], atol = 1e-10))
    @test all(isapprox.(value(field, [0.5, 0, 0], π / 2), [1, 0, 0], atol = 1e-10))
  end

  @testset "IdealYZRotatedHomogeneousField" begin
    field = IdealYZRotatedHomogeneousField(1)

    @test FieldStyle(field) isa HomogeneousField
    @test FieldDefinitionStyle(field) isa MethodBasedFieldDefinition
    @test FieldTimeDependencyStyle(field) isa TimeConstant
    @test isTimeVarying(field) == false
    @test FieldMovementStyle(field) isa RotationalMovement
    @test isRotatable(field) == true
    @test isTranslatable(field) == false
    @test RotationalDimensionalityStyle(field) isa RotationalDimensionalityStyle{OneDimensional}

    @test all(value(field, [1, 0, 0], 0) .≈ [0, 0, 1])
    @test all(value(field, [0.5, 0, 0], 0) .≈ [0, 0, 1])

    @test all(isapprox.(value(field, [1, 0, 0], π / 2), [0, 1, 0], atol = 1e-10))
    @test all(isapprox.(value(field, [0.5, 0, 0], π / 2), [0, 1, 0], atol = 1e-10))
  end

  @testset "IdealXYRotatedTranslatedHomogeneousField" begin
    field = IdealXYRotatedTranslatedHomogeneousField()

    @test FieldStyle(field) isa HomogeneousField
    @test FieldDefinitionStyle(field) isa MethodBasedFieldDefinition
    @test FieldTimeDependencyStyle(field) isa TimeConstant
    @test isTimeVarying(field) == false
    @test FieldMovementStyle(field) isa RotationalTranslationalMovement
    @test isRotatable(field) == true
    @test isTranslatable(field) == true
    @test RotationalDimensionalityStyle(field) isa RotationalDimensionalityStyle{OneDimensional}
    @test TranslationalDimensionalityStyle(field) isa TranslationalDimensionalityStyle{OneDimensional}

    @test all(value(field, [1, 0, 0], 0, 1) .≈ [0, 1, 0])
    @test all(value(field, [0.5, 0, 0], 0, 1) .≈ [0, 1, 0])

    @test all(isapprox.(value(field, [1, 0, 0], π / 2, 1), [1, 0, 0], atol = 1e-10))
    @test all(isapprox.(value(field, [0.5, 0, 0], π / 2, 1), [1, 0, 0], atol = 1e-10))

    @test all(value(field, [1, 0, 0], 0, 2) .≈ [0, 2, 0])
    @test all(value(field, [0.5, 0, 0], 0, 2) .≈ [0, 2, 0])

    @test all(isapprox.(value(field, [1, 0, 0], π / 2, 2), [2, 0, 0], atol = 1e-10))
    @test all(isapprox.(value(field, [0.5, 0, 0], π / 2, 2), [2, 0, 0], atol = 1e-10))
  end
  
  @testset "IdealXZRotatedTranslatedHomogeneousField" begin
    field = IdealXZRotatedTranslatedHomogeneousField()

    @test FieldStyle(field) isa HomogeneousField
    @test FieldDefinitionStyle(field) isa MethodBasedFieldDefinition
    @test FieldTimeDependencyStyle(field) isa TimeConstant
    @test isTimeVarying(field) == false
    @test FieldMovementStyle(field) isa RotationalTranslationalMovement
    @test isRotatable(field) == true
    @test isTranslatable(field) == true
    @test RotationalDimensionalityStyle(field) isa RotationalDimensionalityStyle{OneDimensional}
    @test TranslationalDimensionalityStyle(field) isa TranslationalDimensionalityStyle{OneDimensional}

    @test all(value(field, [1, 0, 0], 0, 1) .≈ [0, 0, 1])
    @test all(value(field, [0.5, 0, 0], 0, 1) .≈ [0, 0, 1])

    @test all(isapprox.(value(field, [1, 0, 0], π / 2, 1), [1, 0, 0], atol = 1e-10))
    @test all(isapprox.(value(field, [0.5, 0, 0], π / 2, 1), [1, 0, 0], atol = 1e-10))

    @test all(value(field, [1, 0, 0], 0, 2) .≈ [0, 0, 2])
    @test all(value(field, [0.5, 0, 0], 0, 2) .≈ [0, 0, 2])

    @test all(isapprox.(value(field, [1, 0, 0], π / 2, 2), [2, 0, 0], atol = 1e-10))
    @test all(isapprox.(value(field, [0.5, 0, 0], π / 2, 2), [2, 0, 0], atol = 1e-10))
  end

  @testset "IdealYZRotatedTranslatedHomogeneousField" begin
    field = IdealYZRotatedTranslatedHomogeneousField()

    @test FieldStyle(field) isa HomogeneousField
    @test FieldDefinitionStyle(field) isa MethodBasedFieldDefinition
    @test FieldTimeDependencyStyle(field) isa TimeConstant
    @test isTimeVarying(field) == false
    @test FieldMovementStyle(field) isa RotationalTranslationalMovement
    @test isRotatable(field) == true
    @test isTranslatable(field) == true
    @test RotationalDimensionalityStyle(field) isa RotationalDimensionalityStyle{OneDimensional}
    @test TranslationalDimensionalityStyle(field) isa TranslationalDimensionalityStyle{OneDimensional}

    @test all(value(field, [1, 0, 0], 0, 1) .≈ [0, 0, 1])
    @test all(value(field, [0.5, 0, 0], 0, 1) .≈ [0, 0, 1])

    @test all(isapprox.(value(field, [1, 0, 0], π / 2, 1), [0, 1, 0], atol = 1e-10))
    @test all(isapprox.(value(field, [0.5, 0, 0], π / 2, 1), [0, 1, 0], atol = 1e-10))

    @test all(value(field, [1, 0, 0], 0, 2) .≈ [0, 0, 2])
    @test all(value(field, [0.5, 0, 0], 0, 2) .≈ [0, 0, 2])

    @test all(isapprox.(value(field, [1, 0, 0], π / 2, 2), [0, 2, 0], atol = 1e-10))
    @test all(isapprox.(value(field, [0.5, 0, 0], π / 2, 2), [0, 2, 0], atol = 1e-10))
  end
end
