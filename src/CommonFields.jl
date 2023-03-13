
# ideal gradient field with FFP
export IdealFFP
mutable struct IdealFFP{GT} <: AbstractMagneticField where {GT <: Number}
  gradient::Vector{GT}
end

fieldType(::IdealFFP) = GradientField()
definitionType(::IdealFFP) = MethodBasedFieldDefinition()
timeDependencyType(::IdealFFP) = TimeConstant()
gradientFieldType(::IdealFFP) = FFPGradientField()

value(field::IdealFFP, r::PT) where {T <: Number, PT <: AbstractVector{T}} = r.*field.gradient

export IdealXYFFL
mutable struct IdealXYFFL{GT} <: AbstractMagneticField where {GT <: Number}
  gradient::GT
end

fieldType(::IdealXYFFL) = GradientField()
definitionType(::IdealXYFFL) = MethodBasedFieldDefinition()
timeDependencyType(::IdealXYFFL) = TimeConstant()
gradientFieldType(::IdealXYFFL) = FFLGradientField()
fieldMovementType(::IdealXYFFL) = RotationalMovement()

value(field::IdealXYFFL, r::PT) where {T <: Number, PT <: AbstractVector{T}} = value(field, r, 0.0) # Defaults to angle 0
value(field::IdealXYFFL, r::PT, ϕ::RT) where {T <: Number, PT <: AbstractVector{T}, RT <: Number} = [-sin(ϕ)^2 -sin(ϕ)*cos(ϕ) 0; -sin(ϕ)*cos(ϕ) -cos(ϕ)^2 0; 0 0 1]*r.*field.gradient

export IdealHomogeneousField
mutable struct IdealHomogeneousField{T, U} <: AbstractMagneticField where {T <: Number, U <: Number}
  amplitude::T
  direction::Vector{U}
end

fieldType(::IdealHomogeneousField) = HomogeneousField()
definitionType(::IdealHomogeneousField) = MethodBasedFieldDefinition()
timeDependencyType(::IdealHomogeneousField) = TimeConstant()

value(field::IdealHomogeneousField, ::PT) where {T <: Number, PT <: AbstractVector{T}} = normalize(field.direction).*field.amplitude

# TODO: Define other combinations
export IdealXYRotatedHomogeneousField
mutable struct IdealXYRotatedHomogeneousField{T} <: AbstractMagneticField where {T <: Number}
  amplitude::T
end

fieldType(::IdealXYRotatedHomogeneousField) = HomogeneousField()
definitionType(::IdealXYRotatedHomogeneousField) = MethodBasedFieldDefinition()
timeDependencyType(::IdealXYRotatedHomogeneousField) = TimeConstant()
fieldMovementType(::IdealXYRotatedHomogeneousField) = RotationalMovement()

value(field::IdealXYRotatedHomogeneousField, r::PT) where {T <: Number, PT <: AbstractVector{T}} = value(field, r, 0.0) # Defaults to angle 0
value(field::IdealXYRotatedHomogeneousField, r::PT, ϕ::RT) where {T <: Number, PT <: AbstractVector{T}, RT <: Number} = [sin(ϕ), cos(ϕ), 0].*field.amplitude
