@testset "Common" begin
  @testset "Indexing" begin
    @testset "No movement" begin
      mutable struct TestIndexingIdealHomogeneousField{AT, DT} <:
                     AbstractMagneticField where {AT <: Number, U <: Number, DT <: AbstractArray{U}}
        amplitude::AT
        direction::DT
      end

      MPIMagneticFields.FieldStyle(::TestIndexingIdealHomogeneousField) = HomogeneousField()
      function MPIMagneticFields.FieldDefinitionStyle(::TestIndexingIdealHomogeneousField)
        return MethodBasedFieldDefinition()
      end
      MPIMagneticFields.FieldTimeDependencyStyle(::TestIndexingIdealHomogeneousField) = TimeConstant()
      MPIMagneticFields.FieldMovementStyle(::TestIndexingIdealHomogeneousField) = NoMovement()

      function MPIMagneticFields.value_(field::TestIndexingIdealHomogeneousField, r)
        return normalize(field.direction) .* field.amplitude
      end

      field = TestIndexingIdealHomogeneousField(1, [1, 0, 0])

      @test all(field[1, 0, 0] .≈ [1, 0, 0])
      @test all(field[0.5, 0, 0] .≈ [1, 0, 0])

      @test Base.IndexStyle(TestIndexingIdealHomogeneousField) isa IndexCartesian
    end

    @testset "Rotational movement" begin
      mutable struct TestIndexingIdealHomogeneousField{AT, DT} <:
                     AbstractMagneticField where {AT <: Number, U <: Number, DT <: AbstractArray{U}}
        amplitude::AT
        direction::DT
      end

      MPIMagneticFields.FieldStyle(::TestIndexingIdealHomogeneousField) = HomogeneousField()
      function MPIMagneticFields.FieldDefinitionStyle(::TestIndexingIdealHomogeneousField)
        return MethodBasedFieldDefinition()
      end
      MPIMagneticFields.FieldTimeDependencyStyle(::TestIndexingIdealHomogeneousField) = TimeConstant()
      MPIMagneticFields.FieldMovementStyle(::TestIndexingIdealHomogeneousField) = NoMovement()

      function MPIMagneticFields.value_(field::TestIndexingIdealHomogeneousField, r)
        return normalize(field.direction) .* field.amplitude
      end

      field = TestIndexingIdealHomogeneousField(1, [1, 0, 0])

      @test all(field[1, 0, 0] .≈ [1, 0, 0])
      @test all(field[0.5, 0, 0] .≈ [1, 0, 0])

      @test Base.IndexStyle(TestIndexingIdealHomogeneousField) isa IndexCartesian
    end
  end

  @testset "Time-varying indexing" begin
    mutable struct TestIdealHomogeneousFieldTimeVarying{AT, FT, DT} <: AbstractMagneticField where {
      AT <: Number,
      FT <: Number,
      U <: Number,
      DT <: AbstractArray{U},
    }
      amplitude::AT
      frequency::FT
      direction::DT
    end

    MPIMagneticFields.FieldStyle(::TestIdealHomogeneousFieldTimeVarying) = HomogeneousField()
    function MPIMagneticFields.FieldDefinitionStyle(::TestIdealHomogeneousFieldTimeVarying)
      return MethodBasedFieldDefinition()
    end
    MPIMagneticFields.FieldTimeDependencyStyle(::TestIdealHomogeneousFieldTimeVarying) = TimeVarying()
    MPIMagneticFields.FieldMovementStyle(::TestIdealHomogeneousFieldTimeVarying) = NoMovement()

    function MPIMagneticFields.value_(field::TestIdealHomogeneousFieldTimeVarying, t, r)
      return normalize(field.direction) .* field.amplitude .* sin.(2π * field.frequency * t)
    end

    field = TestIdealHomogeneousFieldTimeVarying(1, 1, [1, 0, 0])

    @test all(field[1 / 4, 1, 0, 0] .≈ [1, 0, 0])
    @test all(field[1 / 4, 0.5, 0, 0] .≈ [1, 0, 0])

    @test Base.IndexStyle(TestIdealHomogeneousFieldTimeVarying) isa IndexCartesian
  end

  @testset "Dispatch" begin
    for timeDependency ∈ [TimeConstant, TimeVarying]
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

      for rotationalDimensionalityStyle ∈ [
        RotationalDimensionalityStyle{OneDimensional},
        RotationalDimensionalityStyle{TwoDimensional},
        RotationalDimensionalityStyle{ThreeDimensional},
      ]
        @testset "Rotational movement ($timeDependency, $(rotationalDimensionalityStyle.parameters[1]))" begin
          struct TestIndexingRotationalMovement <: AbstractMagneticField end
          MPIMagneticFields.FieldTimeDependencyStyle(::TestIndexingRotationalMovement) = timeDependency()
          MPIMagneticFields.FieldMovementStyle(::TestIndexingRotationalMovement) = RotationalMovement()
          function MPIMagneticFields.RotationalDimensionalityStyle(
            ::RotationalMovement,
            field::TestIndexingRotationalMovement,
          )
            return rotationalDimensionalityStyle()
          end
          MPIMagneticFields.value_(::TestIndexingRotationalMovement, args...) = args

          field = TestIndexingRotationalMovement()
          t = 0
          r = [1, 2, 3]
          ϕ = collect(4:(3 + length(rotationalDimensionalityStyle)))
          if timeDependency == TimeConstant
            @test field[r..., ϕ...] == tuple(r, ϕ)
          elseif timeDependency == TimeVarying
            @test field[t, r..., ϕ...] == tuple(t, r, ϕ)
          end
        end
      end

      for translationalDimensionalityStyle ∈ [
        TranslationalDimensionalityStyle{OneDimensional},
        TranslationalDimensionalityStyle{TwoDimensional},
        TranslationalDimensionalityStyle{ThreeDimensional},
      ]
        @testset "Translational movement ($timeDependency, $(translationalDimensionalityStyle.parameters[1]))" begin
          struct TestIndexingTranslationalMovement <: AbstractMagneticField end
          MPIMagneticFields.FieldTimeDependencyStyle(::TestIndexingTranslationalMovement) = timeDependency()
          MPIMagneticFields.FieldMovementStyle(::TestIndexingTranslationalMovement) = TranslationalMovement()
          function MPIMagneticFields.TranslationalDimensionalityStyle(
            ::TranslationalMovement,
            field::TestIndexingTranslationalMovement,
          )
            return translationalDimensionalityStyle()
          end
          MPIMagneticFields.value_(::TestIndexingTranslationalMovement, args...) = args

          field = TestIndexingTranslationalMovement()
          t = 0
          r = [1, 2, 3]
          δ = collect(4:(3 + length(translationalDimensionalityStyle)))
          if timeDependency == TimeConstant
            @test field[r..., δ...] == tuple(r, δ)
          elseif timeDependency == TimeVarying
            @test field[t, r..., δ...] == tuple(t, r, δ)
          end
        end
      end

      for rotationalDimensionalityStyle ∈ [
        RotationalDimensionalityStyle{OneDimensional},
        RotationalDimensionalityStyle{TwoDimensional},
        RotationalDimensionalityStyle{ThreeDimensional},
      ]
        for translationalDimensionalityStyle ∈ [
          TranslationalDimensionalityStyle{OneDimensional},
          TranslationalDimensionalityStyle{TwoDimensional},
          TranslationalDimensionalityStyle{ThreeDimensional},
        ]
          @testset "Rotational and translational movement ($timeDependency, $(rotationalDimensionalityStyle.parameters[1]), $(translationalDimensionalityStyle.parameters[1]))" begin
            struct TestIndexingRotationalTranslationalMovement <: AbstractMagneticField end
            function MPIMagneticFields.FieldTimeDependencyStyle(::TestIndexingRotationalTranslationalMovement)
              return timeDependency()
            end
            function MPIMagneticFields.FieldMovementStyle(::TestIndexingRotationalTranslationalMovement)
              return RotationalTranslationalMovement()
            end
            function MPIMagneticFields.RotationalDimensionalityStyle(
              ::RotationalMovement,
              field::TestIndexingRotationalTranslationalMovement,
            )
              return rotationalDimensionalityStyle()
            end
            function MPIMagneticFields.RotationalDimensionalityStyle(
              ::RotationalTranslationalMovement,
              field::TestIndexingRotationalTranslationalMovement,
            )
              return rotationalDimensionalityStyle()
            end
            function MPIMagneticFields.TranslationalDimensionalityStyle(
              ::RotationalTranslationalMovement,
              field::TestIndexingRotationalTranslationalMovement,
            )
              return translationalDimensionalityStyle()
            end
            MPIMagneticFields.value_(::TestIndexingRotationalTranslationalMovement, args...) = args

            field = TestIndexingRotationalTranslationalMovement()
            t = 0
            r = [1, 2, 3]
            ϕ = collect(4:(3 + length(rotationalDimensionalityStyle)))
            δ = collect(
              (4 + length(rotationalDimensionalityStyle)):(3 + length(rotationalDimensionalityStyle) + length(
                translationalDimensionalityStyle,
              )),
            )
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
