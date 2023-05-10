#Base.size(S::SquaresVector) = (S.count,)
Base.IndexStyle(::Type{<:AbstractMagneticField}) = IndexCartesian()
function Base.getindex(field::AbstractMagneticField, tr...)
  if isTimeVarying(field)
    return value(field, tr[1], [tr[2:end]...]) # TODO: How to deal with rotation and translation?
  else
    return value(field, [tr...]) # TODO: How to deal with rotation and translation?
  end
end

# TODO: This only works with eachindex() available, which is only the case for fields defining a grid. How shall we solve this? Create a container?
#LinearAlgebra.norm(field::AbstractMagneticField) = [norm(field[i]) for i ∈ eachindex(field)]