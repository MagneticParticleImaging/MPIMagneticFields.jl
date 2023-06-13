export IdealXYFFL
mutable struct IdealXYFFL{GT} <: AbstractMagneticField where {GT <: Number}
  gradient::GT
end

FieldStyle(::IdealXYFFL) = GradientField()
FieldDefinitionStyle(::IdealXYFFL) = MethodBasedFieldDefinition()
FieldTimeDependencyStyle(::IdealXYFFL) = TimeConstant()
GradientFieldStyle(::IdealXYFFL) = FFLGradientField()
FieldMovementStyle(::IdealXYFFL) = RotationalMovement()

function value_(field::IdealXYFFL, r, ϕ)
  return [-sin(ϕ)^2 -sin(ϕ)*cos(ϕ) 0; -sin(ϕ)*cos(ϕ) -cos(ϕ)^2 0; 0 0 1] * r .* field.gradient
end
