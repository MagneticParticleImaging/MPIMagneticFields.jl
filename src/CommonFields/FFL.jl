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
  sincos_ = sincos(-ϕ) # Rotates clockwise
  mat = SMatrix{3, 3}(1/2-1/2*sincos_[2], -1/2*sincos_[1], 0, -1/2*sincos_[1], 1/2+1/2*sincos_[2], 0, 0, 0, 1) .* field.gradient
  return mat * r
end
