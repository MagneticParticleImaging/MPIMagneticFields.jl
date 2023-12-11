# Note: this section is experimental since it is normally not a performant style to choose such a data layout (array of structs instead struct of arrays)
#export AbstractFieldNode # Note: Not yet exported since this is currently experimental. This may change in the future.
"""
    $(TYPEDEF)

Abstract supertype for evaluated nodes of magnetic fields.
"""
abstract type AbstractFieldNode end

#export FieldNode # Note: Not yet exported since this is currently experimental. This may change in the future.
"""
    $(TYPEDEF)

Evaluated node of magnetic field.
"""
struct FieldNode{T, V} <: AbstractFieldNode
  value::T
  position::V
end

#export nodes # Note: Not yet exported since this is currently experimental. This may change in the future.
"""
    $(SIGNATURES)

Evaluate field at given position and return it together with the position.
"""
nodes(field::AbstractMagneticField, args...; kwargs...) =
  nodes(FieldTimeDependencyStyle(field), field, args...; kwargs...)
# TODO: Use generator for functions
function nodes(::TimeConstant, field::AbstractMagneticField, args...; kwargs...)
  if length(args) > 1
    return [
      FieldNode(value(field, [r_...], args[2:end]...; kwargs...), r_) for r_ ∈ Iterators.product(args[1]...)
    ]
  else
    return [FieldNode(value(field, [r_...]; kwargs...), r_) for r_ ∈ Iterators.product(args[1]...)]
  end
end
function nodes(::TimeVarying, field::AbstractMagneticField, args...; kwargs...)
  if length(args) > 2
    return [
      FieldNode(value(field, args[1], [r_...], args[3:end]...; kwargs...), r_) for
      r_ ∈ Iterators.product(args[2]...)
    ]
  else
    return [FieldNode(value(field, args[1], [r_...]; kwargs...), r_) for r_ ∈ Iterators.product(args[2]...)]
  end
end
