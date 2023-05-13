@testset "Type" begin
  @testset "Not implemented" begin
    mutable struct TestField <: AbstractMagneticField end

    testField = TestField()

    @test_throws ErrorException value(testField, [0, 0, 0])
  end

  @testset "Movement variants" begin
    mutable struct TestFieldRotatable <: AbstractMagneticField end

    MPIMagneticFields.FieldStyle(::TestFieldRotatable) = HomogeneousField()
    MPIMagneticFields.FieldDefinitionStyle(::TestFieldRotatable) = MethodBasedFieldDefinition()
    MPIMagneticFields.FieldTimeDependencyStyle(::TestFieldRotatable) = TimeConstant()
    MPIMagneticFields.FieldMovementStyle(::TestFieldRotatable) = RotationalMovement()

    mutable struct TestFieldTranslatable <: AbstractMagneticField end

    MPIMagneticFields.FieldStyle(::TestFieldTranslatable) = HomogeneousField()
    MPIMagneticFields.FieldDefinitionStyle(::TestFieldTranslatable) = MethodBasedFieldDefinition()
    MPIMagneticFields.FieldTimeDependencyStyle(::TestFieldTranslatable) = TimeConstant()
    MPIMagneticFields.FieldMovementStyle(::TestFieldTranslatable) =  TranslationalMovement()

    mutable struct TestFieldRotatableTranslatable <: AbstractMagneticField end

    MPIMagneticFields.FieldStyle(::TestFieldRotatableTranslatable) = HomogeneousField()
    MPIMagneticFields.FieldDefinitionStyle(::TestFieldRotatableTranslatable) = MethodBasedFieldDefinition()
    MPIMagneticFields.FieldTimeDependencyStyle(::TestFieldRotatableTranslatable) = TimeConstant()
    MPIMagneticFields.FieldMovementStyle(::TestFieldRotatableTranslatable) = RotationalTranslationalMovement()

    #TODO: Add tests
  end

  @testset "Time-varying" begin
    mutable struct TestFieldTimeVarying{T, U, V} <: AbstractMagneticField where {T <: Number, U <: Number, V <: Number}
      amplitude::T
      frequency::V
      direction::Vector{U}
    end

    MPIMagneticFields.FieldStyle(::TestFieldTimeVarying) = HomogeneousField()
    MPIMagneticFields.FieldDefinitionStyle(::TestFieldTimeVarying) = MethodBasedFieldDefinition()
    MPIMagneticFields.FieldTimeDependencyStyle(::TestFieldTimeVarying) = TimeVarying()
    MPIMagneticFields.FieldMovementStyle(::TestFieldTimeVarying) = NoMovement()

    MPIMagneticFields.value_(field::TestFieldTimeVarying, t, r) = normalize(field.direction).*field.amplitude.*sin.(2π*field.frequency*t)

    mutable struct TestFieldTimeVaryingRotatable <: AbstractMagneticField end

    MPIMagneticFields.FieldStyle(::TestFieldTimeVaryingRotatable) = HomogeneousField()
    MPIMagneticFields.FieldDefinitionStyle(::TestFieldTimeVaryingRotatable) = MethodBasedFieldDefinition()
    MPIMagneticFields.FieldTimeDependencyStyle(::TestFieldTimeVaryingRotatable) = TimeVarying()
    MPIMagneticFields.FieldMovementStyle(::TestFieldTimeVaryingRotatable) = RotationalMovement()

    mutable struct TestFieldTimeVaryingTranslatable <: AbstractMagneticField end

    MPIMagneticFields.FieldStyle(::TestFieldTimeVaryingTranslatable) = HomogeneousField()
    MPIMagneticFields.FieldDefinitionStyle(::TestFieldTimeVaryingTranslatable) = MethodBasedFieldDefinition()
    MPIMagneticFields.FieldTimeDependencyStyle(::TestFieldTimeVaryingTranslatable) = TimeVarying()
    MPIMagneticFields.FieldMovementStyle(::TestFieldTimeVaryingTranslatable) =  TranslationalMovement()

    mutable struct TestFieldTimeVaryingRotatableTranslatable <: AbstractMagneticField end

    MPIMagneticFields.FieldStyle(::TestFieldTimeVaryingRotatableTranslatable) = HomogeneousField()
    MPIMagneticFields.FieldDefinitionStyle(::TestFieldTimeVaryingRotatableTranslatable) = MethodBasedFieldDefinition()
    MPIMagneticFields.FieldTimeDependencyStyle(::TestFieldTimeVaryingRotatableTranslatable) = TimeVarying()
    MPIMagneticFields.FieldMovementStyle(::TestFieldTimeVaryingRotatableTranslatable) = RotationalTranslationalMovement()

    field = TestFieldTimeVarying(1, 1, [1, 0, 0])

    @test all(value(field, 1/4, [1:2, 1:2, 1:2]) .≈ [[1.0, 0.0, 0.0] for x in 1:2, y in 1:2, z in 1:2])
    @test all(value(field, 1/4, [1:2, 1, 1:2]) .≈ [[1.0, 0.0, 0.0] for x in 1:2, y in 1:1, z in 1:2])
    @test all(value(field, 0, [1:2, 1:2, 1:2]) .≈ [[0.0, 0.0, 0.0] for x in 1:2, y in 1:2, z in 1:2])
    @test all(value(field, 0, [1:2, 1, 1:2]) .≈ [[0.0, 0.0, 0.0] for x in 1:2, y in 1:1, z in 1:2])

    #TODO: add other tests
  end

  @testset "Ranges" begin
    mutable struct TestRangesIdealHomogeneousField{T, U} <: AbstractMagneticField where {T <: Number, U <: Number}
      amplitude::T
      direction::Vector{U}
    end

    MPIMagneticFields.FieldStyle(::TestRangesIdealHomogeneousField) = HomogeneousField()
    MPIMagneticFields.FieldDefinitionStyle(::TestRangesIdealHomogeneousField) = MethodBasedFieldDefinition()
    MPIMagneticFields.FieldTimeDependencyStyle(::TestRangesIdealHomogeneousField) = TimeConstant()
    MPIMagneticFields.FieldMovementStyle(::TestRangesIdealHomogeneousField) = RotationalTranslationalMovement()

    MPIMagneticFields.value_(field::TestRangesIdealHomogeneousField, r, ϕ, δ) = normalize(field.direction).*field.amplitude # A homogeneous field is shift-invariant

    field = TestRangesIdealHomogeneousField(1, [1, 0, 0])

    @test all(value(field, [1:2, 1:2, 1:2], 0.0, [1, 0, 0]) .≈ [[1.0, 0.0, 0.0] for x in 1:2, y in 1:2, z in 1:2])
    @test all(value(field, [1:2, 1, 1:2], 0.0, [1, 0, 0]) .≈ [[1.0, 0.0, 0.0] for x in 1:2, y in 1:1, z in 1:2])
  end

  
end