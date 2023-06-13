export FieldStyle
"""
    $(TYPEDEF)

Trait describing the kind of field described by the type it is attached to.
"""
abstract type FieldStyle end

export GradientField
"""
    $(TYPEDEF)

[`FieldStyle`](@ref) trait describing gradient fields.
"""
struct GradientField <: FieldStyle end

export HomogeneousField
"""
    $(TYPEDEF)

[`FieldStyle`](@ref) trait describing homogeneous fields.
"""
struct HomogeneousField <: FieldStyle end

export ExcitationField
"""
    $(TYPEDEF)

[`FieldStyle`](@ref) trait describing excitation fields.
"""
struct ExcitationField <: FieldStyle end

export MixedField
"""
    $(TYPEDEF)

[`FieldStyle`](@ref) trait describing fields of a mixed kind. Used e.g. for [`SuperimposedField`](@ref).
"""
struct MixedField <: FieldStyle end

export OtherField
"""
    $(TYPEDEF)

[`FieldStyle`](@ref) trait describing fields that cannot be categorized as one of the other types.
"""
struct OtherField <: FieldStyle end

export FieldStyle
"""
    $(SIGNATURES)

Defines the [`FieldStyle`](@ref) of a field.

For user-defined fields this method should be overriden by a more specific version.
The default is [`OtherField`](@ref).
"""
FieldStyle(::AbstractMagneticField)::FieldStyle = OtherField()

export FieldDefinitionStyle
"""
    $(TYPEDEF)

Trait describing the definition style of field described by the type it is attached to.

The definition style is mainly divided into [`EquationBasedFieldDefinition`](@ref) and [`DataBasedFieldDefinition`](@ref).
"""
abstract type FieldDefinitionStyle end

export EquationBasedFieldDefinition
"""
    $(TYPEDEF)

[`FieldDefinitionStyle`](@ref) trait describing fields that are defined using equations.
"""
abstract type EquationBasedFieldDefinition <: FieldDefinitionStyle end

export DataBasedFieldDefinition
"""
    $(TYPEDEF)

[`FieldDefinitionStyle`](@ref) trait describing fields that are defined using measured or simulated data.
"""
abstract type DataBasedFieldDefinition <: FieldDefinitionStyle end

export MethodBasedFieldDefinition
"""
    $(TYPEDEF)

[`EquationBasedFieldDefinition`](@ref) trait describing fields that are defined using equations in methods.
"""
struct MethodBasedFieldDefinition <: EquationBasedFieldDefinition end

export SymbolicBasedFieldDefinition
"""
    $(TYPEDEF)

[`EquationBasedFieldDefinition`](@ref) trait describing fields that are defined using equations represented by symbolics.
"""
struct SymbolicBasedFieldDefinition <: EquationBasedFieldDefinition end

export CartesianDataBasedFieldDefinition
"""
    $(TYPEDEF)

[`DataBasedFieldDefinition`](@ref) trait describing fields that are defined using data on a cartesian grid.
"""
struct CartesianDataBasedFieldDefinition <: DataBasedFieldDefinition end

export SphericalHarmonicsDataBasedFieldDefinition
"""
    $(TYPEDEF)

[`DataBasedFieldDefinition`](@ref) trait describing fields that are defined using data extrapolated with spherical harmonics.
"""
struct SphericalHarmonicsDataBasedFieldDefinition <: DataBasedFieldDefinition end

export MixedFieldDefinition
"""
    $(TYPEDEF)

[`FieldDefinitionStyle`](@ref) trait describing fields that are defined by a mix of the possible types.
"""
struct MixedFieldDefinition <: FieldDefinitionStyle end

export OtherFieldDefinition
"""
    $(TYPEDEF)

[`FieldDefinitionStyle`](@ref) trait describing fields that are defined by a method not covered by one of the other kinds.
"""
struct OtherFieldDefinition <: FieldDefinitionStyle end

export FieldDefinitionStyle
"""
    $(SIGNATURES)

Defines the [`FieldDefinitionStyle`](@ref) of a field.

For user-defined fields this method should be overriden by a more specific version.
The default is [`MethodBasedFieldDefinition`](@ref).
"""
FieldDefinitionStyle(::AbstractMagneticField)::FieldDefinitionStyle =
  MethodBasedFieldDefinition()

export FieldTimeDependencyStyle
"""
    $(TYPEDEF)

Trait describing the time dependency style of a field described by the type it is attached to.

The definition style is mainly divided into [`TimeVarying`](@ref) and [`TimeConstant`](@ref).
"""
abstract type FieldTimeDependencyStyle end

export TimeVarying
"""
    $(TYPEDEF)

[`FieldTimeDependencyStyle`](@ref) trait describing fields that are varying over time.
"""
struct TimeVarying <: FieldTimeDependencyStyle end

export TimeConstant
"""
    $(TYPEDEF)

[`FieldTimeDependencyStyle`](@ref) trait describing fields that are constant over time.
"""
struct TimeConstant <: FieldTimeDependencyStyle end

