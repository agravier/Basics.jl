# Basics

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://agravier.github.io/Basics.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://agravier.github.io/Basics.jl/dev)
[![Build Status](https://github.com/agravier/Basics.jl/workflows/CI/badge.svg)](https://github.com/agravier/Basics.jl/actions)
[![Coverage](https://codecov.io/gh/agravier/Basics.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/agravier/Basics.jl)

Julia implementations of basic algorithms and data structures

## Implementations list

|Algo|Source reference|
|:--|:--|
|Linked list|[LinkedLists.jl](src/LinkedLists.jl)|
|Skip list|[SkipLists.jl](src/SkipLists.jl)|


## Running tests

```shell
julia --project -e 'using Pkg; Pkg.test()'
```

## TODO

- [x] Linked list
- [ ] Skip list
- [ ] Hash table
- [ ] Heap
- [ ] Binary search tree
- [ ] Radix tree (trie)
- [ ] Rope
- [ ] B* tree
- [ ] Split Hashtables
