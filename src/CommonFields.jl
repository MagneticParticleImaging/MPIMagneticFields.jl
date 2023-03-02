
mutable struct IdealFFP{GT} <: AbstractMagneticField where {GT <: Number}
  gradient::GT
end

fieldType(::IdealFFP) = GradientField()
definitionType(::IdealFFP) = MethodBasedFieldDefinition()
timeDependencyType(::IdealFFP) = TimeConstant()
gradientFieldType(::IdealFFP) = FFPGradientField()

value(field::IdealFFP, r) = r.*field.gradient

mutable struct IdealXYFFL{GT} <: AbstractMagneticField where {GT <: Number}
  gradient::GT
  ϕ::Float64
end

fieldType(::IdealXYFFL) = GradientField()
definitionType(::IdealXYFFL) = MethodBasedFieldDefinition()
timeDependencyType(::IdealXYFFL) = TimeConstant()
gradientFieldType(::IdealXYFFL) = FFLGradientField()
fieldMovementType(::IdealXYFFL) = RotationalMovement()

value(field::IdealXYFFL, r) = [-sin(field.ϕ)^2 -sin(field.ϕ)*cos(field.ϕ) 0; -sin(field.ϕ)*cos(field.ϕ) -cos(field.ϕ)^2 0; 0 0 1]*r.*field.gradient
rotate!(field::IdealXYFFL, ϕ) = field.ϕ = ϕ

mutable struct IdealHomogeneousField{T, U} <: AbstractMagneticField where {T <: Number, U <: Number}
  amplitude::T
  direction::Vector{U}
end

fieldType(::IdealHomogeneousField) = HomogeneousField()
definitionType(::IdealHomogeneousField) = MethodBasedFieldDefinition()
timeDependencyType(::IdealHomogeneousField) = TimeConstant()
fieldMovementType(::IdealHomogeneousField) = NoMovement()

value(field::IdealHomogeneousField, r) = normalize(field.direction).*field.amplitude

# TODO: Define other combinations
mutable struct IdealXYRotatedHomogeneousField{T} <: AbstractMagneticField where {T <: Number}
  amplitude::T
  ϕ::Float64
end

fieldType(::IdealXYRotatedHomogeneousField) = HomogeneousField()
definitionType(::IdealXYRotatedHomogeneousField) = MethodBasedFieldDefinition()
timeDependencyType(::IdealXYRotatedHomogeneousField) = TimeConstant()
fieldMovementType(::IdealXYRotatedHomogeneousField) = RotationalMovement()

value(field::IdealXYRotatedHomogeneousField, r) = [sin(field.ϕ), cos(field.ϕ), 0].*field.amplitude
rotate!(field::IdealXYRotatedHomogeneousField, ϕ) = field.ϕ = ϕ

# # TODO: This should be externalized

# mutable struct KolibriGradientField{T, N, M} <: AbstractMagneticField{T, N, M}
#   gradient::typeof(1.0u"T/m")
#   equation::Function
#   grid::RegularGridDefinition  
# end

# function KolibriGradientField(gradient = 5.0u"T/m", equation = nothing)
#   if isnothing(equation)
#     equation = (x, t) -> [0, 0, x[2]] # TODO: Specialize for M
#   end

#   return KolibriGradientField{Unitful.BField, 3, 3}(gradient, equation, RegularGridDefinition())
# end

# fieldType(::Type{KolibriGradientField}) = GradientField()
# gradientFieldType(::Type{KolibriGradientField}) = FFLGradientField()
# definitionType(::Type{KolibriGradientField}) = EquationBasedFieldDefinition()
# timeDependencyType(::Type{KolibriGradientField}) = TimeVarying()

# gradient(field::KolibriGradientField) = field.gradient

# Base.size(field::KolibriGradientField) = shape(grid)