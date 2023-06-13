using MPIMagneticFields
using Documenter

DocMeta.setdocmeta!(
  MPIMagneticFields,
  :DocTestSetup,
  :(using MPIMagneticFields);
  recursive = true,
)

makedocs(;
  modules = [MPIMagneticFields],
  authors = "Marija Boberg <m.boberg@uke.de> and contributors",
  repo = "https://github.com/MagneticParticleImaging/MPIMagneticFields.jl/blob/{commit}{path}#{line}",
  sitename = "MPIMagneticFields.jl",
  format = Documenter.HTML(;
    prettyurls = get(ENV, "CI", "false") == "true",
    canonical = "https://github.com/MagneticParticleImaging/MPIMagneticFields.jl",
    assets = String[],
  ),
  pages = ["Home" => "index.md"],
  checkdocs=:all,
  linkcheck = true,
  strict=[:missing_docs, :linkcheck]
)

deploydocs(;
  repo = "github.com/MagneticParticleImaging/MPIMagneticFields.jl.git",
  target = "build",
)