# Base.length(::Type{TimeVarying}) = 1
# Base.length(::Type{TimeConstant}) = 0


export FieldTimeDependencyStyle
"""
    $(SIGNATURES)

Defines the [`FieldTimeDependencyStyle`](@ref) of a field.

For user-defined fields this method should be overriden by a more specific version.
The default is [`TimeConstant`](@ref).
"""
FieldTimeDependencyStyle(::AbstractMagneticField)::FieldTimeDependencyStyle = TimeConstant()

export isTimeVarying
"""
    $(SIGNATURES)

Determine whether a field varies over time or not.
"""
isTimeVarying(field::AbstractMagneticField) = isTimeVarying(FieldTimeDependencyStyle(field))
isTimeVarying(::TimeVarying) = true
isTimeVarying(::TimeConstant) = false

export GradientFieldStyle
"""
    $(TYPEDEF)

Trait describing the gradient style of a [`GradientField`](@ref) described by the type it is attached to.
"""
abstract type GradientFieldStyle end

export FFPGradientField
"""
    $(TYPEDEF)

[`GradientFieldStyle`](@ref) trait describing fields that are forming a field free point.
"""
struct FFPGradientField <: GradientFieldStyle end

export FFLGradientField
"""
    $(TYPEDEF)

[`GradientFieldStyle`](@ref) trait describing fields that are forming a field free line.
"""
struct FFLGradientField <: GradientFieldStyle end

export MixedGradientField
"""
    $(TYPEDEF)

[`GradientFieldStyle`](@ref) trait describing fields that are mixed from other gradient fields.
Used e.g. for [`SuperimposedField`](@ref).
"""
struct MixedGradientField <: GradientFieldStyle end

export OtherGradientField
"""
    $(TYPEDEF)

[`GradientFieldStyle`](@ref) trait describing fields that are not matching the other kinds of gradient fields.
"""
struct OtherGradientField <: GradientFieldStyle end

export GradientFieldStyle
"""
    $(SIGNATURES)

Defines the [`GradientFieldStyle`](@ref) of a field.

For user-defined fields this method should be overriden by a more specific version.
The default is [`OtherGradientField`](@ref). For non-gradient field types it returns `nothing`.
"""
function GradientFieldStyle(field::AbstractMagneticField)
  return FieldStyle(field) isa GradientField ? OtherGradientField() : nothing
end

export FieldMovementStyle
"""
    $(TYPEDEF)

Trait describing the movement style of a field described by the type it is attached to.
"""
abstract type FieldMovementStyle end

export NoMovement
"""
    $(TYPEDEF)

[`FieldMovementStyle`](@ref) trait describing fields that are not moving.
"""
struct NoMovement <: FieldMovementStyle end

export RotationalMovement
"""
    $(TYPEDEF)

[`FieldMovementStyle`](@ref) trait describing fields that are rotatable.
"""
struct RotationalMovement <: FieldMovementStyle end

export TranslationalMovement
"""
    $(TYPEDEF)

[`FieldMovementStyle`](@ref) trait describing fields that are translatable.
"""
struct TranslationalMovement <: FieldMovementStyle end

export RotationalTranslationalMovement
"""
    $(TYPEDEF)

[`FieldMovementStyle`](@ref) trait describing fields that are rotatable and translatable.
"""
struct RotationalTranslationalMovement <: FieldMovementStyle end

export FieldMovementStyle
"""
    $(SIGNATURES)

Defines the [`FieldMovementStyle`](@ref) of a field.

For user-defined fields this method should be overriden by a more specific version.
The default is [`NoMovement`](@ref).
"""
FieldMovementStyle(::AbstractMagneticField) = NoMovement()

export isRotatable
"""
    $(SIGNATURES)

Determine whether a field is rotatable or not.
"""
isRotatable(field::AbstractMagneticField) = isRotatable(FieldMovementStyle(field))
isRotatable(::FieldMovementStyle) = false
isRotatable(::RotationalMovement) = true
isRotatable(::RotationalTranslationalMovement) = true

export isTranslatable
"""
    $(SIGNATURES)

Determine whether a field is translatable or not.
"""
isTranslatable(field::AbstractMagneticField) = isTranslatable(FieldMovementStyle(field))
isTranslatable(::FieldMovementStyle) = false
isTranslatable(::TranslationalMovement) = true
isTranslatable(::RotationalTranslationalMovement) = true

export DimensionalityStyle
"""
    $(TYPEDEF)

Type for describing the dimensionality of a fields [`MovementDimensionalityStyle`](@ref).
"""
abstract type DimensionalityStyle end

export ZeroDimensional
"""
    $(TYPEDEF)

[`DimensionalityStyle`](@ref) describing a zero-dimensional [`MovementDimensionalityStyle`](@ref).
"""
struct ZeroDimensional <: DimensionalityStyle end

export OneDimensional
"""
    $(TYPEDEF)

[`DimensionalityStyle`](@ref) describing a one-dimensional [`MovementDimensionalityStyle`](@ref).
"""
struct OneDimensional <: DimensionalityStyle end

