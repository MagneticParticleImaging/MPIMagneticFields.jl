export AbstractSuperimposedField
"""
    $(TYPEDEF)

Abstract supertype for superimposed fields.
"""
abstract type AbstractSuperimposedField <: AbstractMagneticField end

export SuperimposedField
"""
    $(TYPEDEF)

Container for superimposed fields.

The fields in `fieldA` and `fieldB` are interpreted as being linearily superimposed.
"""
struct SuperimposedField{T <: AbstractMagneticField, U <: AbstractMagneticField} <: AbstractSuperimposedField
  fieldA::T
  fieldB::U
end

function FieldStyle(field::SuperimposedField)
  if FieldStyle(field.fieldA) == FieldStyle(field.fieldB)
    return FieldStyle(field.fieldA)
  else
    return MixedField()
  end
end

function FieldDefinitionStyle(field::SuperimposedField)
  if FieldDefinitionStyle(field.fieldA) == FieldDefinitionStyle(field.fieldB)
    return FieldDefinitionStyle(field.fieldA)
  else
    return MixedFieldDefinition()
  end
end

function FieldTimeDependencyStyle(field::SuperimposedField)
  if isTimeVarying(field.fieldA) || isTimeVarying(field.fieldB)
    return TimeVarying()
  else
    return TimeConstant()
  end
end

function GradientFieldStyle(field::SuperimposedField)
  if GradientFieldStyle(field.fieldA) == GradientFieldStyle(field.fieldB)
    return GradientFieldStyle(field.fieldA)
  else
    return MixedGradientField()
  end
end

FieldMovementStyle(field::SuperimposedField) = FieldMovementStyle(FieldMovementStyle(field.fieldA), FieldMovementStyle(field.fieldB), field)

movementStylesCodeGeneration_ = (:NoMovement, :RotationalMovement, :TranslationalMovement, :RotationalTranslationalMovement)
movementStylesCodeGenerationPrecedence_ = Dict{Symbol, Int64}(
  :NoMovement => 0,
  :RotationalMovement => 1,
  :TranslationalMovement => 1,
  :RotationalTranslationalMovement => 2
)
for fieldAMovementStyle in movementStylesCodeGeneration_
  for fieldBMovementStyle in movementStylesCodeGeneration_
    if fieldAMovementStyle == fieldBMovementStyle
      @eval FieldMovementStyle(::$fieldAMovementStyle, ::$fieldBMovementStyle, ::SuperimposedField) = $fieldAMovementStyle()
    else
      if movementStylesCodeGenerationPrecedence_[fieldAMovementStyle] == movementStylesCodeGenerationPrecedence_[fieldBMovementStyle]
        @eval FieldMovementStyle(::$fieldAMovementStyle, ::$fieldBMovementStyle, ::SuperimposedField) = RotationalTranslationalMovement()
      elseif movementStylesCodeGenerationPrecedence_[fieldAMovementStyle] > movementStylesCodeGenerationPrecedence_[fieldBMovementStyle]
        @eval FieldMovementStyle(::$fieldAMovementStyle, ::$fieldBMovementStyle, ::SuperimposedField) = $fieldAMovementStyle()
      else
        @eval FieldMovementStyle(::$fieldAMovementStyle, ::$fieldBMovementStyle, ::SuperimposedField) = $fieldBMovementStyle()
      end
    end
  end
end

function RotationalDimensionalityStyle(field::SuperimposedField)
  if RotationalDimensionalityStyle(field.fieldA) == RotationalDimensionalityStyle(field.fieldB)
    return RotationalDimensionalityStyle(field.fieldA)
  else
    error("The dimensionality styles of the superimposed fields have to match. Consider using wrapper fields to align the dimensionality for your usecase.")
  end
end

function TranslationalDimensionalityStyle(field::SuperimposedField)
  if TranslationalDimensionalityStyle(field.fieldA) == TranslationalDimensionalityStyle(field.fieldB)
    return TranslationalDimensionalityStyle(field.fieldA)
  else
    error("The dimensionality styles of the superimposed fields have to match. Consider using wrapper fields to align the dimensionality for your usecase.")
  end
end

export superimpose
function superimpose(fieldA::AbstractMagneticField, fieldB::AbstractMagneticField)
  return SuperimposedField(fieldA, fieldB)
end

