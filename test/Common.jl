@testset "Common" begin
  @testset "Indexing" begin
    @testset "No movement" begin
      mutable struct NoMovementTestIndexingIdealHomogeneousField{AT, DT} <:
                     AbstractMagneticField where {AT <: Number, U <: Number, DT <: AbstractArray{U}}
        amplitude::AT
        direction::DT
      end

      MPIMagneticFields.FieldStyle(::NoMovementTestIndexingIdealHomogeneousField) = HomogeneousField()
      function MPIMagneticFields.FieldDefinitionStyle(::NoMovementTestIndexingIdealHomogeneousField)
        return MethodBasedFieldDefinition()
      end
      MPIMagneticFields.FieldTimeDependencyStyle(::NoMovementTestIndexingIdealHomogeneousField) = TimeConstant()
      MPIMagneticFields.FieldMovementStyle(::NoMovementTestIndexingIdealHomogeneousField) = NoMovement()

      function MPIMagneticFields.value_(field::NoMovementTestIndexingIdealHomogeneousField, r)
        return normalize(field.direction) .* field.amplitude
      end

      field = NoMovementTestIndexingIdealHomogeneousField(1, [1, 0, 0])

      @test all(field[1, 0, 0] .≈ [1, 0, 0])
      @test all(field[0.5, 0, 0] .≈ [1, 0, 0])

      @test Base.IndexStyle(NoMovementTestIndexingIdealHomogeneousField) isa IndexCartesian
    end

    @testset "Rotational movement" begin
      mutable struct RotationalTestIndexingIdealHomogeneousField{AT, DT} <:
                     AbstractMagneticField where {AT <: Number, U <: Number, DT <: AbstractArray{U}}
        amplitude::AT
        direction::DT
      end

      MPIMagneticFields.FieldStyle(::RotationalTestIndexingIdealHomogeneousField) = HomogeneousField()
      function MPIMagneticFields.FieldDefinitionStyle(::RotationalTestIndexingIdealHomogeneousField)
        return MethodBasedFieldDefinition()
      end
      MPIMagneticFields.FieldTimeDependencyStyle(::RotationalTestIndexingIdealHomogeneousField) = TimeConstant()
      MPIMagneticFields.FieldMovementStyle(::RotationalTestIndexingIdealHomogeneousField) = NoMovement()

      function MPIMagneticFields.value_(field::RotationalTestIndexingIdealHomogeneousField, r)
        return normalize(field.direction) .* field.amplitude
      end

      field = RotationalTestIndexingIdealHomogeneousField(1, [1, 0, 0])

      @test all(field[1, 0, 0] .≈ [1, 0, 0])
      @test all(field[0.5, 0, 0] .≈ [1, 0, 0])

      @test Base.IndexStyle(RotationalTestIndexingIdealHomogeneousField) isa IndexCartesian
    end
  end

  @testset "Time-varying indexing" begin
    mutable struct TimeVaryingIndexingTestIdealHomogeneousFieldTimeVarying{AT, FT, DT} <: AbstractMagneticField where {
      AT <: Number,
      FT <: Number,
      U <: Number,
      DT <: AbstractArray{U},
    }
      amplitude::AT
      frequency::FT
      direction::DT
    end

    MPIMagneticFields.FieldStyle(::TimeVaryingIndexingTestIdealHomogeneousFieldTimeVarying) = HomogeneousField()
    function MPIMagneticFields.FieldDefinitionStyle(::TimeVaryingIndexingTestIdealHomogeneousFieldTimeVarying)
      return MethodBasedFieldDefinition()
    end
    MPIMagneticFields.FieldTimeDependencyStyle(::TimeVaryingIndexingTestIdealHomogeneousFieldTimeVarying) = TimeVarying()
    MPIMagneticFields.FieldMovementStyle(::TimeVaryingIndexingTestIdealHomogeneousFieldTimeVarying) = NoMovement()

    function MPIMagneticFields.value_(field::TimeVaryingIndexingTestIdealHomogeneousFieldTimeVarying, t, r)
      return normalize(field.direction) .* field.amplitude .* sin.(2π * field.frequency * t)
    end

    field = TimeVaryingIndexingTestIdealHomogeneousFieldTimeVarying(1, 1, [1, 0, 0])

    @test all(field[1 / 4, 1, 0, 0] .≈ [1, 0, 0])
    @test all(field[1 / 4, 0.5, 0, 0] .≈ [1, 0, 0])

    @test Base.IndexStyle(TimeVaryingIndexingTestIdealHomogeneousFieldTimeVarying) isa IndexCartesian
  end

  @testset "Dispatch" begin
    for timeDependency ∈ [TimeConstant, TimeVarying]
      @testset "No movement ($timeDependency)" begin
        structName = Symbol(string(timeDependency) * "TestIndexingNoMovement")

        @eval begin
          struct $structName <: AbstractMagneticField end
          MPIMagneticFields.FieldTimeDependencyStyle(::$structName) = $timeDependency()
          MPIMagneticFields.FieldMovementStyle(::$structName) = NoMovement()
          MPIMagneticFields.value_(::$structName, args...) = args

          field = $structName()
          t = 0
          r = [0, 0, 0]
          if $timeDependency == TimeConstant
            @test field[r...] == tuple(r)
          elseif $timeDependency == TimeVarying
            @test field[t, r...] == tuple(t, r)
          end
        end
      end

      for rotationalDimensionalityStyle ∈ [
        RotationalDimensionalityStyle{OneDimensional},
        RotationalDimensionalityStyle{TwoDimensional},
        RotationalDimensionalityStyle{ThreeDimensional},
      ]
        @testset "Rotational movement ($timeDependency, $(rotationalDimensionalityStyle.parameters[1]))" begin
          structName = Symbol(string(rotationalDimensionalityStyle.parameters[1]) * string(timeDependency) * "TestIndexingRotationalMovement")

          @eval begin
            struct $structName <: AbstractMagneticField end
            MPIMagneticFields.FieldTimeDependencyStyle(::$structName) = $timeDependency()
            MPIMagneticFields.FieldMovementStyle(::$structName) = RotationalMovement()
            function MPIMagneticFields.RotationalDimensionalityStyle(
              ::RotationalMovement,
              field::$structName,
            )
              return $rotationalDimensionalityStyle()
            end
            MPIMagneticFields.value_(::$structName, args...) = args

            field = $structName()
            t = 0
            r = [1, 2, 3]
            ϕ = collect(4:(3 + length($rotationalDimensionalityStyle)))
            if $timeDependency == TimeConstant
              @test field[r..., ϕ...] == tuple(r, ϕ)
            elseif $timeDependency == TimeVarying
              @test field[t, r..., ϕ...] == tuple(t, r, ϕ)
            end
          end
        end
      end

      for translationalDimensionalityStyle ∈ [
        TranslationalDimensionalityStyle{OneDimensional},
        TranslationalDimensionalityStyle{TwoDimensional},
        TranslationalDimensionalityStyle{ThreeDimensional},
      ]
        @testset "Translational movement ($timeDependency, $(translationalDimensionalityStyle.parameters[1]))" begin
          structName = Symbol(string(translationalDimensionalityStyle.parameters[1]) * string(timeDependency) * "TestIndexingTranslationalMovement")

          @eval begin
            struct $structName <: AbstractMagneticField end
            MPIMagneticFields.FieldTimeDependencyStyle(::$structName) = $timeDependency()
            MPIMagneticFields.FieldMovementStyle(::$structName) = TranslationalMovement()
            function MPIMagneticFields.TranslationalDimensionalityStyle(
              ::TranslationalMovement,
              field::$structName,
            )
              return $translationalDimensionalityStyle()
            end
            MPIMagneticFields.value_(::$structName, args...) = args

            field = $structName()
            t = 0
            r = [1, 2, 3]
            δ = collect(4:(3 + length($translationalDimensionalityStyle)))
            if $timeDependency == TimeConstant
              @test field[r..., δ...] == tuple(r, δ)
            elseif $timeDependency == TimeVarying
              @test field[t, r..., δ...] == tuple(t, r, δ)
            end
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
            structName = Symbol(string(rotationalDimensionalityStyle.parameters[1]) * "Rotation" * string(translationalDimensionalityStyle.parameters[1]) * "Translation" * string(timeDependency) * "TestIndexingRotationalTranslationalMovement")

            @eval begin
              struct $structName <: AbstractMagneticField end
              function MPIMagneticFields.FieldTimeDependencyStyle(::$structName)
                return $timeDependency()
              end
              function MPIMagneticFields.FieldMovementStyle(::$structName)
                return RotationalTranslationalMovement()
              end
              function MPIMagneticFields.RotationalDimensionalityStyle(
                ::RotationalMovement,
                field::$structName,
              )
                return $rotationalDimensionalityStyle()
              end
              function MPIMagneticFields.RotationalDimensionalityStyle(
                ::RotationalTranslationalMovement,
                field::$structName,
              )
                return $rotationalDimensionalityStyle()
              end
              function MPIMagneticFields.TranslationalDimensionalityStyle(
                ::RotationalTranslationalMovement,
                field::$structName,
              )
                return $translationalDimensionalityStyle()
              end
              MPIMagneticFields.value_(::$structName, args...) = args

              field = $structName()
              t = 0
              r = [1, 2, 3]
              ϕ = collect(4:(3 + length($rotationalDimensionalityStyle)))
              δ = collect(
                (4 + length($rotationalDimensionalityStyle)):(3 + length($rotationalDimensionalityStyle) + length(
                  $translationalDimensionalityStyle,
                )),
              )
              if $timeDependency == TimeConstant
                @test field[r..., ϕ..., δ...] == tuple(r, ϕ, δ)
              elseif $timeDependency == TimeVarying
                @test field[t, r..., ϕ..., δ...] == tuple(t, r, ϕ, δ)
              end
            end
          end
        end
      end
    end
  end
end
