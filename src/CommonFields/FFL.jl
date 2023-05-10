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