function value(field::SuperimposedField, args...; kwargs...)
  return value(
    FieldTimeDependencyStyle(field.fieldA),
    FieldTimeDependencyStyle(field.fieldB),
    FieldMovementStyle(field.fieldA),
    FieldMovementStyle(field.fieldB),
    RotationalDimensionalityStyle(field.fieldA),
    RotationalDimensionalityStyle(field.fieldB),
    TranslationalDimensionalityStyle(field.fieldA),
    TranslationalDimensionalityStyle(field.fieldB),
    field,
    args...;
    kwargs...
  )
end

dimensionalityStylesCodeGeneration_ = Dict(:ZeroDimensional => 0, :OneDimensional => 1, :TwoDimensional => 2, :ThreeDimensional => 3)
timeDependencyStylesCodeGeneration_ = [:TimeConstant, :TimeVarying]
for fieldATimeDependencyStyle in timeDependencyStylesCodeGeneration_
  for fieldBTimeDependencyStyle in timeDependencyStylesCodeGeneration_
    for fieldAMovementStyle in movementStylesCodeGeneration_
      for fieldBMovementStyle in movementStylesCodeGeneration_
        for (fieldARotationalDimensionalityStyle, fieldARotationalDimensionalityStyleLength) in dimensionalityStylesCodeGeneration_
          for (fieldBRotationalDimensionalityStyle, fieldBRotationalDimensionalityStyleLength) in dimensionalityStylesCodeGeneration_
            for (fieldATranslationalDimensionalityStyle, fieldATranslationalDimensionalityStyleLength) in dimensionalityStylesCodeGeneration_
              for (fieldBTranslationalDimensionalityStyle, fieldBTranslationalDimensionalityStyleLength) in dimensionalityStylesCodeGeneration_
                if fieldARotationalDimensionalityStyle != fieldBRotationalDimensionalityStyle || fieldATranslationalDimensionalityStyle != fieldBTranslationalDimensionalityStyle
                  funcBodyExpr = Expr(:call, :error, "The dimensionality styles of the superimposed fields have to match. Consider using wrapper fields to align the dimensionality for your usecase.")
                else
                  argumentsA = []
                  argumentsB = []
                  
                  if fieldATimeDependencyStyle == :TimeVarying
                    push!(argumentsA, :(args[1]))
                  end
                  if fieldBTimeDependencyStyle == :TimeVarying
                    push!(argumentsB, :(args[1]))
                  end

                  rotationalStyles_ = [:RotationalMovement, :RotationalTranslationalMovement]
                  translationalStyles_ = [:TranslationalMovement, :RotationalTranslationalMovement]
                  if fieldAMovementStyle in rotationalStyles_ || fieldBMovementStyle in rotationalStyles_
                    if fieldAMovementStyle in translationalStyles_ || fieldBMovementStyle in translationalStyles_
                      δ = :(args[end]) #:(args[(end - $fieldATranslationalDimensionalityStyleLength + 1):end])
                      ϕ = :(args[end-1]) #:(args[(end - $fieldATranslationalDimensionalityStyleLength - $fieldARotationalDimensionalityStyleLength + 1):(end - $fieldATranslationalDimensionalityStyleLength)])

                      if fieldATimeDependencyStyle == :TimeVarying || fieldBTimeDependencyStyle == :TimeVarying
                        r = :(args[end-2]) # :(args[2:(end - $fieldATranslationalDimensionalityStyleLength - $fieldARotationalDimensionalityStyleLength)])
                      else
                        r = :(args[end-2]) # :(args[1:(end - $fieldATranslationalDimensionalityStyleLength - $fieldARotationalDimensionalityStyleLength)])
                      end
                    else
                      ϕ = :(args[end]) #:(args[(end - $fieldARotationalDimensionalityStyleLength + 1):end])

                      if fieldATimeDependencyStyle == :TimeVarying || fieldBTimeDependencyStyle == :TimeVarying
                        r = :(args[end-1]) #:(args[2:(end - $fieldARotationalDimensionalityStyleLength)])
                      else
                        r = :(args[end-1]) #:(args[1:(end - $fieldARotationalDimensionalityStyleLength)])
                      end
                    end

                    push!(argumentsA, r)
                    push!(argumentsB, r)

                    if fieldAMovementStyle in rotationalStyles_
                      push!(argumentsA, ϕ)
                    end
                    if fieldBMovementStyle in rotationalStyles_
                      push!(argumentsB, ϕ)
                    end

                    if fieldAMovementStyle in translationalStyles_
                      push!(argumentsA, δ)
                    end
                    if fieldBMovementStyle in translationalStyles_
                      push!(argumentsB, δ)
                    end
                  elseif fieldAMovementStyle in translationalStyles_ || fieldBMovementStyle in translationalStyles_
                    δ = :(args[end]) #:(args[(end - $fieldATranslationalDimensionalityStyleLength + 1):end])

                    if fieldATimeDependencyStyle == :TimeVarying || fieldBTimeDependencyStyle == :TimeVarying
                      r = :(args[end-1]) #:(args[2:(end - $fieldATranslationalDimensionalityStyleLength)])
                    else
                      r = :(args[end-1]) #:(args[1:(end - $fieldATranslationalDimensionalityStyleLength)])
                    end

                    push!(argumentsA, r)
                    push!(argumentsB, r)

                    if fieldAMovementStyle in translationalStyles_
                      push!(argumentsA, δ)
                    end
                    if fieldBMovementStyle in translationalStyles_
                      push!(argumentsB, δ)
                    end
                  else
                    if fieldATimeDependencyStyle == :TimeVarying || fieldBTimeDependencyStyle == :TimeVarying
                      r = :(args[end]) #:(args[2:end])
                    else
                      r = :(args[end]) #:(args[1:end])
                    end

                    push!(argumentsA, r)
                    push!(argumentsB, r)
                  end

                  funcBodyA = Expr(:call, :value, :(field.fieldA), argumentsA...)
                  funcBodyB = Expr(:call, :value, :(field.fieldB), argumentsB...)
                  
                  funcBodyExpr = Expr(:return, Expr(:call, :.+, funcBodyA, funcBodyB))
                end
              
                @eval begin
                  function value(
                    ::$fieldATimeDependencyStyle,
                    ::$fieldBTimeDependencyStyle,
                    ::$fieldAMovementStyle,
                    ::$fieldBMovementStyle,
                    ::RotationalDimensionalityStyle{$fieldARotationalDimensionalityStyle},
                    ::RotationalDimensionalityStyle{$fieldBRotationalDimensionalityStyle},
                    ::TranslationalDimensionalityStyle{$fieldATranslationalDimensionalityStyle},
                    ::TranslationalDimensionalityStyle{$fieldBTranslationalDimensionalityStyle},
                    field::SuperimposedField,
                    args...;
                    kwargs...)
                    $funcBodyExpr
                  end
                end
              end
            end
          end
        end        
      end
    end
  end
