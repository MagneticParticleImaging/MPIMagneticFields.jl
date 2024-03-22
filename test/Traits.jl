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
    mutable struct RotationalTestFieldImplemented <: AbstractMagneticField end

    MPIMagneticFields.FieldStyle(::RotationalTestFieldImplemented) = GradientField()
    MPIMagneticFields.FieldDefinitionStyle(::RotationalTestFieldImplemented) = MethodBasedFieldDefinition()
    MPIMagneticFields.FieldTimeDependencyStyle(::RotationalTestFieldImplemented) = TimeVarying()
    MPIMagneticFields.GradientFieldStyle(::RotationalTestFieldImplemented) = FFLGradientField()
    MPIMagneticFields.FieldMovementStyle(::RotationalTestFieldImplemented) = RotationalMovement()

    testField = RotationalTestFieldImplemented()

    @test isTimeVarying(testField) == true
    @test isRotatable(testField) == true
    @test isTranslatable(testField) == false

    @test RotationalDimensionalityStyle(testField) isa RotationalDimensionalityStyle{OneDimensional}
    @test TranslationalDimensionalityStyle(testField) isa TranslationalDimensionalityStyle{ZeroDimensional}
  end

  @testset "Implemented translational" begin
    mutable struct TranslationalTestFieldImplemented <: AbstractMagneticField end

    MPIMagneticFields.FieldStyle(::TranslationalTestFieldImplemented) = GradientField()
    MPIMagneticFields.FieldDefinitionStyle(::TranslationalTestFieldImplemented) = MethodBasedFieldDefinition()
    MPIMagneticFields.FieldTimeDependencyStyle(::TranslationalTestFieldImplemented) = TimeVarying()
    MPIMagneticFields.GradientFieldStyle(::TranslationalTestFieldImplemented) = FFLGradientField()
    MPIMagneticFields.FieldMovementStyle(::TranslationalTestFieldImplemented) = TranslationalMovement()

    testField = TranslationalTestFieldImplemented()

    @test isTimeVarying(testField) == true
    @test isRotatable(testField) == false
    @test isTranslatable(testField) == true

    @test RotationalDimensionalityStyle(testField) isa RotationalDimensionalityStyle{ZeroDimensional}
    @test TranslationalDimensionalityStyle(testField) isa TranslationalDimensionalityStyle{ThreeDimensional}
  end

  @testset "Implemented rotational and translational" begin
    mutable struct RotationalTranslationalTestFieldImplemented <: AbstractMagneticField end

    MPIMagneticFields.FieldStyle(::RotationalTranslationalTestFieldImplemented) = GradientField()
    MPIMagneticFields.FieldDefinitionStyle(::RotationalTranslationalTestFieldImplemented) = MethodBasedFieldDefinition()
    MPIMagneticFields.FieldTimeDependencyStyle(::RotationalTranslationalTestFieldImplemented) = TimeVarying()
    MPIMagneticFields.GradientFieldStyle(::RotationalTranslationalTestFieldImplemented) = FFLGradientField()
    MPIMagneticFields.FieldMovementStyle(::RotationalTranslationalTestFieldImplemented) = RotationalTranslationalMovement()

    testField = RotationalTranslationalTestFieldImplemented()

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
