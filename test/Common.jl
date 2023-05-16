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

  @testset "Dispatch" begin
    for timeDependency in [TimeConstant, TimeVarying]
      @testset "No movement ($timeDependency)" begin
        struct TestIndexingNoMovement <: AbstractMagneticField end
        MPIMagneticFields.FieldTimeDependencyStyle(::TestIndexingNoMovement) = timeDependency()
        MPIMagneticFields.FieldMovementStyle(::TestIndexingNoMovement) = NoMovement()
        MPIMagneticFields.value_(::TestIndexingNoMovement, args...) = args

        field = TestIndexingNoMovement()
        t = 0
        r = [0, 0, 0]
        if timeDependency == TimeConstant
          @test field[r...] == tuple(r)
        elseif timeDependency == TimeVarying
          @test field[t, r...] == tuple(t, r)
        end
      end
      
      for rotationalDimensionalityStyle in [RotationalDimensionalityStyle{OneDimensional}, RotationalDimensionalityStyle{TwoDimensional}, RotationalDimensionalityStyle{ThreeDimensional}]
        @testset "Rotational movement ($timeDependency, $(rotationalDimensionalityStyle.parameters[1]))" begin
          struct TestIndexingRotationalMovement <: AbstractMagneticField end
          MPIMagneticFields.FieldTimeDependencyStyle(::TestIndexingRotationalMovement) = timeDependency()
          MPIMagneticFields.FieldMovementStyle(::TestIndexingRotationalMovement) = RotationalMovement()
          MPIMagneticFields.RotationalDimensionalityStyle(::RotationalMovement, field::TestIndexingRotationalMovement) = rotationalDimensionalityStyle()
          MPIMagneticFields.value_(::TestIndexingRotationalMovement, args...) = args
      
          field = TestIndexingRotationalMovement()
          t = 0
          r = [1, 2, 3]
          ϕ = collect(4:3+length(rotationalDimensionalityStyle))
          if timeDependency == TimeConstant
            @test field[r..., ϕ...] == tuple(r, ϕ)
          elseif timeDependency == TimeVarying
            @test field[t, r..., ϕ...] == tuple(t, r, ϕ)
          end
        end
      end
    
      for translationalDimensionalityStyle in [TranslationalDimensionalityStyle{OneDimensional}, TranslationalDimensionalityStyle{TwoDimensional}, TranslationalDimensionalityStyle{ThreeDimensional}]
        @testset "Translational movement ($timeDependency, $(translationalDimensionalityStyle.parameters[1]))" begin
          struct TestIndexingTranslationalMovement <: AbstractMagneticField end
          MPIMagneticFields.FieldTimeDependencyStyle(::TestIndexingTranslationalMovement) = timeDependency()
          MPIMagneticFields.FieldMovementStyle(::TestIndexingTranslationalMovement) = TranslationalMovement()
          MPIMagneticFields.TranslationalDimensionalityStyle(::TranslationalMovement, field::TestIndexingTranslationalMovement) = translationalDimensionalityStyle()
          MPIMagneticFields.value_(::TestIndexingTranslationalMovement, args...) = args
      
          field = TestIndexingTranslationalMovement()
          t = 0
          r = [1, 2, 3]
          δ = collect(4:3+length(translationalDimensionalityStyle))
          if timeDependency == TimeConstant
            @test field[r..., δ...] == tuple(r, δ)
          elseif timeDependency == TimeVarying
            @test field[t, r..., δ...] == tuple(t, r, δ)
          end
        end
      end
    
      for rotationalDimensionalityStyle in [RotationalDimensionalityStyle{OneDimensional}, RotationalDimensionalityStyle{TwoDimensional}, RotationalDimensionalityStyle{ThreeDimensional}]
        for translationalDimensionalityStyle in [TranslationalDimensionalityStyle{OneDimensional}, TranslationalDimensionalityStyle{TwoDimensional}, TranslationalDimensionalityStyle{ThreeDimensional}]
          @testset "Rotational and translational movement ($timeDependency, $(rotationalDimensionalityStyle.parameters[1]), $(translationalDimensionalityStyle.parameters[1]))" begin
            struct TestIndexingRotationalTranslationalMovement <: AbstractMagneticField end
            MPIMagneticFields.FieldTimeDependencyStyle(::TestIndexingRotationalTranslationalMovement) = timeDependency()
            MPIMagneticFields.FieldMovementStyle(::TestIndexingRotationalTranslationalMovement) = RotationalTranslationalMovement()
            MPIMagneticFields.RotationalDimensionalityStyle(::RotationalMovement, field::TestIndexingRotationalTranslationalMovement) = rotationalDimensionalityStyle()
            MPIMagneticFields.RotationalDimensionalityStyle(::RotationalTranslationalMovement, field::TestIndexingRotationalTranslationalMovement) = rotationalDimensionalityStyle()
            MPIMagneticFields.TranslationalDimensionalityStyle(::RotationalTranslationalMovement, field::TestIndexingRotationalTranslationalMovement) = translationalDimensionalityStyle()
            MPIMagneticFields.value_(::TestIndexingRotationalTranslationalMovement, args...) = args
      
            field = TestIndexingRotationalTranslationalMovement()
            t = 0
            r = [1, 2, 3]
            ϕ = collect(4:3+length(rotationalDimensionalityStyle))
            δ = collect(4+length(rotationalDimensionalityStyle):3+length(rotationalDimensionalityStyle)+length(translationalDimensionalityStyle))
            if timeDependency == TimeConstant
              @test field[r..., ϕ..., δ...] == tuple(r, ϕ, δ)
            elseif timeDependency == TimeVarying
              @test field[t, r..., ϕ..., δ...] == tuple(t, r, ϕ, δ)
            end
          end
        end
      end
    end
  end
end