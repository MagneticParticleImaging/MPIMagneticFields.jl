@testset "Traits" begin
  @testset "Defaults" begin
    mutable struct TestField <: AbstractMagneticField end

    testField = TestField()

    @test FieldStyle(testField) isa OtherField
    @test FieldDefinitionStyle(testField) isa MethodBasedFieldDefinition
    @test FieldTimeDependencyStyle(testField) isa TimeConstant
    @test isnothing(GradientFieldStyle(testField))
    @test FieldMovementStyle(testField) isa NoMovement

    @test RotationalDimensionalityStyle(testField) isa RotationalDimensionalityStyle{ZeroDimensional}
    @test TranslationalDimensionalityStyle(testField) isa TranslationalDimensionalityStyle{ZeroDimensional}
  end

  @testset "Implemented rotational" begin
    mutable struct TestFieldImplemented <: AbstractMagneticField end

    MPIMagneticFields.FieldStyle(::TestFieldImplemented) = GradientField()
    MPIMagneticFields.FieldDefinitionStyle(::TestFieldImplemented) = MethodBasedFieldDefinition()
    MPIMagneticFields.FieldTimeDependencyStyle(::TestFieldImplemented) = TimeVarying()
    MPIMagneticFields.GradientFieldStyle(::TestFieldImplemented) = FFLGradientField()
    MPIMagneticFields.FieldMovementStyle(::TestFieldImplemented) = RotationalMovement()

    testField = TestFieldImplemented()

    @test isTimeVarying(testField) == true
    @test isRotatable(testField) == true
    @test isTranslatable(testField) == false

    @test RotationalDimensionalityStyle(testField) isa RotationalDimensionalityStyle{OneDimensional}
    @test TranslationalDimensionalityStyle(testField) isa TranslationalDimensionalityStyle{ZeroDimensional}
  end

  @testset "Implemented translational" begin
    mutable struct TestFieldImplemented <: AbstractMagneticField end

    MPIMagneticFields.FieldStyle(::TestFieldImplemented) = GradientField()
    MPIMagneticFields.FieldDefinitionStyle(::TestFieldImplemented) = MethodBasedFieldDefinition()
    MPIMagneticFields.FieldTimeDependencyStyle(::TestFieldImplemented) = TimeVarying()
    MPIMagneticFields.GradientFieldStyle(::TestFieldImplemented) = FFLGradientField()
    MPIMagneticFields.FieldMovementStyle(::TestFieldImplemented) = TranslationalMovement()

    testField = TestFieldImplemented()

    @test isTimeVarying(testField) == true
    @test isRotatable(testField) == false
    @test isTranslatable(testField) == true

    @test RotationalDimensionalityStyle(testField) isa RotationalDimensionalityStyle{ZeroDimensional}
    @test TranslationalDimensionalityStyle(testField) isa TranslationalDimensionalityStyle{ThreeDimensional}
  end

  @testset "Implemented translational" begin
    mutable struct TestFieldImplemented <: AbstractMagneticField end

    MPIMagneticFields.FieldStyle(::TestFieldImplemented) = GradientField()
    MPIMagneticFields.FieldDefinitionStyle(::TestFieldImplemented) = MethodBasedFieldDefinition()
    MPIMagneticFields.FieldTimeDependencyStyle(::TestFieldImplemented) = TimeVarying()
    MPIMagneticFields.GradientFieldStyle(::TestFieldImplemented) = FFLGradientField()
    MPIMagneticFields.FieldMovementStyle(::TestFieldImplemented) = RotationalTranslationalMovement()

    testField = TestFieldImplemented()

    @test isTimeVarying(testField) == true
    @test isRotatable(testField) == true
    @test isTranslatable(testField) == true

    @test RotationalDimensionalityStyle(testField) isa RotationalDimensionalityStyle{OneDimensional}
    @test TranslationalDimensionalityStyle(testField) isa TranslationalDimensionalityStyle{ThreeDimensional}
  end

  @testset "Movement dimensionality styles" begin
    @test length(RotationalDimensionalityStyle{ZeroDimensional}) == 0
    @test length(RotationalDimensionalityStyle{OneDimensional}) == 1
    @test length(RotationalDimensionalityStyle{TwoDimensional}) == 2
    @test length(RotationalDimensionalityStyle{ThreeDimensional}) == 3

    @test length(TranslationalDimensionalityStyle{ZeroDimensional}) == 0
    @test length(TranslationalDimensionalityStyle{OneDimensional}) == 1
    @test length(TranslationalDimensionalityStyle{TwoDimensional}) == 2
    @test length(TranslationalDimensionalityStyle{ThreeDimensional}) == 3
  end
end
