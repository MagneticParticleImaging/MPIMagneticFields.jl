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

fieldType(field::SuperimposedField) = fieldType(field.fieldA) == fieldType(field.fieldB) ? fieldType(field.fieldA) : MixedField()
definitionType(field::SuperimposedField) = definitionType(field.fieldA) == definitionType(field.fieldB) ? definitionType(field.fieldA) : MixedFieldDefinition()
timeDependencyType(field::SuperimposedField) = isTimeVarying(field.fieldA) || isTimeVarying(field.fieldB) ? TimeVarying() : TimeConstant()

export superimpose
superimpose(fieldA::AbstractMagneticField, fieldB::AbstractMagneticField) = SuperimposedField(fieldA, fieldB)

value(field::SuperimposedField, r::PT) where {T <: Number, PT <: AbstractVector{T}} = value(field.fieldA, r) .+ value(field.fieldB, r)
value(field::SuperimposedField, r::PT, ϕ::RT) where {T <: Number, PT <: AbstractVector{T}, RT <: Number} = value(field.fieldA, r, ϕ) + value(field.fieldB, r, ϕ)
value(field::SuperimposedField, r::PT, δ::TT) where {T <: Number, PT <: AbstractVector{T}, T2 <: Number, TT <: AbstractVector{T2}} = value(field.fieldA, r, δ) + value(field.fieldB, r, δ)
value(field::SuperimposedField, r::PT, ϕ::RT, δ::TT) where {T <: Number, PT <: AbstractVector{T}, RT <: Number, T2 <: Number, TT <: AbstractVector{T2}} = value(field.fieldA, r, ϕ, δ) + value(field.fieldB, r, ϕ, δ)

isRotatable(field::SuperimposedField) = isRotatable(field.fieldA) || isRotatable(field.fieldB)
isTranslatable(field::SuperimposedField) = isTranslatable(field.fieldA) || isTranslatable(field.fieldB)

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

fieldType(field::NegativeField) = fieldType(field.field)
definitionType(field::NegativeField) = definitionType(field.field)
timeDependencyType(field::NegativeField) = timeDependencyType(field.field)
gradientFieldType(field::NegativeField) = gradientFieldType(field.field)

export negative
negative(field::AbstractMagneticField) = NegativeField(field)

value(field::NegativeField, r::PT) where {T <: Number, PT <: AbstractVector{T}} = .-value(field.field, r)
value(field::NegativeField, r::PT, ϕ::RT) where {T <: Number, PT <: AbstractVector{T}, RT <: Number} = .-value(field.field, r, ϕ)
value(field::NegativeField, r::PT, δ::TT) where {T <: Number, PT <: AbstractVector{T}, T2 <: Number, TT <: AbstractVector{T2}} = .-value(field.field, r, δ)
value(field::NegativeField, r::PT, ϕ::RT, δ::TT) where {T <: Number, PT <: AbstractVector{T}, RT <: Number, T2 <: Number, TT <: AbstractVector{T2}} = .-value(field.field, r, ϕ, δ)

isRotatable(field::NegativeField) = isRotatable(field.field)
isTranslatable(field::NegativeField) = isTranslatable(field.field)

import Base.+, Base.-

(+)(fieldA::AbstractMagneticField, fieldB::AbstractMagneticField) = superimpose(fieldA, fieldB)
(-)(fieldA::AbstractMagneticField, fieldB::AbstractMagneticField) = superimpose(fieldA, -fieldB)
(-)(field::AbstractMagneticField) = negative(field)