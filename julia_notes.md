### Creating a project from a template

Using [PkgTemplates](https://github.com/invenia/PkgTemplates.jl)

```julia
using PkgTemplates

t = Template(;
    user="agravier",
    dir="~/repos",
    authors="Alexandre Gravier",
    julia=v"1.5",
    plugins=[
        Tests(; project=true),
        License(; name="MIT"),
        Git(; manifest=true, ssh=true),
        GitHubActions(; coverage=true),
        Codecov(),
        Documenter{GitHubActions}(),
    ],
)
t("Basics")
mv("Basics", "Basics.jl")
```

- Tests can have their own Project.toml (since Julia 1.2), and this is set by `project=true` above
[[Ref](https://julialang.github.io/Pkg.jl/v1/creating-packages/#Test-specific-dependencies-in-Julia-1.2-and-above-1)]
- Github Actions CI with CodeCov coverage requires the `CODECOV_TOKEN` secret to be defined in
_Github > <repository page> > Settings > Secrets > New repository secret_
[[Ref](https://docs.github.com/en/free-pro-team@latest/actions/reference/encrypted-secrets#creating-encrypted-secrets-for-a-repository)]

### Tests

Managing the test env and running tests

```julia
# From the Pkg REPL, activate the test env
activate ./test
# Add a test-specific dependency
add Test
# Run the Tests defined in test/runtests.jl
test
```