end

function isRotatable(field::SuperimposedField)
  return isRotatable(field.fieldA) || isRotatable(field.fieldB)
end
function isTranslatable(field::SuperimposedField)
  return isTranslatable(field.fieldA) || isTranslatable(field.fieldB)
end
function isTimeVarying(field::SuperimposedField)
  return isTimeVarying(field.fieldA) || isTimeVarying(field.fieldB)
end

export AbstractNegativeField
"""
    $(TYPEDEF)

Abstract supertype for negative fields.
"""
abstract type AbstractNegativeField <: AbstractMagneticField end

export NegativeField
"""
    $(TYPEDEF)

Container for negative fields.

The field of this container is interpreted as being the negative of `field`.
"""
struct NegativeField{T <: AbstractMagneticField} <: AbstractNegativeField
  field::T
end

FieldStyle(field::NegativeField) = FieldStyle(field.field)
FieldDefinitionStyle(field::NegativeField) = FieldDefinitionStyle(field.field)
FieldTimeDependencyStyle(field::NegativeField) = FieldTimeDependencyStyle(field.field)
GradientFieldStyle(field::NegativeField) = GradientFieldStyle(field.field)

FieldMovementStyle(field::NegativeField) = FieldMovementStyle(field.field)
RotationalDimensionalityStyle(field::NegativeField) = RotationalDimensionalityStyle(field.field)
TranslationalDimensionalityStyle(field::NegativeField) = TranslationalDimensionalityStyle(field.field)

export negative
negative(field::AbstractMagneticField) = NegativeField(field)

value(field::NegativeField, args...) = .-value(field.field, args...)

isRotatable(field::NegativeField) = isRotatable(field.field)
isTranslatable(field::NegativeField) = isTranslatable(field.field)
isTimeVarying(field::NegativeField) = isTimeVarying(field.field)

import Base.+, Base.-

function (+)(fieldA::AbstractMagneticField, fieldB::AbstractMagneticField)
  return superimpose(fieldA, fieldB)
end
function (-)(fieldA::AbstractMagneticField, fieldB::AbstractMagneticField)
  return superimpose(fieldA, -fieldB)
end
(-)(field::AbstractMagneticField) = negative(field)
