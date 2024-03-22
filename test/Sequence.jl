@testset "Sequence" begin
  @testset "Basics" begin
    testField = SequencedField(IdealXYRotatedFFL(1.0); rotation = t -> sin.(2π * 2 * t))

    @test FieldStyle(testField) isa GradientField
    @test FieldDefinitionStyle(testField) isa MethodBasedFieldDefinition
    @test FieldTimeDependencyStyle(testField) isa TimeConstant
    @test GradientFieldStyle(testField) isa FFLGradientField
    @test FieldMovementStyle(testField) isa SequencedMovement

    @test isRotatable(testField) == false
    @test isTranslatable(testField) == false

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

    MPIMagneticFields.value_(field::RotationalTestFieldImplemented, t, r, ϕ) = ϕ

    f = 1
    testField = SequencedField(RotationalTestFieldImplemented(); rotation = t -> sawtoothwave.(2π * f * t))

    @test isTimeVarying(testField) == true
    @test isRotatable(testField) == false
    @test isTranslatable(testField) == false

    @test RotationalDimensionalityStyle(testField) isa RotationalDimensionalityStyle{ZeroDimensional}
    @test TranslationalDimensionalityStyle(testField) isa TranslationalDimensionalityStyle{ZeroDimensional}

    @test isapprox.(value(testField, 0, [0, 0, 0]), 0, atol = 1e-10)
    @test isapprox.(value(testField, 0.5, [0, 0, 0]), 1, atol = 1e-10)
    @test isapprox.(value(testField, 1, [0, 0, 0]), 0, atol = 1e-10)
  end

  @testset "Implemented translational" begin
    mutable struct TranslationalTestFieldImplemented <: AbstractMagneticField end

    MPIMagneticFields.FieldStyle(::TranslationalTestFieldImplemented) = GradientField()
    MPIMagneticFields.FieldDefinitionStyle(::TranslationalTestFieldImplemented) = MethodBasedFieldDefinition()
    MPIMagneticFields.FieldTimeDependencyStyle(::TranslationalTestFieldImplemented) = TimeVarying()
    MPIMagneticFields.GradientFieldStyle(::TranslationalTestFieldImplemented) = FFLGradientField()
    MPIMagneticFields.FieldMovementStyle(::TranslationalTestFieldImplemented) = TranslationalMovement()

    MPIMagneticFields.value_(field::TranslationalTestFieldImplemented, t, r, δ) = δ

    f = 1
    testField = SequencedField(TranslationalTestFieldImplemented(); translation = t -> sawtoothwave.(2π * f * t))

    @test isTimeVarying(testField) == true
    @test isRotatable(testField) == false
    @test isTranslatable(testField) == false

    @test RotationalDimensionalityStyle(testField) isa RotationalDimensionalityStyle{ZeroDimensional}
    @test TranslationalDimensionalityStyle(testField) isa TranslationalDimensionalityStyle{ZeroDimensional}

    @test isapprox.(value(testField, 0, [0, 0, 0]), 0, atol = 1e-10)
    @test isapprox.(value(testField, 0.5, [0, 0, 0]), 1, atol = 1e-10)
    @test isapprox.(value(testField, 1, [0, 0, 0]), 0, atol = 1e-10)
  end

  @testset "Implemented rotational and translational" begin
    mutable struct RotationalTranslationalTestFieldImplemented <: AbstractMagneticField end

    MPIMagneticFields.FieldStyle(::RotationalTranslationalTestFieldImplemented) = GradientField()
    MPIMagneticFields.FieldDefinitionStyle(::RotationalTranslationalTestFieldImplemented) = MethodBasedFieldDefinition()
    MPIMagneticFields.FieldTimeDependencyStyle(::RotationalTranslationalTestFieldImplemented) = TimeVarying()
    MPIMagneticFields.GradientFieldStyle(::RotationalTranslationalTestFieldImplemented) = FFLGradientField()
    MPIMagneticFields.FieldMovementStyle(::RotationalTranslationalTestFieldImplemented) = RotationalTranslationalMovement()

    MPIMagneticFields.value_(field::RotationalTranslationalTestFieldImplemented, t, r, ϕ, δ) = (ϕ, δ)

    f = 1
    testField = SequencedField(
      TestFieldImplemented();
      rotation = t -> sawtoothwave.(2π * f * t),
      translation = t -> sawtoothwave.(2π * f * t),
    )

    @test isTimeVarying(testField) == true
    @test isRotatable(testField) == false
    @test isTranslatable(testField) == false

    @test RotationalDimensionalityStyle(testField) isa RotationalDimensionalityStyle{ZeroDimensional}
    @test TranslationalDimensionalityStyle(testField) isa TranslationalDimensionalityStyle{ZeroDimensional}

    @test all(isapprox.(value(testField, 0, [0, 0, 0]), (0, 0), atol = 1e-10))
    @test all(isapprox.(value(testField, 0.5, [0, 0, 0]), (1, 1), atol = 1e-10))
    @test all(isapprox.(value(testField, 1, [0, 0, 0]), (0, 0), atol = 1e-10))
  end
end
