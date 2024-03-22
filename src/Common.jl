#Base.size(S::SquaresVector) = (S.count,)
Base.IndexStyle(::Type{<:AbstractMagneticField}) = IndexCartesian()
function Base.getindex(field::AbstractMagneticField, args...)
  return getindex_(
    FieldTimeDependencyStyle(field),
    FieldMovementStyle(field),
    RotationalDimensionalityStyle(field),
    TranslationalDimensionalityStyle(field),
    field,
    args...,
  )
end

timeDependencyStylesCodeGeneration_ = [:TimeConstant, :TimeVarying]
movementStylesCodeGeneration_ =
  (:NoMovement, :SequencedMovement, :RotationalMovement, :TranslationalMovement, :RotationalTranslationalMovement)
dimensionalityStylesCodeGeneration_ =
  Dict(:ZeroDimensional => 0, :OneDimensional => 1, :TwoDimensional => 2, :ThreeDimensional => 3)

for fieldTimeDependencyStyle ∈ timeDependencyStylesCodeGeneration_
  for fieldMovementStyle ∈ movementStylesCodeGeneration_
    for (fieldRotationalDimensionalityStyle, fieldRotationalDimensionalityStyleLength) ∈
        dimensionalityStylesCodeGeneration_
      for (fieldTranslationalDimensionalityStyle, fieldTranslationalDimensionalityStyleLength) ∈
          dimensionalityStylesCodeGeneration_
        if fieldMovementStyle == :NoMovement &&
           (fieldRotationalDimensionalityStyleLength > 0 || fieldTranslationalDimensionalityStyleLength > 0)
          funcBodyExpr = Expr(
            :call,
            :error,
            "If there is no movement, the rotational and translational dimensionality must be zero.",
          )
        else
          arguments = []
          if fieldTimeDependencyStyle == :TimeVarying
            push!(arguments, :(args[1]))
          end

          rotationalStyles_ = [:RotationalMovement, :RotationalTranslationalMovement]
          translationalStyles_ = [:TranslationalMovement, :RotationalTranslationalMovement]
          if fieldMovementStyle in rotationalStyles_
            if fieldMovementStyle in translationalStyles_
              δ = :(args[(end - $fieldTranslationalDimensionalityStyleLength + 1):end])
              ϕ =
                :(args[(end - $fieldTranslationalDimensionalityStyleLength - $fieldRotationalDimensionalityStyleLength + 1):(end - $fieldTranslationalDimensionalityStyleLength)])

              if fieldTimeDependencyStyle == :TimeVarying
                r =
                  :(args[2:(end - $fieldTranslationalDimensionalityStyleLength - $fieldRotationalDimensionalityStyleLength)])
              else
                r =
                  :(args[1:(end - $fieldTranslationalDimensionalityStyleLength - $fieldRotationalDimensionalityStyleLength)])
              end

              push!(arguments, Expr(:call, :collect, r))
              push!(arguments, Expr(:call, :collect, ϕ))
              push!(arguments, Expr(:call, :collect, δ))
            else
              ϕ = :(args[(end - $fieldRotationalDimensionalityStyleLength + 1):end])

              if fieldTimeDependencyStyle == :TimeVarying
                r = :(args[2:(end - $fieldRotationalDimensionalityStyleLength)])
              else
                r = :(args[1:(end - $fieldRotationalDimensionalityStyleLength)])
              end

              push!(arguments, Expr(:call, :collect, r))
              push!(arguments, Expr(:call, :collect, ϕ))
            end
          elseif fieldMovementStyle in translationalStyles_
            δ = :(args[(end - $fieldTranslationalDimensionalityStyleLength + 1):end])

            if fieldTimeDependencyStyle == :TimeVarying
              r = :(args[2:(end - $fieldTranslationalDimensionalityStyleLength)])
            else
              r = :(args[1:(end - $fieldTranslationalDimensionalityStyleLength)])
            end

            push!(arguments, Expr(:call, :collect, r))
            push!(arguments, Expr(:call, :collect, δ))
          else
            if fieldTimeDependencyStyle == :TimeVarying
              r = :(args[2:end])
            else
              r = :(args[1:end])
            end

            push!(arguments, Expr(:call, :collect, r))
          end

          funcBody = Expr(:call, :value, :field, arguments...)
          funcBodyExpr = Expr(:return, funcBody)
        end

        @eval begin
          function getindex_(
            ::$fieldTimeDependencyStyle,
            ::$fieldMovementStyle,
            ::RotationalDimensionalityStyle{$fieldRotationalDimensionalityStyle},
            ::TranslationalDimensionalityStyle{$fieldTranslationalDimensionalityStyle},
            field::AbstractMagneticField,
            args...,
          )
            $funcBodyExpr
          end
        end
      end
    end
  end
end
