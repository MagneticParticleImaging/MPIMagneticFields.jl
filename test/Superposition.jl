@testset "Superposition" begin
  @testset "Basics" begin
    mutable struct TestIdealHomogeneousField{T, U} <: AbstractMagneticField where {T <: Number, U <: Number}
      amplitude::T
      direction::Vector{U}
    end

    MPIMagneticFields.fieldType(::TestIdealHomogeneousField) = HomogeneousField()
    MPIMagneticFields.definitionType(::TestIdealHomogeneousField) = MethodBasedFieldDefinition()
    MPIMagneticFields.timeDependencyType(::TestIdealHomogeneousField) = TimeConstant()
    MPIMagneticFields.fieldMovementType(::TestIdealHomogeneousField) = NoMovement()

    MPIMagneticFields.value(field::TestIdealHomogeneousField, ::PT) where {T <: Number, PT <: AbstractVector{T}} = normalize(field.direction).*field.amplitude

    fieldA = TestIdealHomogeneousField(1, [1, 0, 0])
    fieldB = TestIdealHomogeneousField(1, [0, 1, 0])

    @testset "Function" begin
      superimposedField = superimpose(fieldA, fieldB)

      @test superimposedField isa SuperimposedField
      @test fieldType(superimposedField) isa HomogeneousField
      @test definitionType(superimposedField) isa MethodBasedFieldDefinition
      @test timeDependencyType(superimposedField) isa TimeConstant

      @test all(value(superimposedField, [1, 0, 0]) .≈ [1, 1, 0])
      @test all(value(superimposedField, [0.5, 0, 0]) .≈ [1, 1, 0])

      @test isRotatable(superimposedField) == false
      @test isTranslatable(superimposedField) == false
    end

    @testset "Operator" begin
      superimposedField = fieldA + fieldB

      @test superimposedField isa SuperimposedField
      @test fieldType(superimposedField) isa HomogeneousField
      @test definitionType(superimposedField) isa MethodBasedFieldDefinition
      @test timeDependencyType(superimposedField) isa TimeConstant

      @test all(value(superimposedField, [1, 0, 0]) .≈ [1, 1, 0])

      @test isRotatable(superimposedField) == false
      @test isTranslatable(superimposedField) == false
    end

    @testset "Negative" begin
      mutable struct TestIdealFFP{GT} <: AbstractMagneticField where {GT <: Number}
        gradient::Vector{GT}
      end
      
      MPIMagneticFields.fieldType(::TestIdealFFP) = GradientField()
      MPIMagneticFields.definitionType(::TestIdealFFP) = MethodBasedFieldDefinition()
      MPIMagneticFields.timeDependencyType(::TestIdealFFP) = TimeConstant()
      MPIMagneticFields.gradientFieldType(::TestIdealFFP) = FFPGradientField()
      MPIMagneticFields.fieldMovementType(::TestIdealFFP) = NoMovement()
      
      MPIMagneticFields.value(field::TestIdealFFP, r::PT) where {T <: Number, PT <: AbstractVector{T}} = r.*field.gradient
      MPIMagneticFields.value(field::TestIdealFFP, r::PT, ϕ::RT) where {T <: Number, PT <: AbstractVector{T}, RT <: Number} = value(field, r) # We ignore the rotation for this test
      MPIMagneticFields.value(field::TestIdealFFP, r::PT, δ::TT) where {T <: Number, PT <: AbstractVector{T}, T2 <: Number, TT <: AbstractVector{T2}} = value(field, r) # We ignore the shift for this test
      MPIMagneticFields.value(field::TestIdealFFP, r::PT, ϕ::RT, δ::TT) where {T <: Number, PT <: AbstractVector{T}, RT <: Number, T2 <: Number, TT <: AbstractVector{T2}} = value(field, r, ϕ)

      field = TestIdealFFP([1, 1, 1])

      @test field isa TestIdealFFP
      @test negative(field) isa NegativeField
      @test fieldType(field) isa GradientField
      @test definitionType(field) isa MethodBasedFieldDefinition
      @test timeDependencyType(field) isa TimeConstant
      @test gradientFieldType(field) isa FFPGradientField
      @test gradientFieldType(negative(field)) isa FFPGradientField

      @test all(value(negative(field), [1, 0, 0]) .≈ [-1, 0, 0])
      @test all(value(negative(field), [0.5, 0, 0]) .≈ [-0.5, 0, 0])

      @test all(isapprox.(value(negative(field), [1, 0, 0], π/2), [-1, 0, 0], atol=1e-10))
      @test all(isapprox.(value(negative(field), [0.5, 0, 0], π/2), [-0.5, 0, 0], atol=1e-10))

      @test all(value(negative(field), [1, 0, 0], [1, 0, 0]) .≈ [-1, 0, 0])
      @test all(value(negative(field), [0.5, 0, 0], [1, 0, 0]) .≈ [-0.5, 0, 0])

      @test all(isapprox.(value(negative(field), [1, 0, 0], π/2, [1, 0, 0]), [-1, 0, 0], atol=1e-10))
      @test all(isapprox.(value(negative(field), [0.5, 0, 0], π/2, [1, 0, 0]), [-0.5, 0, 0], atol=1e-10))

      @test isRotatable(field) == false
      @test isTranslatable(field) == false
    end

    @testset "Superimposed Negative" begin
      superimposedField = fieldA - fieldB

      @test superimposedField isa SuperimposedField
      @test fieldType(superimposedField) isa HomogeneousField
      @test definitionType(superimposedField) isa MethodBasedFieldDefinition
      @test timeDependencyType(superimposedField) isa TimeConstant
      @test isnothing(gradientFieldType(superimposedField))

      @test all(value(superimposedField, [1, 0, 0]) .≈ [1, -1, 0])
      @test all(value(superimposedField, [0.5, 0, 0]) .≈ [1, -1, 0])

      @test isRotatable(superimposedField) == false
      @test isTranslatable(superimposedField) == false
    end
  end

  @testset "Movement types" begin
    mutable struct TestIdealXYRotatedTranslatedHomogeneousField{T, U} <: AbstractMagneticField where {T <: Number, U <: Number}
      amplitude::T
      direction::Vector{U}
    end

    MPIMagneticFields.fieldType(::TestIdealXYRotatedTranslatedHomogeneousField) = HomogeneousField()
    MPIMagneticFields.definitionType(::TestIdealXYRotatedTranslatedHomogeneousField) = MethodBasedFieldDefinition()
    MPIMagneticFields.timeDependencyType(::TestIdealXYRotatedTranslatedHomogeneousField) = TimeConstant()
    MPIMagneticFields.fieldMovementType(::TestIdealXYRotatedTranslatedHomogeneousField) = (RotationalMovement(), TranslationalMovement())

    MPIMagneticFields.value(field::TestIdealXYRotatedTranslatedHomogeneousField, r::PT) where {T <: Number, PT <: AbstractVector{T}} = value(field, r, 0.0) # Defaults to angle 0
    MPIMagneticFields.value(field::TestIdealXYRotatedTranslatedHomogeneousField, r::PT, ϕ::RT) where {T <: Number, PT <: AbstractVector{T}, RT <: Number} = [sin(ϕ), cos(ϕ), 0].*field.amplitude
    MPIMagneticFields.value(field::TestIdealXYRotatedTranslatedHomogeneousField, r::PT, δ::TT) where {T <: Number, PT <: AbstractVector{T}, T2 <: Number, TT <: AbstractVector{T2}} = value(field, r) # A homogeneous field is shift-invariant
    MPIMagneticFields.value(field::TestIdealXYRotatedTranslatedHomogeneousField, r::PT, ϕ::RT, δ::TT) where {T <: Number, PT <: AbstractVector{T}, RT <: Number, T2 <: Number, TT <: AbstractVector{T2}} = value(field, r, ϕ)

    fieldA = TestIdealXYRotatedTranslatedHomogeneousField(1, [1, 0, 0])
    fieldB = TestIdealXYRotatedTranslatedHomogeneousField(1, [0, 1, 0])

    superimposedField = fieldA + fieldB

    @test superimposedField isa SuperimposedField
    @test fieldType(superimposedField) isa HomogeneousField
    @test definitionType(superimposedField) isa MethodBasedFieldDefinition
    @test timeDependencyType(superimposedField) isa TimeConstant

    @test all(value(superimposedField, [1, 0, 0]) .≈ [0, 2, 0])
    @test all(value(superimposedField, [0.5, 0, 0]) .≈ [0, 2, 0])

    @test all(isapprox.(value(superimposedField, [1, 0, 0], π/2), [2, 0, 0], atol=1e-10))
    @test all(isapprox.(value(superimposedField, [0.5, 0, 0], π/2), [2, 0, 0], atol=1e-10))

    @test all(value(superimposedField, [1, 0, 0], [1, 0, 0]) .≈ [0, 2, 0])
    @test all(value(superimposedField, [0.5, 0, 0], [1, 0, 0]) .≈ [0, 2, 0])

    @test all(isapprox.(value(superimposedField, [1, 0, 0], π/2, [1, 0, 0]), [2, 0, 0], atol=1e-10))
    @test all(isapprox.(value(superimposedField, [0.5, 0, 0], π/2, [1, 0, 0]), [2, 0, 0], atol=1e-10))

    @test isRotatable(superimposedField) == true
    @test isTranslatable(superimposedField) == true
  end
end

