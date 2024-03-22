@testset "Traits" begin
  @testset "Defaults" begin
    mutable struct TestField <: AbstractMagneticField end

    testField = TestField()

    @test FieldStyle(testField) isa OtherField
    @test FieldDefinitionStyle(testField) isa MethodBasedFieldDefinition
    @test FieldTimeDependencyStyle(testField) isa TimeConstant
    @test GradientFieldStyle(testField) isa NoGradientField
    @test FieldMovementStyle(testField) isa NoMovement

    @test RotationalDimensionalityStyle(testField) isa RotationalDimensionalityStyle{ZeroDimensional}
    @test TranslationalDimensionalityStyle(testField) isa TranslationalDimensionalityStyle{ZeroDimensional}
  end

  @testset "Implemented rotational" begin
    mutable struct TraitsRotationalTestFieldImplemented <: AbstractMagneticField end

    MPIMagneticFields.FieldStyle(::TraitsRotationalTestFieldImplemented) = GradientField()
    MPIMagneticFields.FieldDefinitionStyle(::TraitsRotationalTestFieldImplemented) = MethodBasedFieldDefinition()
    MPIMagneticFields.FieldTimeDependencyStyle(::TraitsRotationalTestFieldImplemented) = TimeVarying()
    MPIMagneticFields.GradientFieldStyle(::TraitsRotationalTestFieldImplemented) = FFLGradientField()
    MPIMagneticFields.FieldMovementStyle(::TraitsRotationalTestFieldImplemented) = RotationalMovement()

    testField = TraitsRotationalTestFieldImplemented()

    @test isTimeVarying(testField) == true
    @test isRotatable(testField) == true
    @test isTranslatable(testField) == false

    @test RotationalDimensionalityStyle(testField) isa RotationalDimensionalityStyle{OneDimensional}
    @test TranslationalDimensionalityStyle(testField) isa TranslationalDimensionalityStyle{ZeroDimensional}
  end

  @testset "Implemented translational" begin
    mutable struct TraitsTranslationalTestFieldImplemented <: AbstractMagneticField end

    MPIMagneticFields.FieldStyle(::TraitsTranslationalTestFieldImplemented) = GradientField()
    MPIMagneticFields.FieldDefinitionStyle(::TraitsTranslationalTestFieldImplemented) = MethodBasedFieldDefinition()
    MPIMagneticFields.FieldTimeDependencyStyle(::TraitsTranslationalTestFieldImplemented) = TimeVarying()
    MPIMagneticFields.GradientFieldStyle(::TraitsTranslationalTestFieldImplemented) = FFLGradientField()
    MPIMagneticFields.FieldMovementStyle(::TraitsTranslationalTestFieldImplemented) = TranslationalMovement()

    testField = TraitsTranslationalTestFieldImplemented()

    @test isTimeVarying(testField) == true
    @test isRotatable(testField) == false
    @test isTranslatable(testField) == true

    @test RotationalDimensionalityStyle(testField) isa RotationalDimensionalityStyle{ZeroDimensional}
    @test TranslationalDimensionalityStyle(testField) isa TranslationalDimensionalityStyle{ThreeDimensional}
  end

  @testset "Implemented rotational and translational" begin
    mutable struct TraitsRotationalTranslationalTestFieldImplemented <: AbstractMagneticField end

    MPIMagneticFields.FieldStyle(::TraitsRotationalTranslationalTestFieldImplemented) = GradientField()
    MPIMagneticFields.FieldDefinitionStyle(::TraitsRotationalTranslationalTestFieldImplemented) = MethodBasedFieldDefinition()
    MPIMagneticFields.FieldTimeDependencyStyle(::TraitsRotationalTranslationalTestFieldImplemented) = TimeVarying()
    MPIMagneticFields.GradientFieldStyle(::TraitsRotationalTranslationalTestFieldImplemented) = FFLGradientField()
    MPIMagneticFields.FieldMovementStyle(::TraitsRotationalTranslationalTestFieldImplemented) = RotationalTranslationalMovement()

    testField = TraitsRotationalTranslationalTestFieldImplemented()

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
