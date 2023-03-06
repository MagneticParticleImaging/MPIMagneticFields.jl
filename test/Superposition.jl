@testset "Superposition" begin
  mutable struct TestIdealHomogeneousField{T, U} <: AbstractMagneticField where {T <: Number, U <: Number}
    amplitude::T
    direction::Vector{U}
  end

  MPIMagneticFields.fieldType(::TestIdealHomogeneousField) = HomogeneousField()
  MPIMagneticFields.definitionType(::TestIdealHomogeneousField) = MethodBasedFieldDefinition()
  MPIMagneticFields.timeDependencyType(::TestIdealHomogeneousField) = TimeConstant()
  MPIMagneticFields.fieldMovementType(::TestIdealHomogeneousField) = NoMovement()

  MPIMagneticFields.value(field::TestIdealHomogeneousField, r) = normalize(field.direction).*field.amplitude

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
    superimposedField = fieldA - fieldB

    @test superimposedField isa SuperimposedField
    @test fieldType(superimposedField) isa HomogeneousField
    @test definitionType(superimposedField) isa MethodBasedFieldDefinition
    @test timeDependencyType(superimposedField) isa TimeConstant

    @test all(value(superimposedField, [1, 0, 0]) .≈ [1, -1, 0])
    @test all(value(superimposedField, [0.5, 0, 0]) .≈ [1, -1, 0])

    @test isRotatable(superimposedField) == false
    @test isTranslatable(superimposedField) == false
  end
end

