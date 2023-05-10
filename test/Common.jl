@testset "Common" begin
  @testset "Indexing" begin
    mutable struct TestIdealHomogeneousField{T, U} <: AbstractMagneticField where {T <: Number, U <: Number}
      amplitude::T
      direction::Vector{U}
    end

    MPIMagneticFields.fieldType(::TestIdealHomogeneousField) = HomogeneousField()
    MPIMagneticFields.definitionType(::TestIdealHomogeneousField) = MethodBasedFieldDefinition()
    MPIMagneticFields.timeDependencyType(::TestIdealHomogeneousField) = TimeConstant()
    MPIMagneticFields.fieldMovementType(::TestIdealHomogeneousField) = NoMovement()

    MPIMagneticFields.value(field::TestIdealHomogeneousField, ::PT) where {T <: Number, PT <: AbstractVector{T}} = normalize(field.direction).*field.amplitude
    
    field = TestIdealHomogeneousField(1, [1, 0, 0])
    
    @test all(field[1, 0, 0] .≈ [1, 0, 0])
    @test all(field[0.5, 0, 0] .≈ [1, 0, 0])
    
    @test Base.IndexStyle(TestIdealHomogeneousField) isa IndexCartesian
  end

  @testset "Time-varying indexing" begin
    mutable struct TestIdealHomogeneousFieldTimeVarying{T, U, V} <: AbstractMagneticField where {T <: Number, U <: Number, V <: Number}
      amplitude::T
      frequency::V
      direction::Vector{U}
    end

    MPIMagneticFields.fieldType(::TestIdealHomogeneousFieldTimeVarying) = HomogeneousField()
    MPIMagneticFields.definitionType(::TestIdealHomogeneousFieldTimeVarying) = MethodBasedFieldDefinition()
    MPIMagneticFields.timeDependencyType(::TestIdealHomogeneousFieldTimeVarying) = TimeVarying()
    MPIMagneticFields.fieldMovementType(::TestIdealHomogeneousFieldTimeVarying) = NoMovement()

    MPIMagneticFields.value(field::TestIdealHomogeneousFieldTimeVarying, t::VT, ::PT) where {VT <: Number, T <: Number, PT <: AbstractVector{T}} = normalize(field.direction).*field.amplitude.*sin.(2π*field.frequency*t)
    
    field = TestIdealHomogeneousFieldTimeVarying(1, 1, [1, 0, 0])
    
    @test all(field[1/4, 1, 0, 0] .≈ [1, 0, 0])
    @test all(field[1/4, 0.5, 0, 0] .≈ [1, 0, 0])
    
    @test Base.IndexStyle(TestIdealHomogeneousFieldTimeVarying) isa IndexCartesian
  end
end