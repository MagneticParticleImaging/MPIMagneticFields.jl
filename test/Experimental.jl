@testset "Experimental" begin
  @testset "Time constant, no movement" begin
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
    @test nodes_[1, 1].value == MPIMagneticFields.FieldNode([1, 0, 0], (1, 1, 0)).value
    @test nodes_[1, 1].position == MPIMagneticFields.FieldNode([1, 0, 0], (1, 1, 0)).position
  end

  @testset "Time varying, no movement" begin
    mutable struct TestExperimentalIdealHomogeneousFieldTimeVarying{U} <:
                   AbstractMagneticField where {T <: Number, U <: AbstractVector{T}}
      value::U
    end

    MPIMagneticFields.FieldStyle(::TestExperimentalIdealHomogeneousFieldTimeVarying) = HomogeneousField()
    function MPIMagneticFields.FieldDefinitionStyle(::TestExperimentalIdealHomogeneousFieldTimeVarying)
      return MethodBasedFieldDefinition()
    end
    function MPIMagneticFields.FieldTimeDependencyStyle(::TestExperimentalIdealHomogeneousFieldTimeVarying)
      return TimeVarying()
    end
    MPIMagneticFields.FieldMovementStyle(::TestExperimentalIdealHomogeneousFieldTimeVarying) = NoMovement()

    MPIMagneticFields.value_(field::TestExperimentalIdealHomogeneousFieldTimeVarying, t, r) = field.value

    field = TestExperimentalIdealHomogeneousFieldTimeVarying([1, 0, 0])

    nodes_ = MPIMagneticFields.nodes(field, 0, [1:2, 1:2, 0])
    @test eltype(nodes_) <: MPIMagneticFields.FieldNode
    @test nodes_[1, 1].value == MPIMagneticFields.FieldNode([1, 0, 0], (1, 1, 0)).value
    @test nodes_[1, 1].position == MPIMagneticFields.FieldNode([1, 0, 0], (1, 1, 0)).position
  end

  @testset "Time constant, rotational movement" begin
    mutable struct TestExperimentalRotationalFieldTimeConstant{U} <:
                   AbstractMagneticField where {T <: Number, U <: AbstractVector{T}}
      value::U
    end

    MPIMagneticFields.FieldStyle(::TestExperimentalRotationalFieldTimeConstant) = HomogeneousField()
    function MPIMagneticFields.FieldDefinitionStyle(::TestExperimentalRotationalFieldTimeConstant)
      return MethodBasedFieldDefinition()
    end
    MPIMagneticFields.FieldTimeDependencyStyle(::TestExperimentalRotationalFieldTimeConstant) = TimeConstant()
    MPIMagneticFields.FieldMovementStyle(::TestExperimentalRotationalFieldTimeConstant) = RotationalMovement()

    MPIMagneticFields.value_(field::TestExperimentalRotationalFieldTimeConstant, r, ϕ) = field.value

    field = TestExperimentalRotationalFieldTimeConstant([1, 0, 0])

    nodes_ = MPIMagneticFields.nodes(field, [1:2, 1:2, 0], 0)
    @test eltype(nodes_) <: MPIMagneticFields.FieldNode
    @test nodes_[1, 1].value == MPIMagneticFields.FieldNode([1, 0, 0], (1, 1, 0)).value
    @test nodes_[1, 1].position == MPIMagneticFields.FieldNode([1, 0, 0], (1, 1, 0)).position
  end

  @testset "Time varying, rotational movement" begin
    mutable struct TestExperimentalRotationalFieldTimeVarying{U} <:
                   AbstractMagneticField where {T <: Number, U <: AbstractVector{T}}
      value::U
    end

    MPIMagneticFields.FieldStyle(::TestExperimentalRotationalFieldTimeVarying) = HomogeneousField()
    function MPIMagneticFields.FieldDefinitionStyle(::TestExperimentalRotationalFieldTimeVarying)
      return MethodBasedFieldDefinition()
    end
    MPIMagneticFields.FieldTimeDependencyStyle(::TestExperimentalRotationalFieldTimeVarying) = TimeVarying()
    MPIMagneticFields.FieldMovementStyle(::TestExperimentalRotationalFieldTimeVarying) = RotationalMovement()

    MPIMagneticFields.value_(field::TestExperimentalRotationalFieldTimeVarying, t, r, ϕ) = field.value

    field = TestExperimentalRotationalFieldTimeVarying([1, 0, 0])

    nodes_ = MPIMagneticFields.nodes(field, 0, [1:2, 1:2, 0], 0)
    @test eltype(nodes_) <: MPIMagneticFields.FieldNode
    @test nodes_[1, 1].value == MPIMagneticFields.FieldNode([1, 0, 0], (1, 1, 0)).value
    @test nodes_[1, 1].position == MPIMagneticFields.FieldNode([1, 0, 0], (1, 1, 0)).position
  end
end
