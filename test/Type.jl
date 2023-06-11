@testset "Type" begin
  @testset "Defaults" begin
    mutable struct TestField <: AbstractMagneticField end

    testField = TestField()

    @test_throws ErrorException value(testField, [0, 0, 0])
  end

  @testset "Movement variants" begin
    mutable struct TestFieldNoMovement <: AbstractMagneticField end

    MPIMagneticFields.FieldStyle(::TestFieldNoMovement) = HomogeneousField()
    MPIMagneticFields.FieldDefinitionStyle(::TestFieldNoMovement) = MethodBasedFieldDefinition()
    MPIMagneticFields.FieldTimeDependencyStyle(::TestFieldNoMovement) = TimeConstant()
    MPIMagneticFields.FieldMovementStyle(::TestFieldNoMovement) = NoMovement()

    MPIMagneticFields.value_(field::TestFieldNoMovement, r) = r .* [1, 1, 1]

    field_nomovement = TestFieldNoMovement()

    @test all(isapprox.(value(field_nomovement, [0, 0, 0]), [0, 0, 0], atol = 1e-10))
    @test all(isapprox.(value(field_nomovement, [1, 1, 1]), [1, 1, 1], atol = 1e-10))

    @test all(isapprox.(value(field_nomovement, [0:1, 0, 0]), [[i, 0, 0] for i ∈ 0:1], atol = 1e-10))

    mutable struct TestFieldRotatable <: AbstractMagneticField end

    MPIMagneticFields.FieldStyle(::TestFieldRotatable) = HomogeneousField()
    MPIMagneticFields.FieldDefinitionStyle(::TestFieldRotatable) = MethodBasedFieldDefinition()
    MPIMagneticFields.FieldTimeDependencyStyle(::TestFieldRotatable) = TimeConstant()
    MPIMagneticFields.FieldMovementStyle(::TestFieldRotatable) = RotationalMovement()

    MPIMagneticFields.value_(field::TestFieldRotatable, r, ϕ) = [sin(ϕ), cos(ϕ), 0] .* r

    field_rotatable = TestFieldRotatable()

    @test all(isapprox.(value(field_rotatable, [1, 1, 1], 0), [0, 1, 0], atol = 1e-10))
    @test all(isapprox.(value(field_rotatable, [1, 1, 1], π / 2), [1, 0, 0], atol = 1e-10))

    @test all(isapprox.(value(field_rotatable, [0:1, 1, 1], 0), [[0, 1, 0] for i ∈ 0:1], atol = 1e-10))

    mutable struct TestFieldTranslatable <: AbstractMagneticField end

    MPIMagneticFields.FieldStyle(::TestFieldTranslatable) = HomogeneousField()
    MPIMagneticFields.FieldDefinitionStyle(::TestFieldTranslatable) = MethodBasedFieldDefinition()
    MPIMagneticFields.FieldTimeDependencyStyle(::TestFieldTranslatable) = TimeConstant()
    MPIMagneticFields.FieldMovementStyle(::TestFieldTranslatable) = TranslationalMovement()

    MPIMagneticFields.value_(field::TestFieldTranslatable, r, δ) = r .+ δ

    field_translatable = TestFieldTranslatable()

    @test all(isapprox.(value(field_translatable, [0, 0, 0], [0, 0, 0]), [0, 0, 0], atol = 1e-10))
    @test all(isapprox.(value(field_translatable, [0, 0, 0], [1, 1, 1]), [1, 1, 1], atol = 1e-10))

    @test all(
      isapprox.(value(field_translatable, [0:1, 0, 0], [0, 0, 0]), [[i, 0, 0] for i ∈ 0:1], atol = 1e-10),
    )

    mutable struct TestFieldRotatableTranslatable <: AbstractMagneticField end

    MPIMagneticFields.FieldStyle(::TestFieldRotatableTranslatable) = HomogeneousField()
    MPIMagneticFields.FieldDefinitionStyle(::TestFieldRotatableTranslatable) = MethodBasedFieldDefinition()
    MPIMagneticFields.FieldTimeDependencyStyle(::TestFieldRotatableTranslatable) = TimeConstant()
    MPIMagneticFields.FieldMovementStyle(::TestFieldRotatableTranslatable) = RotationalTranslationalMovement()

    MPIMagneticFields.value_(field::TestFieldRotatableTranslatable, r, ϕ, δ) = [sin(ϕ), cos(ϕ), 0] .* r .+ δ

    field_rotatable_translatable = TestFieldRotatableTranslatable()

    @test all(
      isapprox.(value(field_rotatable_translatable, [1, 1, 1], 0, [0, 0, 0]), [0, 1, 0], atol = 1e-10),
    )
    @test all(
      isapprox.(value(field_rotatable_translatable, [1, 1, 1], π / 2, [0, 0, 0]), [1, 0, 0], atol = 1e-10),
    )
    @test all(
      isapprox.(value(field_rotatable_translatable, [1, 1, 1], 0, [1, 1, 1]), [1, 2, 1], atol = 1e-10),
    )
    @test all(
      isapprox.(value(field_rotatable_translatable, [1, 1, 1], π / 2, [1, 1, 1]), [2, 1, 1], atol = 1e-10),
    )

    @test all(
      isapprox.(
        value(field_rotatable_translatable, [0:1, 1, 1], 0, [0, 0, 0]),
        [[0, 1, 0] for i ∈ 0:1],
        atol = 1e-10,
      ),
    )
  end

  @testset "Time-varying" begin
    mutable struct TestFieldTimeVaryingNoMovement{U, V} <:
                   AbstractMagneticField where {T <: Number, U <: AbstractVector{T}, V <: Number}
      value::U
      frequency::V
    end

    MPIMagneticFields.FieldStyle(::TestFieldTimeVaryingNoMovement) = HomogeneousField()
    MPIMagneticFields.FieldDefinitionStyle(::TestFieldTimeVaryingNoMovement) = MethodBasedFieldDefinition()
    MPIMagneticFields.FieldTimeDependencyStyle(::TestFieldTimeVaryingNoMovement) = TimeVarying()
    MPIMagneticFields.FieldMovementStyle(::TestFieldTimeVaryingNoMovement) = NoMovement()

    function MPIMagneticFields.value_(field::TestFieldTimeVaryingNoMovement, t, r)
      return field.value .* sin.(2π * field.frequency * t)
    end

    field_varying_nomovement = TestFieldTimeVaryingNoMovement([1, 0, 0], 1)

    @test all(isapprox.(value(field_varying_nomovement, 0, [0, 0, 0]), [0, 0, 0], atol = 1e-10))
    @test all(isapprox.(value(field_varying_nomovement, 0, [1, 1, 1]), [0, 0, 0], atol = 1e-10))
    @test all(isapprox.(value(field_varying_nomovement, 1 / 4, [0, 0, 0]), [1, 0, 0], atol = 1e-10))
    @test all(isapprox.(value(field_varying_nomovement, 1 / 4, [1, 1, 1]), [1, 0, 0], atol = 1e-10))

    @test all(
      isapprox.(value(field_varying_nomovement, 0, [0:1, 0, 0]), [[0, 0, 0] for i ∈ 0:1], atol = 1e-10),
    )

    mutable struct TestFieldTimeVaryingRotatable{U, V} <:
                   AbstractMagneticField where {T <: Number, U <: AbstractVector{T}, V <: Number}
      value::U
      frequency::V
    end

    MPIMagneticFields.FieldStyle(::TestFieldTimeVaryingRotatable) = HomogeneousField()
    MPIMagneticFields.FieldDefinitionStyle(::TestFieldTimeVaryingRotatable) = MethodBasedFieldDefinition()
    MPIMagneticFields.FieldTimeDependencyStyle(::TestFieldTimeVaryingRotatable) = TimeVarying()
    MPIMagneticFields.FieldMovementStyle(::TestFieldTimeVaryingRotatable) = RotationalMovement()

    function MPIMagneticFields.value_(field::TestFieldTimeVaryingRotatable, t, r, ϕ)
      return [sin(ϕ), cos(ϕ), 0] .* field.value .* sin.(2π * field.frequency * t)
    end

    field_varying_rotatable = TestFieldTimeVaryingRotatable([1, 0, 0], 1)

    @test all(isapprox.(value(field_varying_rotatable, 0, [0, 0, 0], 0), [0, 0, 0], atol = 1e-10))
    @test all(isapprox.(value(field_varying_rotatable, 0, [1, 1, 1], 0), [0, 0, 0], atol = 1e-10))
    @test all(isapprox.(value(field_varying_rotatable, 1 / 4, [0, 0, 0], 0), [0, 0, 0], atol = 1e-10))
    @test all(isapprox.(value(field_varying_rotatable, 1 / 4, [1, 1, 1], 0), [0, 0, 0], atol = 1e-10))
    @test all(isapprox.(value(field_varying_rotatable, 0, [0, 0, 0], π / 2), [0, 0, 0], atol = 1e-10))
    @test all(isapprox.(value(field_varying_rotatable, 0, [1, 1, 1], π / 2), [0, 0, 0], atol = 1e-10))
    @test all(isapprox.(value(field_varying_rotatable, 1 / 4, [0, 0, 0], π / 2), [1, 0, 0], atol = 1e-10))
    @test all(isapprox.(value(field_varying_rotatable, 1 / 4, [1, 1, 1], π / 2), [1, 0, 0], atol = 1e-10))

    @test all(
      isapprox.(value(field_varying_rotatable, 0, [0:1, 0, 0], 0), [[0, 0, 0] for i ∈ 0:1], atol = 1e-10),
    )

    mutable struct TestFieldTimeVaryingTranslatable{U, V} <:
                   AbstractMagneticField where {T <: Number, U <: AbstractVector{T}, V <: Number}
      value::U
      frequency::V
    end

    MPIMagneticFields.FieldStyle(::TestFieldTimeVaryingTranslatable) = HomogeneousField()
    MPIMagneticFields.FieldDefinitionStyle(::TestFieldTimeVaryingTranslatable) = MethodBasedFieldDefinition()
    MPIMagneticFields.FieldTimeDependencyStyle(::TestFieldTimeVaryingTranslatable) = TimeVarying()
    MPIMagneticFields.FieldMovementStyle(::TestFieldTimeVaryingTranslatable) = TranslationalMovement()

    function MPIMagneticFields.value_(field::TestFieldTimeVaryingTranslatable, t, r, δ)
      return field.value .* sin.(2π * field.frequency * t) .+ δ
    end

    field_varying_translatable = TestFieldTimeVaryingTranslatable([1, 0, 0], 1)

    @test all(isapprox.(value(field_varying_translatable, 0, [0, 0, 0], [0, 0, 0]), [0, 0, 0], atol = 1e-10))
    @test all(isapprox.(value(field_varying_translatable, 0, [1, 1, 1], [0, 0, 0]), [0, 0, 0], atol = 1e-10))
    @test all(
      isapprox.(value(field_varying_translatable, 1 / 4, [0, 0, 0], [0, 0, 0]), [1, 0, 0], atol = 1e-10),
    )
    @test all(
      isapprox.(value(field_varying_translatable, 1 / 4, [1, 1, 1], [0, 0, 0]), [1, 0, 0], atol = 1e-10),
    )
    @test all(isapprox.(value(field_varying_translatable, 0, [0, 0, 0], [1, 1, 1]), [1, 1, 1], atol = 1e-10))
    @test all(isapprox.(value(field_varying_translatable, 0, [1, 1, 1], [1, 1, 1]), [1, 1, 1], atol = 1e-10))
    @test all(
      isapprox.(value(field_varying_translatable, 1 / 4, [0, 0, 0], [1, 1, 1]), [2, 1, 1], atol = 1e-10),
    )
    @test all(
      isapprox.(value(field_varying_translatable, 1 / 4, [1, 1, 1], [1, 1, 1]), [2, 1, 1], atol = 1e-10),
    )

    @test all(
      isapprox.(
        value(field_varying_translatable, 0, [0:1, 0, 0], [0, 0, 0]),
        [[0, 0, 0] for i ∈ 0:1],
        atol = 1e-10,
      ),
    )

    mutable struct TestFieldTimeVaryingRotatableTranslatable{U, V} <:
                   AbstractMagneticField where {T <: Number, U <: AbstractVector{T}, V <: Number}
      value::U
      frequency::V
    end

    MPIMagneticFields.FieldStyle(::TestFieldTimeVaryingRotatableTranslatable) = HomogeneousField()
    function MPIMagneticFields.FieldDefinitionStyle(::TestFieldTimeVaryingRotatableTranslatable)
      return MethodBasedFieldDefinition()
    end
    MPIMagneticFields.FieldTimeDependencyStyle(::TestFieldTimeVaryingRotatableTranslatable) = TimeVarying()
    function MPIMagneticFields.FieldMovementStyle(::TestFieldTimeVaryingRotatableTranslatable)
      return RotationalTranslationalMovement()
    end

    function MPIMagneticFields.value_(field::TestFieldTimeVaryingRotatableTranslatable, t, r, ϕ, δ)
      return [sin(ϕ), cos(ϕ), 0] .* field.value .* sin.(2π * field.frequency * t) .+ δ
    end

    field_varying_rotatable_translatable = TestFieldTimeVaryingRotatableTranslatable([1, 0, 0], 1)

    @test all(
      isapprox.(
        value(field_varying_rotatable_translatable, 0, [0, 0, 0], 0, [0, 0, 0]),
        [0, 0, 0],
        atol = 1e-10,
      ),
    )
    @test all(
      isapprox.(
        value(field_varying_rotatable_translatable, 0, [1, 1, 1], 0, [0, 0, 0]),
        [0, 0, 0],
        atol = 1e-10,
      ),
    )
    @test all(
      isapprox.(
        value(field_varying_rotatable_translatable, 1 / 4, [0, 0, 0], 0, [0, 0, 0]),
        [0, 0, 0],
        atol = 1e-10,
      ),
    )
    @test all(
      isapprox.(
        value(field_varying_rotatable_translatable, 1 / 4, [1, 1, 1], 0, [0, 0, 0]),
        [0, 0, 0],
        atol = 1e-10,
      ),
    )
    @test all(
      isapprox.(
        value(field_varying_rotatable_translatable, 0, [0, 0, 0], 0, [1, 1, 1]),
        [1, 1, 1],
        atol = 1e-10,
      ),
    )
    @test all(
      isapprox.(
        value(field_varying_rotatable_translatable, 0, [1, 1, 1], 0, [1, 1, 1]),
        [1, 1, 1],
        atol = 1e-10,
      ),
    )
    @test all(
      isapprox.(
        value(field_varying_rotatable_translatable, 1 / 4, [0, 0, 0], 0, [1, 1, 1]),
        [1, 1, 1],
        atol = 1e-10,
      ),
    )
    @test all(
      isapprox.(
        value(field_varying_rotatable_translatable, 1 / 4, [1, 1, 1], 0, [1, 1, 1]),
        [1, 1, 1],
        atol = 1e-10,
      ),
    )

    @test all(
      isapprox.(
        value(field_varying_rotatable_translatable, 0, [0, 0, 0], π / 2, [0, 0, 0]),
        [0, 0, 0],
        atol = 1e-10,
      ),
    )
    @test all(
      isapprox.(
        value(field_varying_rotatable_translatable, 0, [1, 1, 1], π / 2, [0, 0, 0]),
        [0, 0, 0],
        atol = 1e-10,
      ),
    )
    @test all(
      isapprox.(
        value(field_varying_rotatable_translatable, 1 / 4, [0, 0, 0], π / 2, [0, 0, 0]),
        [1, 0, 0],
        atol = 1e-10,
      ),
    )
    @test all(
      isapprox.(
        value(field_varying_rotatable_translatable, 1 / 4, [1, 1, 1], π / 2, [0, 0, 0]),
        [1, 0, 0],
        atol = 1e-10,
      ),
    )
    @test all(
      isapprox.(
        value(field_varying_rotatable_translatable, 0, [0, 0, 0], π / 2, [1, 1, 1]),
        [1, 1, 1],
        atol = 1e-10,
      ),
    )
    @test all(
      isapprox.(
        value(field_varying_rotatable_translatable, 0, [1, 1, 1], π / 2, [1, 1, 1]),
        [1, 1, 1],
        atol = 1e-10,
      ),
    )
    @test all(
      isapprox.(
        value(field_varying_rotatable_translatable, 1 / 4, [0, 0, 0], π / 2, [1, 1, 1]),
        [2, 1, 1],
        atol = 1e-10,
      ),
    )
    @test all(
      isapprox.(
        value(field_varying_rotatable_translatable, 1 / 4, [1, 1, 1], π / 2, [1, 1, 1]),
        [2, 1, 1],
        atol = 1e-10,
      ),
    )

    @test all(
      isapprox.(
        value(field_varying_rotatable_translatable, 0, [0:1, 0, 0], 0, [0, 0, 0]),
        [[0, 0, 0] for i ∈ 0:1],
        atol = 1e-10,
      ),
    )
  end
end
