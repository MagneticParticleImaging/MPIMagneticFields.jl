export IdealXYRotatedFFL
mutable struct IdealXYRotatedFFL{GT} <: AbstractMagneticField where {GT <: Number}
  gradient::GT
end

FieldStyle(::IdealXYRotatedFFL) = GradientField()
FieldDefinitionStyle(::IdealXYRotatedFFL) = MethodBasedFieldDefinition()
FieldTimeDependencyStyle(::IdealXYRotatedFFL) = TimeConstant()
GradientFieldStyle(::IdealXYRotatedFFL) = FFLGradientField()
FieldMovementStyle(::IdealXYRotatedFFL) = RotationalMovement()
RotationalDimensionalityStyle(::IdealXYRotatedFFL) = RotationalDimensionalityStyle{OneDimensional}()

function value_(field::IdealXYRotatedFFL, r, ϕ)
  sincos_ = sincos(-2ϕ) # Rotates clockwise
  mat = SMatrix{3, 3}(1/2-1/2*sincos_[2], -1/2*sincos_[1], 0, -1/2*sincos_[1], 1/2+1/2*sincos_[2], 0, 0, 0, 1) .* field.gradient
  return mat * r
end

export IdealXYRotatedTranslatedFFL
mutable struct IdealXYRotatedTranslatedFFL{GT} <: AbstractMagneticField where {GT <: Number}
  gradient::GT
end

FieldStyle(::IdealXYRotatedTranslatedFFL) = GradientField()
FieldDefinitionStyle(::IdealXYRotatedTranslatedFFL) = MethodBasedFieldDefinition()
FieldTimeDependencyStyle(::IdealXYRotatedTranslatedFFL) = TimeConstant()
GradientFieldStyle(::IdealXYRotatedTranslatedFFL) = FFLGradientField()
FieldMovementStyle(::IdealXYRotatedTranslatedFFL) = RotationalTranslationalMovement()
RotationalDimensionalityStyle(::IdealXYRotatedTranslatedFFL) = RotationalDimensionalityStyle{OneDimensional}()
TranslationalDimensionalityStyle(::IdealXYRotatedTranslatedFFL) = TranslationalDimensionalityStyle{OneDimensional}()

function value_(field::IdealXYRotatedTranslatedFFL, r, ϕ, δ)
  sincos_ = sincos(-2ϕ) # Rotates clockwise
  mat = SMatrix{3, 3}(1/2-1/2*sincos_[2], -1/2*sincos_[1], 0, -1/2*sincos_[1], 1/2+1/2*sincos_[2], 0, 0, 0, 1) .* field.gradient
  sincos_ = sincos(ϕ)
  shift = SVector{3}(sincos_[1], sincos_[2], 0) .* δ
  return mat * r .+ shift
end
