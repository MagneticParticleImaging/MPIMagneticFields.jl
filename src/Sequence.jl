export AbstractSequencedField
"""
    $(TYPEDEF)

Abstract supertype for sequenced fields.
"""
abstract type AbstractSequencedField <: AbstractMagneticField end

export SequencedField
"""
    $(TYPEDEF)

Container for sequenced fields.

Attaches a function to a field defining the movement over time. 
"""
struct SequencedField{T <: AbstractMagneticField} <: AbstractSequencedField
  field::T
  rotation::Function
  translation::Function
end

function SequencedField(field::T; rotation=t->0, translation=t->0) where {T <: AbstractMagneticField}
  return SequencedField(field, rotation, translation)
end

FieldStyle(field::SequencedField)::FieldStyle = FieldStyle(field.field)
FieldDefinitionStyle(field::SequencedField)::FieldDefinitionStyle = FieldDefinitionStyle(field.field)
FieldTimeDependencyStyle(::SequencedField)::FieldTimeDependencyStyle = TimeVarying()
GradientFieldStyle(field::SequencedField)::GradientFieldStyle = GradientFieldStyle(field.field)
FieldMovementStyle(::SequencedField)::FieldMovementStyle = SequencedMovement()

isRotatable(field::SequencedField) = false # isRotatable(field.field)
isTranslatable(field::SequencedField) = false # isTranslatable(field.field)

RotationalDimensionalityStyle(field::SequencedField) = RotationalDimensionalityStyle{ZeroDimensional}() # RotationalDimensionalityStyle(field.field)
TranslationalDimensionalityStyle(field::SequencedField) = TranslationalDimensionalityStyle{ZeroDimensional}() # TranslationalDimensionalityStyle(field.field)

function value_(field::SequencedField, t, r)
  if isTimeVarying(field.field)
    if isRotatable(field.field) && isTranslatable(field.field)
      value(field.field, t, r, field.rotation(t), field-translation(t))
    elseif isRotatable(field.field)
      value(field.field, t, r, field.rotation(t))
    elseif isTranslatable(field.field)
      value(field.field, t, r, field-translation(t))
    else
      value(field.field, t, r)
    end
  else
    if isRotatable(field.field) && isTranslatable(field.field)
      value(field.field, r, field.rotation(t), field-translation(t))
    elseif isRotatable(field.field)
      value(field.field, r, field.rotation(t))
    elseif isTranslatable(field.field)
      value(field.field, r, field-translation(t))
    else
      value(field.field, r)
    end
  end
end