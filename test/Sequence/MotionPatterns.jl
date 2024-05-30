@testset "MotionPatterns" begin
  t = range(0, 1, 10)u"s"

  @testset "RotationPatterns" begin
    @testset "NoRotationPattern" begin
      pattern = NoRotationPattern()
      @test all(motionAtTime(pattern, t) .== 0)
    end

    @testset "StandardRotationPattern" begin
      pattern = StandardRotationPattern(ω = 1.0u"rad/s", ϕ = 0.0u"rad")
      @test all(motionAtTime(pattern, t) .≈ range(0, 1, 10))

      pattern = StandardRotationPattern(ω = 1.0u"rad/s", ϕ = 1.0u"rad")
      @test all(motionAtTime(pattern, t) .≈ range(1, 2, 10))
    end

    @testset "StandardRotationPattern" begin
      pattern = NoisyRotationPattern(ω = 1.0u"rad/s", ϕ = 0.0u"rad", noiseAmplitude = 0.001)
      @test all(motionAtTime(pattern, t) .≈ range(0, 1, 10))

      pattern = NoisyRotationPattern(ω = 1.0u"rad/s", ϕ = 1.0u"rad", noiseAmplitude = 0.001)
      @test all(motionAtTime(pattern, t) .≈ range(1, 2, 10))
    end
  end

  @testset "TranslationPatterns" begin
    @testset "NoTranslationPattern" begin
      pattern = NoTranslationPattern()
      @test all(motionAtTime(pattern, t) .≈ 0u"mT")
    end

    @testset "SinusoidalTranslationPattern" begin
      pattern = SinusoidalTranslationPattern(f = 1u"Hz", amplitude = 1u"mT", offset = 1u"mT")

      @test motionAtTime(pattern, 0u"s") ≈ 1u"mT"
      @test motionAtTime(pattern, 0.25u"s") ≈ 2u"mT"
      @test motionAtTime(pattern, 0.5u"s") ≈ 1u"mT"

      @test frequency(pattern) == 1u"Hz"
      @test phase(pattern) == 0.0u"rad"
      @test amplitude(pattern) == 1u"mT"
      @test offset(pattern) == 1u"mT"
    end

    @testset "SawtoothTranslationPattern" begin
      pattern = SawtoothTranslationPattern(f = 1u"Hz", amplitude = 1u"mT", offset = 1u"mT")

      @test motionAtTime(pattern, 0u"s") ≈ 1u"mT"
      @test motionAtTime(pattern, 0.25u"s") ≈ 1.5u"mT"
      @test motionAtTime(pattern, 0.5u"s") ≈ 2u"mT"
      @test motionAtTime(pattern, 0.75u"s") ≈ 0.5u"mT"

      @test frequency(pattern) == 1u"Hz"
      @test phase(pattern) == 0.0u"rad"
      @test amplitude(pattern) == 1u"mT"
      @test offset(pattern) == 1u"mT"
    end

    @testset "TriangleTranslationPattern" begin
      pattern = TriangleTranslationPattern(f = 1u"Hz", amplitude = 1u"mT", offset = 1u"mT")

      @test motionAtTime(pattern, 0u"s") ≈ 1u"mT"
      @test motionAtTime(pattern, 0.25u"s") ≈ 2u"mT"
      @test motionAtTime(pattern, 0.5u"s") ≈ 1u"mT"
      @test motionAtTime(pattern, 0.75u"s") ≈ 0u"mT"

      @test frequency(pattern) == 1u"Hz"
      @test phase(pattern) == 0.0u"rad"
      @test amplitude(pattern) == 1u"mT"
      @test offset(pattern) == 1u"mT"
    end
  end
end