export IdealFFP
mutable struct IdealFFP{GT} <: AbstractMagneticField where {GT <: Number}
  gradient::Vector{GT}
end

FieldStyle(::IdealFFP) = GradientField()
FieldDefinitionStyle(::IdealFFP) = MethodBasedFieldDefinition()
FieldTimeDependencyStyle(::IdealFFP) = TimeConstant()
GradientFieldStyle(::IdealFFP) = FFPGradientField()

value_(field::IdealFFP, r) = r .* field.gradient
