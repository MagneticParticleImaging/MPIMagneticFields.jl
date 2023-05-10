export IdealFFP
mutable struct IdealFFP{GT} <: AbstractMagneticField where {GT <: Number}
  gradient::Vector{GT}
end

fieldType(::IdealFFP) = GradientField()
definitionType(::IdealFFP) = MethodBasedFieldDefinition()
timeDependencyType(::IdealFFP) = TimeConstant()
gradientFieldType(::IdealFFP) = FFPGradientField()

value(field::IdealFFP, r::PT) where {T <: Number, PT <: AbstractVector{T}} = r.*field.gradient