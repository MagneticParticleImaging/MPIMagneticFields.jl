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
for fieldAMovementStyle = movementStylesCodeGeneration_
  for fieldBMovementStyle = movementStylesCodeGeneration_
    if fieldAMovementStyle == fieldBMovementStyle
      @eval FieldMovementStyle(::$fieldAMovementStyle, ::fieldBMovementStyle, ::SuperimposedField) = $fieldAMovementStyle()
    else
      Cont here
      @eval FieldMovementStyle(::$fieldAMovementStyle, ::fieldBMovementStyle, ::SuperimposedField) = $fieldAMovementStyle()
    end
end

FieldMovementStyle(::NoMovement, ::NoMovement, field::SuperimposedField) = NoMovement()
FieldMovementStyle(::NoMovement, ::TranslationalMovement, field::SuperimposedField) = TranslationalMovement()
FieldMovementStyle(::NoMovement, ::RotationalMovement, field::SuperimposedField) = RotationalMovement()
FieldMovementStyle(::NoMovement, ::RotationalTranslationalMovement, field::SuperimposedField) = RotationalTranslationalMovement()

FieldMovementStyle(::RotationalMovement, ::NoMovement, field::SuperimposedField) = RotationalMovement()
FieldMovementStyle(::RotationalMovement, ::TranslationalMovement, field::SuperimposedField) = RotationalTranslationalMovement()
FieldMovementStyle(::RotationalMovement, ::RotationalMovement, field::SuperimposedField) = RotationalMovement()
FieldMovementStyle(::RotationalMovement, ::RotationalTranslationalMovement, field::SuperimposedField) = RotationalTranslationalMovement()

FieldMovementStyle(::TranslationalMovement, ::NoMovement, field::SuperimposedField) = TranslationalMovement()
FieldMovementStyle(::TranslationalMovement, ::TranslationalMovement, field::SuperimposedField) = TranslationalMovement()
FieldMovementStyle(::TranslationalMovement, ::RotationalMovement, field::SuperimposedField) = RotationalTranslationalMovement()
FieldMovementStyle(::TranslationalMovement, ::RotationalTranslationalMovement, field::SuperimposedField) = RotationalTranslationalMovement()

FieldMovementStyle(::RotationalTranslationalMovement, ::NoMovement, field::SuperimposedField) = RotationalTranslationalMovement()
FieldMovementStyle(::RotationalTranslationalMovement, ::TranslationalMovement, field::SuperimposedField) = RotationalTranslationalMovement()
FieldMovementStyle(::RotationalTranslationalMovement, ::RotationalMovement, field::SuperimposedField) = RotationalTranslationalMovement()
FieldMovementStyle(::RotationalTranslationalMovement, ::RotationalTranslationalMovement, field::SuperimposedField) = RotationalTranslationalMovement()

RotationalDimensionalityStyle(field::SuperimposedField) = RotationalDimensionalityStyle(field.field)
TranslationalDimensionalityStyle(field::SuperimposedField) = TranslationalDimensionalityStyle(field.field)

export superimpose
function superimpose(fieldA::AbstractMagneticField, fieldB::AbstractMagneticField)
  return SuperimposedField(fieldA, fieldB)
end

value(field::SuperimposedField, args...) = value(FieldTimeDependencyStyle(field), field, args...)
function value(::TimeConstant, field::SuperimposedField, args::Vararg{T, 2}) where {T <: Union{Number, <:AbstractArray}}
  if numMovementParameters(field.fieldA) > 0
    valueA = value(field.fieldA, args[1], args[2])
  else
    valueA = value(field.fieldA, args[1])
  end

  if numMovementParameters(field.fieldB) > 0
    valueB = value(field.fieldB, args[1], args[2])
  else
    valueB = value(field.fieldB, args[1])
  end

  return valueA .+ valueB
end


  return  .+ value(field.fieldB, args...)
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
