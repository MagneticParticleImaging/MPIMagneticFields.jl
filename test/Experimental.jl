@testset "Experimental" begin
  mutable struct TestExperimentalIdealHomogeneousFieldTimeConstant{U} <:
                 AbstractMagneticField where {T <: Number, U <: AbstractVector{T}}
    value::U
  end

  MPIMagneticFields.FieldStyle(::TestExperimentalIdealHomogeneousFieldTimeConstant) = HomogeneousField()
  function MPIMagneticFields.FieldDefinitionStyle(::TestExperimentalIdealHomogeneousFieldTimeConstant)
    return MethodBasedFieldDefinition()
  end
  function MPIMagneticFields.FieldTimeDependencyStyle(::TestExperimentalIdealHomogeneousFieldTimeConstant)
    return TimeConstant()
  end
  MPIMagneticFields.FieldMovementStyle(::TestExperimentalIdealHomogeneousFieldTimeConstant) = NoMovement()

  MPIMagneticFields.value_(field::TestExperimentalIdealHomogeneousFieldTimeConstant, r) = field.value

  field = TestExperimentalIdealHomogeneousFieldTimeConstant([1, 0, 0])

  nodes_ = MPIMagneticFields.nodes(field, [1:2, 1:2, 0])
  @test eltype(nodes_) <: MPIMagneticFields.FieldNode
  @test nodes_[1, 1] === MPIMagneticFields.FieldNode([1, 0, 0], (1, 1, 0))

  mutable struct TestExperimentalIdealHomogeneousFieldTimeVarying{U} <:
                 AbstractMagneticField where {T <: Number, U <: AbstractVector{T}}
    value::U
  end

  MPIMagneticFields.FieldStyle(::TestExperimentalIdealHomogeneousFieldTimeVarying) = HomogeneousField()
  function MPIMagneticFields.FieldDefinitionStyle(::TestExperimentalIdealHomogeneousFieldTimeVarying)
    return MethodBasedFieldDefinition()
  end
  function MPIMagneticFields.FieldTimeDependencyStyle(::TestExperimentalIdealHomogeneousFieldTimeVarying)
    return TimeConstant()
  end
  MPIMagneticFields.FieldMovementStyle(::TestExperimentalIdealHomogeneousFieldTimeVarying) = NoMovement()

  MPIMagneticFields.value_(field::TestExperimentalIdealHomogeneousFieldTimeVarying, r) = field.value

  field = TestExperimentalIdealHomogeneousFieldTimeVarying([1, 0, 0])

  nodes_ = MPIMagneticFields.nodes(field, 0, [1:2, 1:2, 0])
  @test eltype(nodes_) <: MPIMagneticFields.FieldNode
  @test nodes_[1, 1] === MPIMagneticFields.FieldNode([1, 0, 0], (1, 1, 0))
end
