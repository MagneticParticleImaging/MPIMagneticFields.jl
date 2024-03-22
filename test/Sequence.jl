@testset "Sequence" begin
  @testset "Basics" begin
    testField = SequencedField(IdealXYRotatedFFL(1.0); rotation = t -> sin.(2π * 2 * t))

    @test FieldStyle(testField) isa GradientField
    @test FieldDefinitionStyle(testField) isa MethodBasedFieldDefinition
    @test FieldTimeDependencyStyle(testField) isa TimeVarying
    @test GradientFieldStyle(testField) isa FFLGradientField
    @test FieldMovementStyle(testField) isa SequencedMovement

    @test isRotatable(testField) == false
    @test isTranslatable(testField) == false

    @test RotationalDimensionalityStyle(testField) isa RotationalDimensionalityStyle{ZeroDimensional}
    @test TranslationalDimensionalityStyle(testField) isa TranslationalDimensionalityStyle{ZeroDimensional}
  end

  @testset "Implemented rotational" begin
    mutable struct SequenceRotationalTestFieldImplemented <: AbstractMagneticField end

    MPIMagneticFields.FieldStyle(::SequenceRotationalTestFieldImplemented) = GradientField()
    MPIMagneticFields.FieldDefinitionStyle(::SequenceRotationalTestFieldImplemented) = MethodBasedFieldDefinition()
    MPIMagneticFields.FieldTimeDependencyStyle(::SequenceRotationalTestFieldImplemented) = TimeVarying()
    MPIMagneticFields.GradientFieldStyle(::SequenceRotationalTestFieldImplemented) = FFLGradientField()
    MPIMagneticFields.FieldMovementStyle(::SequenceRotationalTestFieldImplemented) = RotationalMovement()

    MPIMagneticFields.value_(field::SequenceRotationalTestFieldImplemented, t, r, ϕ) = ϕ

    f = 1
    testField = SequencedField(SequenceRotationalTestFieldImplemented(); rotation = t -> sawtoothwave.(2π * f * t))

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
    mutable struct SequenceTranslationalTestFieldImplemented <: AbstractMagneticField end

    MPIMagneticFields.FieldStyle(::SequenceTranslationalTestFieldImplemented) = GradientField()
    MPIMagneticFields.FieldDefinitionStyle(::SequenceTranslationalTestFieldImplemented) = MethodBasedFieldDefinition()
    MPIMagneticFields.FieldTimeDependencyStyle(::SequenceTranslationalTestFieldImplemented) = TimeVarying()
    MPIMagneticFields.GradientFieldStyle(::SequenceTranslationalTestFieldImplemented) = FFLGradientField()
    MPIMagneticFields.FieldMovementStyle(::SequenceTranslationalTestFieldImplemented) = TranslationalMovement()

    MPIMagneticFields.value_(field::SequenceTranslationalTestFieldImplemented, t, r, δ) = δ

    f = 1
    testField = SequencedField(SequenceTranslationalTestFieldImplemented(); translation = t -> sawtoothwave.(2π * f * t))

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
    mutable struct SequenceRotationalTranslationalTestFieldImplemented <: AbstractMagneticField end

    MPIMagneticFields.FieldStyle(::SequenceRotationalTranslationalTestFieldImplemented) = GradientField()
    MPIMagneticFields.FieldDefinitionStyle(::SequenceRotationalTranslationalTestFieldImplemented) = MethodBasedFieldDefinition()
    MPIMagneticFields.FieldTimeDependencyStyle(::SequenceRotationalTranslationalTestFieldImplemented) = TimeVarying()
    MPIMagneticFields.GradientFieldStyle(::SequenceRotationalTranslationalTestFieldImplemented) = FFLGradientField()
    MPIMagneticFields.FieldMovementStyle(::SequenceRotationalTranslationalTestFieldImplemented) = RotationalTranslationalMovement()

    MPIMagneticFields.value_(field::SequenceRotationalTranslationalTestFieldImplemented, t, r, ϕ, δ) = (ϕ, δ)

    f = 1
    testField = SequencedField(
      SequenceRotationalTranslationalTestFieldImplemented();
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
