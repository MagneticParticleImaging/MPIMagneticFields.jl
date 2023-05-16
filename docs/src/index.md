```@meta
CurrentModule = MPIMagneticFields
```

# MPIMagneticFields

The package [MPIMagneticFields](https://github.com/MagneticParticleImaging/MPIMagneticFields.jl) contains methods for working with magnetic field representations for [Magnetic Particle Imaging](https://en.wikipedia.org/wiki/Magnetic_particle_imaging) and some basis field types. It is meant to extended with new field types e.g. from simulated or measured data.

## License / Terms of Usage

The source code of this project is licensed under the MIT license. This implies that
you are free to use, share, and adapt it. However, please give appropriate credit
by citing the project.

## Contact

If you have problems using the software, find mistakes, or have general questions please use
the [issue tracker](https://github.com/MagneticParticleImaging/MPIMagneticFields.jl/issues) to contact us.

## Usage

The package provides the abstract type `AbstractMagneticField` and a `value` function which every type derived from `AbstractMagneticField` must implement. Furthermore, some traits can be defined to describe properties of the field and te



```@index
```

```@autodocs
Modules = [MPIMagneticFields]
```
