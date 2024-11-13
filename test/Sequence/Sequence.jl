@testset "Sequence" begin
  include("MotionPatterns.jl")

  @testset "SequencedField" begin
    t = range(0, 1, 10)u"s"

    field_ = IdealXYRotatedTranslatedFFL(1u"mT")
    sequence_ = RotationalTranslationalSequence(
      1u"s",
      StandardRotationPattern(ω = 1.0u"rad/s", ϕ = 0.0u"rad"),
      SinusoidalTranslationPattern(f = 1u"Hz", amplitude = 1u"mT", offset = 1u"mT")
    )
    sequencedField = SequencedField(field_, sequence_)

    @test FieldStyle(sequencedField) isa GradientField
    @test FieldDefinitionStyle(sequencedField) isa MethodBasedFieldDefinition
    @test FieldTimeDependencyStyle(sequencedField) isa TimeVarying
    @test GradientFieldStyle(sequencedField) isa FFLGradientField
    @test FieldMovementStyle(sequencedField) isa SequencedMovement

    @test isRotatable(sequencedField) == false
    @test isTranslatable(sequencedField) == false

    @test RotationalDimensionalityStyle(sequencedField) isa RotationalDimensionalityStyle{ZeroDimensional}
    @test TranslationalDimensionalityStyle(sequencedField) isa TranslationalDimensionalityStyle{ZeroDimensional}

    @test all(value(sequencedField, t, [0, 0, 0]) .≈ value(field_, [0, 0, 0], sawtoothwave.(upreferred.(t .* 1.0u"rad/s" .+ 0.0u"rad")) .* π, 1u"mT" .* sin.(2π * 1u"Hz" * t) .+ 1u"mT"))
  end

  @testset "LimitedSequencedField" begin
    t = range(0, 1, 100)u"s"

    field_ = OneDimensionalVariableTranslationHomogeneousField(XDirection())
    sequence_ = TranslationalSequence(
      1u"s",
      SinusoidalTranslationPattern(f = 10u"Hz", amplitude = 50u"mT", offset = 0u"mT")
    )
    sequencedField = SequencedField(field_, sequence_)
    limitedSequencedField = LimitedSequencedField(sequencedField, NTuple{3}([-30u"mT", -30u"mT", -30u"mT"]), NTuple{3}([20u"mT", 20u"mT", 20u"mT"]))

    @test FieldStyle(limitedSequencedField) isa HomogeneousField
    @test FieldDefinitionStyle(limitedSequencedField) isa MethodBasedFieldDefinition
    @test FieldTimeDependencyStyle(limitedSequencedField) isa TimeVarying
    @test GradientFieldStyle(limitedSequencedField) isa NoGradientField
    @test FieldMovementStyle(limitedSequencedField) isa SequencedMovement

    @test isRotatable(limitedSequencedField) == false
    @test isTranslatable(limitedSequencedField) == false

    @test RotationalDimensionalityStyle(limitedSequencedField) isa RotationalDimensionalityStyle{ZeroDimensional}
    @test TranslationalDimensionalityStyle(limitedSequencedField) isa TranslationalDimensionalityStyle{ZeroDimensional}

    # Tests the non-vector path
    values_ = value(limitedSequencedField, t, [0, 0, 0])
    @test all([all(val_ .>= -30u"mT") for val_ ∈ values_])
    @test all([all(val_ .<= 20u"mT") for val_ ∈ values_])

    # Tests the vector path
    values_ = MPIMagneticFields.value_(limitedSequencedField, t, [0, 0, 0])
    @test all([all(val_ .>= -30u"mT") for val_ ∈ values_])
    @test all([all(val_ .<= 20u"mT") for val_ ∈ values_])
  end

  @testset "SequenceTemplate" begin
    struct TestSequenceTemplate <: SequenceTemplate end
    struct SequenceTemplateTestSequence <: Sequence end
    @test_throws ErrorException sequence(TestSequenceTemplate())
    #@test_throws ErrorException convert(Type{SequenceTemplateTestSequence}, TestSequenceTemplate())
  end

  @testset "Sequences" begin
    t = range(0, 1, 10)u"s"

    @testset "SequenceDefaults" begin
      struct SequenceDefaultsTestSequence <: MotionPatternSequence end

      seq = SequenceDefaultsTestSequence()
      field = IdealHomogeneousField([1, 0, 0])

      @test_throws ErrorException fieldOverTime(seq, field, 0, [0, 0, 0])
      @test_throws ErrorException totalSequenceTime(seq)
      @test_throws ErrorException rotation(seq)
      @test_throws ErrorException translation(seq)
    end

    @testset "RotationalSequence" begin
      seq = RotationalSequence(1u"s", StandardRotationPattern(ω = 1.0u"rad/s", ϕ = 0.0u"rad"))

      @test totalSequenceTime(seq) == 1u"s"
      @test rotation(seq) isa StandardRotationPattern
      @test frequency(rotation(seq)) == 1.0u"rad/s"
      @test phase(rotation(seq)) == 0.0u"rad"
      @test translation(seq) isa NoTranslationPattern

      struct NoMovementTestRotationalSequenceField <: AbstractMagneticField end
      MPIMagneticFields.FieldMovementStyle(::NoMovementTestRotationalSequenceField) = NoMovement()
      @test_throws ErrorException fieldOverTime(seq, NoMovementTestRotationalSequenceField(), t, [0, 0, 1])

      struct RotationalMovementTestRotationalSequenceField <: AbstractMagneticField end
      MPIMagneticFields.FieldMovementStyle(::RotationalMovementTestRotationalSequenceField) = RotationalMovement()
      MPIMagneticFields.FieldTimeDependencyStyle(::RotationalMovementTestRotationalSequenceField) = TimeVarying()
      MPIMagneticFields.value_(::RotationalMovementTestRotationalSequenceField, t, r, ϕ) = t
      @test all(fieldOverTime(seq, RotationalMovementTestRotationalSequenceField(), t, [0, 0, 1]) .≈ t)

      struct TranslationalMovementTestRotationalSequenceField <: AbstractMagneticField end
      MPIMagneticFields.FieldMovementStyle(::TranslationalMovementTestRotationalSequenceField) = TranslationalMovement()
      @test_throws ErrorException fieldOverTime(seq, TranslationalMovementTestRotationalSequenceField(), t, [0, 0, 1])

      struct RotationalTranslationalMovementTestRotationalSequenceField <: AbstractMagneticField end
      MPIMagneticFields.FieldMovementStyle(::RotationalTranslationalMovementTestRotationalSequenceField) = RotationalTranslationalMovement()
      @test_throws ErrorException fieldOverTime(seq, RotationalTranslationalMovementTestRotationalSequenceField(), t, [0, 0, 1])
    end

    @testset "TranslationalSequence" begin
      seq = TranslationalSequence(1u"s", SinusoidalTranslationPattern(f = 1u"Hz", amplitude = 1u"mT", offset = 1u"mT"))

      @test totalSequenceTime(seq) == 1u"s"
      @test rotation(seq) isa NoRotationPattern
      @test translation(seq) isa SinusoidalTranslationPattern
      @test frequency(translation(seq)) == 1u"Hz"
      @test amplitude(translation(seq)) == 1u"mT"
      @test offset(translation(seq)) == 1u"mT"

      struct NoMovementTestTranslationalSequenceField <: AbstractMagneticField end
      MPIMagneticFields.FieldMovementStyle(::NoMovementTestTranslationalSequenceField) = NoMovement()
      @test_throws ErrorException fieldOverTime(seq, NoMovementTestTranslationalSequenceField(), t, [0, 0, 1])

      struct RotationalMovementTestTranslationalSequenceField <: AbstractMagneticField end
      MPIMagneticFields.FieldMovementStyle(::RotationalMovementTestTranslationalSequenceField) = RotationalMovement()
      @test_throws ErrorException fieldOverTime(seq, RotationalMovementTestTranslationalSequenceField(), t, [0, 0, 1])

      struct TranslationalMovementTestTranslationalSequenceField <: AbstractMagneticField end
      MPIMagneticFields.FieldMovementStyle(::TranslationalMovementTestTranslationalSequenceField) = TranslationalMovement()
      MPIMagneticFields.FieldTimeDependencyStyle(::TranslationalMovementTestTranslationalSequenceField) = TimeVarying()
      MPIMagneticFields.value_(::TranslationalMovementTestTranslationalSequenceField, t, r, δ) = t
      @test all(fieldOverTime(seq, TranslationalMovementTestTranslationalSequenceField(), t, [0, 0, 1]) .≈ t)

      struct RotationalTranslationalMovementTestTranslationalSequenceField <: AbstractMagneticField end
      MPIMagneticFields.FieldMovementStyle(::RotationalTranslationalMovementTestTranslationalSequenceField) = RotationalTranslationalMovement()
      @test_throws ErrorException fieldOverTime(seq, RotationalTranslationalMovementTestTranslationalSequenceField(), t, [0, 0, 1])
    end

    @testset "RotationalTranslationalSequence" begin
      seq = RotationalTranslationalSequence(
        1u"s",
        StandardRotationPattern(ω = 1.0u"rad/s", ϕ = 0.0u"rad"),
        SinusoidalTranslationPattern(f = 1u"Hz", amplitude = 1u"mT", offset = 1u"mT")
      )

      @test totalSequenceTime(seq) == 1u"s"
      @test rotation(seq) isa StandardRotationPattern
      @test frequency(rotation(seq)) == 1.0u"rad/s"
      @test phase(rotation(seq)) == 0.0u"rad"
      @test translation(seq) isa SinusoidalTranslationPattern
      @test frequency(translation(seq)) == 1u"Hz"
      @test amplitude(translation(seq)) == 1u"mT"
      @test offset(translation(seq)) == 1u"mT"

      struct NoMovementTestRotationalTranslationalSequenceField <: AbstractMagneticField end
      MPIMagneticFields.FieldMovementStyle(::NoMovementTestRotationalTranslationalSequenceField) = NoMovement()
      @test_throws ErrorException fieldOverTime(seq, NoMovementTestRotationalTranslationalSequenceField(), t, [0, 0, 1])

      struct RotationalMovementTestRotationalTranslationalSequenceField <: AbstractMagneticField end
      MPIMagneticFields.FieldMovementStyle(::RotationalMovementTestRotationalTranslationalSequenceField) = RotationalMovement()
      @test_throws ErrorException fieldOverTime(seq, RotationalMovementTestRotationalTranslationalSequenceField(), t, [0, 0, 1])

      struct TranslationalMovementTestRotationalTranslationalSequenceField <: AbstractMagneticField end
      MPIMagneticFields.FieldMovementStyle(::TranslationalMovementTestRotationalTranslationalSequenceField) = TranslationalMovement()
      @test_throws ErrorException fieldOverTime(seq, TranslationalMovementTestRotationalTranslationalSequenceField(), t, [0, 0, 1])

      struct RotationalTranslationalMovementTestRotationalTranslationalSequenceField <: AbstractMagneticField end
      MPIMagneticFields.FieldMovementStyle(::RotationalTranslationalMovementTestRotationalTranslationalSequenceField) = RotationalTranslationalMovement()
      MPIMagneticFields.FieldTimeDependencyStyle(::RotationalTranslationalMovementTestRotationalTranslationalSequenceField) = TimeVarying()
      MPIMagneticFields.value_(::RotationalTranslationalMovementTestRotationalTranslationalSequenceField, t, r, ϕ, δ) = t
      @test all(fieldOverTime(seq, RotationalTranslationalMovementTestRotationalTranslationalSequenceField(), t, [0, 0, 1]) .≈ t)
    end
  end
end