export TwoDimensional
"""
    $(TYPEDEF)

[`DimensionalityStyle`](@ref) describing a two-dimensional [`MovementDimensionalityStyle`](@ref).
"""
struct TwoDimensional <: DimensionalityStyle end

export ThreeDimensional
"""
    $(TYPEDEF)

[`DimensionalityStyle`](@ref) describing a three-dimensional [`MovementDimensionalityStyle`](@ref).
"""
struct ThreeDimensional <: DimensionalityStyle end

Base.length(::Type{ZeroDimensional}) = 0
Base.length(::Type{OneDimensional}) = 1
Base.length(::Type{TwoDimensional}) = 2
Base.length(::Type{ThreeDimensional}) = 3

export MovementDimensionalityStyle
abstract type MovementDimensionalityStyle{T <: DimensionalityStyle} end
function Base.length(::Type{<:MovementDimensionalityStyle{T}}) where {T <: DimensionalityStyle}
  return length(T)
end

export RotationalDimensionalityStyle
struct RotationalDimensionalityStyle{T <: DimensionalityStyle} <: MovementDimensionalityStyle{T} end
function RotationalDimensionalityStyle(field::AbstractMagneticField)
  return RotationalDimensionalityStyle(FieldMovementStyle(field), field)
end
function RotationalDimensionalityStyle(::FieldMovementStyle, field::AbstractMagneticField)
  return RotationalDimensionalityStyle{ZeroDimensional}()
end
function RotationalDimensionalityStyle(::RotationalMovement, field::AbstractMagneticField)
  return RotationalDimensionalityStyle{OneDimensional}()
end
function RotationalDimensionalityStyle(::RotationalTranslationalMovement, field::AbstractMagneticField)
  return RotationalDimensionalityStyle{OneDimensional}()
end

export TranslationalDimensionalityStyle
struct TranslationalDimensionalityStyle{T <: DimensionalityStyle} <: MovementDimensionalityStyle{T} end
function TranslationalDimensionalityStyle(field::AbstractMagneticField)
  return TranslationalDimensionalityStyle(FieldMovementStyle(field), field)
end
function TranslationalDimensionalityStyle(::FieldMovementStyle, field::AbstractMagneticField)
  return TranslationalDimensionalityStyle{ZeroDimensional}()
end
function TranslationalDimensionalityStyle(::TranslationalMovement, field::AbstractMagneticField)
  return TranslationalDimensionalityStyle{ThreeDimensional}()
end
function TranslationalDimensionalityStyle(::RotationalTranslationalMovement, field::AbstractMagneticField)
  return TranslationalDimensionalityStyle{ThreeDimensional}()
end

# Note: The followig functions are not needed atm but I will leave them here for the case of future needs
# listNumAdditionalParameters(field::AbstractMagneticField) = listNumAdditionalParameters(FieldTimeDependencyStyle(field), field)
# listNumAdditionalParameters(::TimeConstant, field::AbstractMagneticField) = listNumAdditionalParameters(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field)
# listNumAdditionalParameters(::TimeConstant, ::NoMovement, field::AbstractMagneticField) = []
# listNumAdditionalParameters(::TimeConstant, ::RotationalMovement, field::AbstractMagneticField) = [length(RotationalDimensionalityStyle(field))]
# listNumAdditionalParameters(::TimeConstant, ::TranslationalMovement, field::AbstractMagneticField) = [length(TranslationalDimensionalityStyle(field))]
# listNumAdditionalParameters(::TimeConstant, ::RotationalTranslationalMovement, field::AbstractMagneticField) = [length(TranslationalDimensionalityStyle(field)), length(TranslationalDimensionalityStyle(field))]

# listNumAdditionalParameters(::TimeVarying, field::AbstractMagneticField) = listNumAdditionalParameters(FieldTimeDependencyStyle(field), FieldMovementStyle(field), field)
# listNumAdditionalParameters(::TimeVarying, ::NoMovement, field::AbstractMagneticField) = [1]
# listNumAdditionalParameters(::TimeVarying, ::RotationalMovement, field::AbstractMagneticField) = [1, length(RotationalDimensionalityStyle(field))]
# listNumAdditionalParameters(::TimeVarying, ::TranslationalMovement, field::AbstractMagneticField) = [1, length(TranslationalDimensionalityStyle(field))]
# listNumAdditionalParameters(::TimeVarying, ::RotationalTranslationalMovement, field::AbstractMagneticField) = [1, length(TranslationalDimensionalityStyle(field)), length(TranslationalDimensionalityStyle(field))]

# numAdditionalParameters(field::AbstractMagneticField) = sum(listNumAdditionalParameters(field))

# numMovementParameters(field::AbstractMagneticField) = numMovementParameters(FieldMovementStyle(field), field)
# numMovementParameters(::NoMovement, field::AbstractMagneticField) = 0
# numMovementParameters(::RotationalMovement, field::AbstractMagneticField) = 1
# numMovementParameters(::TranslationalMovement, field::AbstractMagneticField) = 1
# numMovementParameters(::RotationalTranslationalMovement, field::AbstractMagneticField) = 2