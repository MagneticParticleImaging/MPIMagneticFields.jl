@testset "Common" begin
  @testset "Indexing" begin
    @testset "No movement" begin
      mutable struct TestIndexingIdealHomogeneousField{AT, DT} <: AbstractMagneticField where {AT <: Number, U <: Number, DT <: AbstractArray{U}}
        amplitude::AT
        direction::DT
      end

      MPIMagneticFields.FieldStyle(::TestIndexingIdealHomogeneousField) = HomogeneousField()
      MPIMagneticFields.FieldDefinitionStyle(::TestIndexingIdealHomogeneousField) = MethodBasedFieldDefinition()
      MPIMagneticFields.FieldTimeDependencyStyle(::TestIndexingIdealHomogeneousField) = TimeConstant()
      MPIMagneticFields.FieldMovementStyle(::TestIndexingIdealHomogeneousField) = NoMovement()

      MPIMagneticFields.value_(field::TestIndexingIdealHomogeneousField, r) = normalize(field.direction).*field.amplitude
      
      field = TestIndexingIdealHomogeneousField(1, [1, 0, 0])
      
      @test all(field[1, 0, 0] .≈ [1, 0, 0])
      @test all(field[0.5, 0, 0] .≈ [1, 0, 0])
      
      @test Base.IndexStyle(TestIndexingIdealHomogeneousField) isa IndexCartesian
    end

    @testset "Rotational movement" begin
      mutable struct TestIndexingIdealHomogeneousField{AT, DT} <: AbstractMagneticField where {AT <: Number, U <: Number, DT <: AbstractArray{U}}
        amplitude::AT
        direction::DT
      end

      MPIMagneticFields.FieldStyle(::TestIndexingIdealHomogeneousField) = HomogeneousField()
      MPIMagneticFields.FieldDefinitionStyle(::TestIndexingIdealHomogeneousField) = MethodBasedFieldDefinition()
      MPIMagneticFields.FieldTimeDependencyStyle(::TestIndexingIdealHomogeneousField) = TimeConstant()
      MPIMagneticFields.FieldMovementStyle(::TestIndexingIdealHomogeneousField) = NoMovement()

      MPIMagneticFields.value_(field::TestIndexingIdealHomogeneousField, r) = normalize(field.direction).*field.amplitude
      
      field = TestIndexingIdealHomogeneousField(1, [1, 0, 0])
      
      @test all(field[1, 0, 0] .≈ [1, 0, 0])
      @test all(field[0.5, 0, 0] .≈ [1, 0, 0])
      
      @test Base.IndexStyle(TestIndexingIdealHomogeneousField) isa IndexCartesian
    end
  end

  @testset "Time-varying indexing" begin
    mutable struct TestIdealHomogeneousFieldTimeVarying{AT, FT, DT} <: AbstractMagneticField where {AT <: Number, FT <: Number, U <: Number, DT <: AbstractArray{U}}
      amplitude::AT
      frequency::FT
      direction::DT
    end

    MPIMagneticFields.FieldStyle(::TestIdealHomogeneousFieldTimeVarying) = HomogeneousField()
    MPIMagneticFields.FieldDefinitionStyle(::TestIdealHomogeneousFieldTimeVarying) = MethodBasedFieldDefinition()
    MPIMagneticFields.FieldTimeDependencyStyle(::TestIdealHomogeneousFieldTimeVarying) = TimeVarying()
    MPIMagneticFields.FieldMovementStyle(::TestIdealHomogeneousFieldTimeVarying) = NoMovement()

    MPIMagneticFields.value_(field::TestIdealHomogeneousFieldTimeVarying, t, r) = normalize(field.direction).*field.amplitude.*sin.(2π*field.frequency*t)
    
    field = TestIdealHomogeneousFieldTimeVarying(1, 1, [1, 0, 0])
    
    @test all(field[1/4, 1, 0, 0] .≈ [1, 0, 0])
    @test all(field[1/4, 0.5, 0, 0] .≈ [1, 0, 0])
    
    @test Base.IndexStyle(TestIdealHomogeneousFieldTimeVarying) isa IndexCartesian
  end
end