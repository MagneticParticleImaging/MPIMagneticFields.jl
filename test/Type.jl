@testset "Type" begin
  @testset "Not implemented" begin
    mutable struct TestField <: AbstractMagneticField end

    testField = TestField()

    @test_throws ErrorException("Not yet implemented") value(testField, [0, 0, 0])
    @test_throws ErrorException("Not yet implemented") value(testField, [0, 0, 0], 0.0)
    @test_throws ErrorException("Not yet implemented") value(testField, [0, 0, 0], [0.0, 0.0, 0.0])
    @test_throws ErrorException("Not yet implemented") value(testField, [0, 0, 0], 0.0, [0.0, 0.0, 0.0])
  end

  @testset "Movement variants" begin
    mutable struct TestFieldRotatable <: AbstractMagneticField end

    MPIMagneticFields.fieldType(::TestFieldRotatable) = HomogeneousField()
    MPIMagneticFields.definitionType(::TestFieldRotatable) = MethodBasedFieldDefinition()
    MPIMagneticFields.timeDependencyType(::TestFieldRotatable) = TimeConstant()
    MPIMagneticFields.fieldMovementType(::TestFieldRotatable) = RotationalMovement()

    mutable struct TestFieldTranslatable <: AbstractMagneticField end

    MPIMagneticFields.fieldType(::TestFieldTranslatable) = HomogeneousField()
    MPIMagneticFields.definitionType(::TestFieldTranslatable) = MethodBasedFieldDefinition()
    MPIMagneticFields.timeDependencyType(::TestFieldTranslatable) = TimeConstant()
    MPIMagneticFields.fieldMovementType(::TestFieldTranslatable) =  TranslationalMovement()

    mutable struct TestFieldRotatableTranslatable <: AbstractMagneticField end

    MPIMagneticFields.fieldType(::TestFieldRotatableTranslatable) = HomogeneousField()
    MPIMagneticFields.definitionType(::TestFieldRotatableTranslatable) = MethodBasedFieldDefinition()
    MPIMagneticFields.timeDependencyType(::TestFieldRotatableTranslatable) = TimeConstant()
    MPIMagneticFields.fieldMovementType(::TestFieldRotatableTranslatable) = (RotationalMovement(), TranslationalMovement())

    @test_throws ErrorException("Not yet implemented") value(TestFieldRotatable(), [0, 0, 0], 0.0, [0.0, 0.0, 0.0])
    @test_throws ErrorException("Not yet implemented") value(TestFieldTranslatable(), [0, 0, 0], 0.0, [0.0, 0.0, 0.0])
    @test_throws ErrorException("Not yet implemented") value(TestFieldRotatableTranslatable(), [0, 0, 0], 0.0, [0.0, 0.0, 0.0])
  end

  @testset "Time-varying" begin
    mutable struct TestFieldTimeVarying{T, U, V} <: AbstractMagneticField where {T <: Number, U <: Number, V <: Number}
      amplitude::T
      frequency::V
      direction::Vector{U}
    end

    MPIMagneticFields.fieldType(::TestFieldTimeVarying) = HomogeneousField()
    MPIMagneticFields.definitionType(::TestFieldTimeVarying) = MethodBasedFieldDefinition()
    MPIMagneticFields.timeDependencyType(::TestFieldTimeVarying) = TimeVarying()
    MPIMagneticFields.fieldMovementType(::TestFieldTimeVarying) = NoMovement()

    MPIMagneticFields.value(field::TestFieldTimeVarying, t::VT, ::PT) where {VT <: Number, T <: Number, PT <: AbstractVector{T}} = normalize(field.direction).*field.amplitude.*sin.(2π*field.frequency*t)

    mutable struct TestFieldTimeVaryingRotatable <: AbstractMagneticField end

    MPIMagneticFields.fieldType(::TestFieldTimeVaryingRotatable) = HomogeneousField()
    MPIMagneticFields.definitionType(::TestFieldTimeVaryingRotatable) = MethodBasedFieldDefinition()
    MPIMagneticFields.timeDependencyType(::TestFieldTimeVaryingRotatable) = TimeVarying()
    MPIMagneticFields.fieldMovementType(::TestFieldTimeVaryingRotatable) = RotationalMovement()

    mutable struct TestFieldTimeVaryingTranslatable <: AbstractMagneticField end

    MPIMagneticFields.fieldType(::TestFieldTimeVaryingTranslatable) = HomogeneousField()
    MPIMagneticFields.definitionType(::TestFieldTimeVaryingTranslatable) = MethodBasedFieldDefinition()
    MPIMagneticFields.timeDependencyType(::TestFieldTimeVaryingTranslatable) = TimeVarying()
    MPIMagneticFields.fieldMovementType(::TestFieldTimeVaryingTranslatable) =  TranslationalMovement()

    mutable struct TestFieldTimeVaryingRotatableTranslatable <: AbstractMagneticField end

    MPIMagneticFields.fieldType(::TestFieldTimeVaryingRotatableTranslatable) = HomogeneousField()
    MPIMagneticFields.definitionType(::TestFieldTimeVaryingRotatableTranslatable) = MethodBasedFieldDefinition()
    MPIMagneticFields.timeDependencyType(::TestFieldTimeVaryingRotatableTranslatable) = TimeVarying()
    MPIMagneticFields.fieldMovementType(::TestFieldTimeVaryingRotatableTranslatable) = (RotationalMovement(), TranslationalMovement())

    field = TestFieldTimeVarying(1, 1, [1, 0, 0])

    @test all(value(field, 1/4, [1:2, 1:2, 1:2]) .≈ [[1.0, 0.0, 0.0] for x in 1:2, y in 1:2, z in 1:2])
    @test all(value(field, 1/4, [1:2, 1:2, 1:2], 0.0) .≈ [[1.0, 0.0, 0.0] for x in 1:2, y in 1:2, z in 1:2])
    @test all(value(field, 1/4, [1:2, 1:2, 1:2], [1, 0, 0]) .≈ [[1.0, 0.0, 0.0] for x in 1:2, y in 1:2, z in 1:2])
    @test all(value(field, 1/4, [1:2, 1:2, 1:2], 0.0, [1, 0, 0]) .≈ [[1.0, 0.0, 0.0] for x in 1:2, y in 1:2, z in 1:2])

    @test all(value(field, 1/4, [1:2, 1, 1:2]) .≈ [[1.0, 0.0, 0.0] for x in 1:2, y in 1:1, z in 1:2])
    @test all(value(field, 1/4, [1:2, 1, 1:2], 0.0) .≈ [[1.0, 0.0, 0.0] for x in 1:2, y in 1:1, z in 1:2])
    @test all(value(field, 1/4, [1:2, 1, 1:2], [1, 0, 0]) .≈ [[1.0, 0.0, 0.0] for x in 1:2, y in 1:1, z in 1:2])
    @test all(value(field, 1/4, [1:2, 1, 1:2], 0.0, [1, 0, 0]) .≈ [[1.0, 0.0, 0.0] for x in 1:2, y in 1:1, z in 1:2])

    @test all(value(field, 0, [1:2, 1:2, 1:2]) .≈ [[0.0, 0.0, 0.0] for x in 1:2, y in 1:2, z in 1:2])
    @test all(value(field, 0, [1:2, 1:2, 1:2], 0.0) .≈ [[0.0, 0.0, 0.0] for x in 1:2, y in 1:2, z in 1:2])
    @test all(value(field, 0, [1:2, 1:2, 1:2], [1, 0, 0]) .≈ [[0.0, 0.0, 0.0] for x in 1:2, y in 1:2, z in 1:2])
    @test all(value(field, 0, [1:2, 1:2, 1:2], 0.0, [1, 0, 0]) .≈ [[0.0, 0.0, 0.0] for x in 1:2, y in 1:2, z in 1:2])

    @test all(value(field, 0, [1:2, 1, 1:2]) .≈ [[0.0, 0.0, 0.0] for x in 1:2, y in 1:1, z in 1:2])
    @test all(value(field, 0, [1:2, 1, 1:2], 0.0) .≈ [[0.0, 0.0, 0.0] for x in 1:2, y in 1:1, z in 1:2])
    @test all(value(field, 0, [1:2, 1, 1:2], [1, 0, 0]) .≈ [[0.0, 0.0, 0.0] for x in 1:2, y in 1:1, z in 1:2])
    @test all(value(field, 0, [1:2, 1, 1:2], 0.0, [1, 0, 0]) .≈ [[0.0, 0.0, 0.0] for x in 1:2, y in 1:1, z in 1:2])

    @test_throws ErrorException("Not yet implemented") value(TestFieldTimeVaryingRotatable(), [0, 0, 0], 0.0, [0.0, 0.0, 0.0])
    @test_throws ErrorException("Not yet implemented") value(TestFieldTimeVaryingTranslatable(), [0, 0, 0], 0.0, [0.0, 0.0, 0.0])
    @test_throws ErrorException("Not yet implemented") value(TestFieldTimeVaryingRotatableTranslatable(), [0, 0, 0], 0.0, [0.0, 0.0, 0.0])
  end

  @testset "Ranges" begin
    mutable struct TestIdealHomogeneousField{T, U} <: AbstractMagneticField where {T <: Number, U <: Number}
      amplitude::T
      direction::Vector{U}
    end

    MPIMagneticFields.fieldType(::TestIdealHomogeneousField) = HomogeneousField()
    MPIMagneticFields.definitionType(::TestIdealHomogeneousField) = MethodBasedFieldDefinition()
    MPIMagneticFields.timeDependencyType(::TestIdealHomogeneousField) = TimeConstant()
    MPIMagneticFields.fieldMovementType(::TestIdealHomogeneousField) = (RotationalMovement(), TranslationalMovement())

    MPIMagneticFields.value(field::TestIdealHomogeneousField, ::PT) where {T <: Number, PT <: AbstractVector{T}} = normalize(field.direction).*field.amplitude
    MPIMagneticFields.value(field::TestIdealHomogeneousField, r::PT, ϕ::RT) where {T <: Number, PT <: AbstractVector{T}, RT <: Number} = value(field, r)
    MPIMagneticFields.value(field::TestIdealHomogeneousField, r::PT, δ::TT) where {T <: Number, PT <: AbstractVector{T}, T2 <: Number, TT <: AbstractVector{T2}} = value(field, r) # A homogeneous field is shift-invariant
    MPIMagneticFields.value(field::TestIdealHomogeneousField, r::PT, ϕ::RT, δ::TT) where {T <: Number, PT <: AbstractVector{T}, RT <: Number, T2 <: Number, TT <: AbstractVector{T2}} = value(field, r, ϕ)

    field = TestIdealHomogeneousField(1, [1, 0, 0])

    @test all(value(field, [1:2, 1:2, 1:2]) .≈ [[1.0, 0.0, 0.0] for x in 1:2, y in 1:2, z in 1:2])
    @test all(value(field, [1:2, 1:2, 1:2], 0.0) .≈ [[1.0, 0.0, 0.0] for x in 1:2, y in 1:2, z in 1:2])
    @test all(value(field, [1:2, 1:2, 1:2], [1, 0, 0]) .≈ [[1.0, 0.0, 0.0] for x in 1:2, y in 1:2, z in 1:2])
    @test all(value(field, [1:2, 1:2, 1:2], 0.0, [1, 0, 0]) .≈ [[1.0, 0.0, 0.0] for x in 1:2, y in 1:2, z in 1:2])

    @test all(value(field, [1:2, 1, 1:2]) .≈ [[1.0, 0.0, 0.0] for x in 1:2, y in 1:1, z in 1:2])
    @test all(value(field, [1:2, 1, 1:2], 0.0) .≈ [[1.0, 0.0, 0.0] for x in 1:2, y in 1:1, z in 1:2])
    @test all(value(field, [1:2, 1, 1:2], [1, 0, 0]) .≈ [[1.0, 0.0, 0.0] for x in 1:2, y in 1:1, z in 1:2])
    @test all(value(field, [1:2, 1, 1:2], 0.0, [1, 0, 0]) .≈ [[1.0, 0.0, 0.0] for x in 1:2, y in 1:1, z in 1:2])
  end

  
end