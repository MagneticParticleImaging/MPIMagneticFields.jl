abstract type FieldDefinitionVolume end

struct RegularGridDefinition{T, N} <: FieldDefinitionVolume where {T <: Unitful.Length, N <: Integer}
  shape::SVector{N, Int}
  fov::SVector{N, T}
  center::SVector{N, T}
end
