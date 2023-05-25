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
struct SuperimposedField <: AbstractSuperimposedField
  fieldA::AbstractMagneticField
  fieldB::AbstractMagneticField
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

export superimpose
function superimpose(fieldA::AbstractMagneticField, fieldB::AbstractMagneticField)
  return SuperimposedField(fieldA, fieldB)
end

function value(field::SuperimposedField, args...)
  return value(field.fieldA, args...) .+ value(field.fieldB, args...)
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
struct NegativeField <: AbstractNegativeField
  field::AbstractMagneticField
end

FieldStyle(field::NegativeField) = FieldStyle(field.field)
FieldDefinitionStyle(field::NegativeField) = FieldDefinitionStyle(field.field)
FieldTimeDependencyStyle(field::NegativeField) = FieldTimeDependencyStyle(field.field)
GradientFieldStyle(field::NegativeField) = GradientFieldStyle(field.field)

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
