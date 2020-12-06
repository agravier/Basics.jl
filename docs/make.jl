using Basics
using Documenter

makedocs(;
    modules=[Basics],
    authors="Alexandre Gravier",
    repo="https://github.com/agravier/Basics.jl/blob/{commit}{path}#L{line}",
    sitename="Basics.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://agravier.github.io/Basics.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/agravier/Basics.jl",
)
