@testset "Superposition" begin
  @testset "Basics" begin
    mutable struct TestSuperpositionIdealHomogeneousField{T, U} <:
                   AbstractMagneticField where {T <: Number, U <: Number}
      amplitude::T
      direction::Vector{U}
    end

    MPIMagneticFields.FieldStyle(::TestSuperpositionIdealHomogeneousField) = HomogeneousField()
    function MPIMagneticFields.FieldDefinitionStyle(::TestSuperpositionIdealHomogeneousField)
      return MethodBasedFieldDefinition()
    end
    MPIMagneticFields.FieldTimeDependencyStyle(::TestSuperpositionIdealHomogeneousField) = TimeConstant()
    MPIMagneticFields.FieldMovementStyle(::TestSuperpositionIdealHomogeneousField) = NoMovement()

    function MPIMagneticFields.value_(field::TestSuperpositionIdealHomogeneousField, r)
      return normalize(field.direction) .* field.amplitude
    end

    fieldA = TestSuperpositionIdealHomogeneousField(1, [1, 0, 0])
    fieldB = TestSuperpositionIdealHomogeneousField(1, [0, 1, 0])

    @testset "Function" begin
      superimposedField = superimpose(fieldA, fieldB)

      @test superimposedField isa SuperimposedField
      @test FieldStyle(superimposedField) isa HomogeneousField
      @test FieldDefinitionStyle(superimposedField) isa MethodBasedFieldDefinition
      @test FieldTimeDependencyStyle(superimposedField) isa TimeConstant

      @test all(value(superimposedField, [1, 0, 0]) .≈ [1, 1, 0])
      @test all(value(superimposedField, [0.5, 0, 0]) .≈ [1, 1, 0])

      @test isRotatable(superimposedField) == false
      @test isTranslatable(superimposedField) == false
      @test isTimeVarying(superimposedField) == false
    end

    @testset "Operator" begin
      superimposedField = fieldA + fieldB

      @test superimposedField isa SuperimposedField
      @test FieldStyle(superimposedField) isa HomogeneousField
      @test FieldDefinitionStyle(superimposedField) isa MethodBasedFieldDefinition
      @test FieldTimeDependencyStyle(superimposedField) isa TimeConstant

      @test all(value(superimposedField, [1, 0, 0]) .≈ [1, 1, 0])

      @test isRotatable(superimposedField) == false
      @test isTranslatable(superimposedField) == false
    end

    @testset "Negative" begin
      mutable struct TestIdealFFP{GT} <: AbstractMagneticField where {GT <: Number}
        gradient::Vector{GT}
      end

      MPIMagneticFields.FieldStyle(::TestIdealFFP) = GradientField()
      MPIMagneticFields.FieldDefinitionStyle(::TestIdealFFP) = MethodBasedFieldDefinition()
      MPIMagneticFields.FieldTimeDependencyStyle(::TestIdealFFP) = TimeConstant()
      MPIMagneticFields.GradientFieldStyle(::TestIdealFFP) = FFPGradientField()
      MPIMagneticFields.FieldMovementStyle(::TestIdealFFP) = NoMovement()

      MPIMagneticFields.value_(field::TestIdealFFP, r) = r .* field.gradient

      field = TestIdealFFP([1, 1, 1])

      @test field isa TestIdealFFP
      @test negative(field) isa NegativeField
      @test FieldStyle(field) isa GradientField
      @test FieldStyle(negative(field)) isa GradientField
      @test FieldDefinitionStyle(field) isa MethodBasedFieldDefinition
      @test FieldDefinitionStyle(negative(field)) isa MethodBasedFieldDefinition
      @test FieldTimeDependencyStyle(field) isa TimeConstant
      @test FieldTimeDependencyStyle(negative(field)) isa TimeConstant
      @test GradientFieldStyle(field) isa FFPGradientField
      @test GradientFieldStyle(negative(field)) isa FFPGradientField

      @test all(value(negative(field), [1, 0, 0]) .≈ [-1, 0, 0])
      @test all(value(negative(field), [0.5, 0, 0]) .≈ [-0.5, 0, 0])

      # @test all(isapprox.(value(negative(field), [1, 0, 0], π/2), [-1, 0, 0], atol=1e-10))
      # @test all(isapprox.(value(negative(field), [0.5, 0, 0], π/2), [-0.5, 0, 0], atol=1e-10))

      # @test all(value(negative(field), [1, 0, 0], [1, 0, 0]) .≈ [-1, 0, 0])
      # @test all(value(negative(field), [0.5, 0, 0], [1, 0, 0]) .≈ [-0.5, 0, 0])

      # @test all(isapprox.(value(negative(field), [1, 0, 0], π/2, [1, 0, 0]), [-1, 0, 0], atol=1e-10))
      # @test all(isapprox.(value(negative(field), [0.5, 0, 0], π/2, [1, 0, 0]), [-0.5, 0, 0], atol=1e-10))

      @test isRotatable(field) == false
      @test isTranslatable(field) == false
      @test isTimeVarying(field) == false
    end

    @testset "Superimposed Negative" begin
      superimposedField = fieldA - fieldB

      @test superimposedField isa SuperimposedField
      @test FieldStyle(superimposedField) isa HomogeneousField
      @test FieldDefinitionStyle(superimposedField) isa MethodBasedFieldDefinition
      @test FieldTimeDependencyStyle(superimposedField) isa TimeConstant
      @test isnothing(GradientFieldStyle(superimposedField))

      @test all(value(superimposedField, [1, 0, 0]) .≈ [1, -1, 0])
      @test all(value(superimposedField, [0.5, 0, 0]) .≈ [1, -1, 0])

      @test isRotatable(superimposedField) == false
      @test isTranslatable(superimposedField) == false
    end
  end

  @testset "Movement types" begin
    mutable struct TestIdealXYRotatedTranslatedHomogeneousField{T, U} <:
                   AbstractMagneticField where {T <: Number, U <: Number}
      amplitude::T
      direction::Vector{U}
    end

    MPIMagneticFields.FieldStyle(::TestIdealXYRotatedTranslatedHomogeneousField) = HomogeneousField()
    function MPIMagneticFields.FieldDefinitionStyle(::TestIdealXYRotatedTranslatedHomogeneousField)
      return MethodBasedFieldDefinition()
    end
    function MPIMagneticFields.FieldTimeDependencyStyle(::TestIdealXYRotatedTranslatedHomogeneousField)
      return TimeConstant()
    end
    function MPIMagneticFields.FieldMovementStyle(::TestIdealXYRotatedTranslatedHomogeneousField)
      return RotationalTranslationalMovement()
    end
    function MPIMagneticFields.RotationalDimensionalityStyle(::TestIdealXYRotatedTranslatedHomogeneousField)
      return RotationalDimensionalityStyle{OneDimensional}()
    end
    function MPIMagneticFields.TranslationalDimensionalityStyle(
      ::TestIdealXYRotatedTranslatedHomogeneousField,
    )
      return TranslationalDimensionalityStyle{ThreeDimensional}()
    end

    function MPIMagneticFields.value_(field::TestIdealXYRotatedTranslatedHomogeneousField, r, ϕ, δ)
      return [sin(ϕ), cos(ϕ), 0] .* field.amplitude
    end # A homogeneous field is shift-invariant

    fieldA = TestIdealXYRotatedTranslatedHomogeneousField(1, [1, 0, 0])
    fieldB = TestIdealXYRotatedTranslatedHomogeneousField(1, [0, 1, 0])

    superimposedField = fieldA + fieldB

    @test superimposedField isa SuperimposedField
    @test FieldStyle(superimposedField) isa HomogeneousField
    @test FieldDefinitionStyle(superimposedField) isa MethodBasedFieldDefinition
    @test FieldTimeDependencyStyle(superimposedField) isa TimeConstant
    @test RotationalDimensionalityStyle(superimposedField) isa RotationalDimensionalityStyle{OneDimensional}
    @test TranslationalDimensionalityStyle(superimposedField) isa
          TranslationalDimensionalityStyle{ThreeDimensional}

    @test all(value(superimposedField, [1, 0, 0], 0, [0, 0, 0]) .≈ [0, 2, 0])
    @test all(value(superimposedField, [0.5, 0, 0], 0, [0, 0, 0]) .≈ [0, 2, 0])

    @test all(isapprox.(value(superimposedField, [1, 0, 0], π / 2, [0, 0, 0]), [2, 0, 0], atol = 1e-10))
    @test all(isapprox.(value(superimposedField, [0.5, 0, 0], π / 2, [0, 0, 0]), [2, 0, 0], atol = 1e-10))

    @test all(value(superimposedField, [1, 0, 0], 0, [1, 0, 0]) .≈ [0, 2, 0])
    @test all(value(superimposedField, [0.5, 0, 0], 0, [1, 0, 0]) .≈ [0, 2, 0])

    @test all(isapprox.(value(superimposedField, [1, 0, 0], π / 2, [1, 0, 0]), [2, 0, 0], atol = 1e-10))
    @test all(isapprox.(value(superimposedField, [0.5, 0, 0], π / 2, [1, 0, 0]), [2, 0, 0], atol = 1e-10))

    @test isRotatable(superimposedField) == true
    @test isTranslatable(superimposedField) == true
  end

  @testset "Mixed field superposition" begin
    mutable struct TestIdealFFP{GT} <: AbstractMagneticField where {GT <: Number}
      gradient::Vector{GT}
    end

    MPIMagneticFields.FieldStyle(::TestIdealFFP) = GradientField()
    MPIMagneticFields.FieldDefinitionStyle(::TestIdealFFP) = MethodBasedFieldDefinition()
    MPIMagneticFields.FieldTimeDependencyStyle(::TestIdealFFP) = TimeConstant()
    MPIMagneticFields.GradientFieldStyle(::TestIdealFFP) = FFPGradientField()
    MPIMagneticFields.FieldMovementStyle(::TestIdealFFP) = NoMovement()

    MPIMagneticFields.value_(field::TestIdealFFP, r) = r .* field.gradient

    fieldA = TestIdealFFP([1, 1, 1])

    mutable struct TestSuperpositionIdealHomogeneousField{T, U} <:
                   AbstractMagneticField where {T <: Number, U <: Number}
      amplitude::T
      direction::Vector{U}
    end

    MPIMagneticFields.FieldStyle(::TestSuperpositionIdealHomogeneousField) = HomogeneousField()
    function MPIMagneticFields.FieldDefinitionStyle(::TestSuperpositionIdealHomogeneousField)
      return SymbolicBasedFieldDefinition()
    end
    MPIMagneticFields.FieldTimeDependencyStyle(::TestSuperpositionIdealHomogeneousField) = TimeVarying()
    MPIMagneticFields.FieldMovementStyle(::TestSuperpositionIdealHomogeneousField) = NoMovement()

    function MPIMagneticFields.value_(field::TestSuperpositionIdealHomogeneousField, r)
      return normalize(field.direction) .* field.amplitude
    end

    fieldB = TestSuperpositionIdealHomogeneousField(1, [1, 0, 0])

    superimposedField = fieldA + fieldB

    @test FieldStyle(superimposedField) isa MixedField
    @test FieldDefinitionStyle(superimposedField) isa MixedFieldDefinition
    @test FieldTimeDependencyStyle(superimposedField) isa TimeVarying
    @test GradientFieldStyle(superimposedField) isa MixedGradientField
  end
end
