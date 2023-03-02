"""
    $(TYPEDEF)

Container for superimposed fields.

The fields in `fieldA` and `fieldB` are interpreted as being linearily superimposed.
"""
struct SuperimposedField{T, N, M} <: AbstractMagneticField{T, N, M}
  fieldA::AbstractMagneticField{T, N, M}
  fieldB::AbstractMagneticField{T, N, M}
end

fieldType(field::Type{SuperimposedField}) = fieldType(field.fieldA) == fieldType(field.fieldB) ? fieldType(field.fieldA) : MixedField()
definitionType(field::Type{SuperimposedField}) = definitionType(field.fieldA) == definitionType(field.fieldB) ? definitionType(field.fieldA) : MixedFieldDefinition()
timeDependencyType(field::Type{SuperimposedField}) = isTimeVarying(field.fieldA) && isTimeVarying(field.fieldB) ? TimeConstant() : TimeVarying()

superimpose(fieldA::AbstractMagneticField, fieldB::AbstractMagneticField) = SuperimposedField(fieldA, fieldB)

"""
    $(TYPEDEF)

Container for negative fields.

The field of this container is interpreted as being the negative of `field`.
"""
struct NegativeField{T, N, M} <: AbstractMagneticField{T, N, M}
  field::AbstractMagneticField{T, N, M}
end

fieldType(::Type{NegativeField}) = fieldType(field.field)
definitionType(::Type{NegativeField}) = definitionType(field.field)
timeDependencyType(::Type{NegativeField}) = timeDependencyType(field.field)
gradientFieldType(::Type{NegativeField}) = gradientFieldType(field.field)

negative(field::AbstractMagneticField) = NegativeField(field)

import Base.+, Base.-

(+)(fieldA::AbstractMagneticField, fieldB::AbstractMagneticField) = superimpose(fieldA, fieldB)
(-)(fieldA::AbstractMagneticField, fieldB::AbstractMagneticField) = superimpose(fieldA, -fieldB)
(-)(field::AbstractMagneticField) where {T <: AbstractMagneticField} = negative(field)