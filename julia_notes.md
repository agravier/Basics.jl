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

### Managing dependencies

From the Julia REPL, type `]` to enter the Pkg REPL. Then `activate .` to activate the venv.

|Command|Explanation|
|:--|:--|
|add Example|add latest stable|
|add Example#master|track master branch|
|add Example@0.4|add specific version|
|add https://github.com/... | add repo |
|add Example|add dependency in development mode|
|pin Example|prevent update of dependency|
|free Example|Remove version/git/dev/... constraint and use latest stable|
|rm example|Remove dependency|
|gc|Remove unused implicit deps|
|up|update all deps|
|up Example|update dependency|
|up --minor Example|update only up to minor|

[[Pkg ref doc](https://julialang.github.io/Pkg.jl/v1/managing-packages/)]

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

### Performance

[[Ref](https://docs.julialang.org/en/v1/manual/performance-tips/)]
