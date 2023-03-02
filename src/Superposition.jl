"""
    $(TYPEDEF)

Container for superimposed fields.

The fields in `fieldA` and `fieldB` are interpreted as being linearily superimposed.
"""
struct SuperimposedField <: AbstractMagneticField
  fieldA::AbstractMagneticField
  fieldB::AbstractMagneticField
end

fieldType(field::Type{SuperimposedField}) = fieldType(field.fieldA) == fieldType(field.fieldB) ? fieldType(field.fieldA) : MixedField()
definitionType(field::Type{SuperimposedField}) = definitionType(field.fieldA) == definitionType(field.fieldB) ? definitionType(field.fieldA) : MixedFieldDefinition()
timeDependencyType(field::Type{SuperimposedField}) = isTimeVarying(field.fieldA) && isTimeVarying(field.fieldB) ? TimeConstant() : TimeVarying()

superimpose(fieldA::AbstractMagneticField, fieldB::AbstractMagneticField) = SuperimposedField(fieldA, fieldB)

value(field::SuperimposedField, r) = value(field.fieldA, r) + value(field.fieldB, r)

isRotatable(field::SuperimposedField) = isRotatable(field.fieldA) && isRotatable(field.fieldB)
isTranslatable(field::SuperimposedField) = isTranslatable(field.fieldA) && isTranslatable(field.fieldB)

function rotate!(field::SuperimposedField, ϕ)
  if isRotatable(field)
    rotate!(field.fieldA, ϕ)
    rotate!(field.fieldB, ϕ)
  else
    error("The superimposed field is not rotatable.")
  end
end

function translate!(field::SuperimposedField, r)
  if isTranslatable(field)
    translate!(field.fieldA, r)
    translate!(field.fieldB, r)
  else
    error("The superimposed field is not translatable.")
  end
end

"""
    $(TYPEDEF)

Container for negative fields.

The field of this container is interpreted as being the negative of `field`.
"""
struct NegativeField <: AbstractMagneticField
  field::AbstractMagneticField
end

fieldType(::Type{NegativeField}) = fieldType(field.field)
definitionType(::Type{NegativeField}) = definitionType(field.field)
timeDependencyType(::Type{NegativeField}) = timeDependencyType(field.field)
gradientFieldType(::Type{NegativeField}) = gradientFieldType(field.field)

negative(field::AbstractMagneticField) = NegativeField(field)

value(field::NegativeField, r) = .-value(field.field, r)

isRotatable(field::NegativeField) = isRotatable(field.field)
isTranslatable(field::NegativeField) = isTranslatable(field.field)

rotate!(field::NegativeField, ϕ) = rotate!(field.field, ϕ)
translate!(field::NegativeField, r) = translate!(field.field, r)

import Base.+, Base.-

(+)(fieldA::AbstractMagneticField, fieldB::AbstractMagneticField) = superimpose(fieldA, fieldB)
(-)(fieldA::AbstractMagneticField, fieldB::AbstractMagneticField) = superimpose(fieldA, -fieldB)
(-)(field::AbstractMagneticField) where {T <: AbstractMagneticField} = negative(field)