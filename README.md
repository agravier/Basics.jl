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

See [Trello board](https://trello.com/b/yR05sxc8/basicsjl-development)

### Julia

- [x] Implement Linked list in Julia
- [x] Implement Skip list in Julia
- [ ] Implement Hash table in Julia
- [ ] Implement Heap in Julia
- [ ] Implement Binary search tree in Julia
- [ ] Implement Radix tree (trie) in Julia
- [ ] Implement Rope in Julia
- [ ] Implement B* tree in Julia
- [ ] Implement Split Hashtables in Julia

### Python

- [ ] Implement Linked list in Python
- [ ] Implement Skip list in Python
- [ ] Implement Hash table in Python
- [ ] Implement Heap in Python
- [ ] Implement Binary search tree in Python
- [ ] Implement Radix tree (trie) in Python
- [ ] Implement Rope in Python
- [ ] Implement B* tree in Python
- [ ] Implement Split Hashtables in Python

### Tooling

- [ ] Make benchmarking test cases file format
- [ ] Make benchmarking tool
- [ ] Make Julia benchmarking CLI application
- [ ] Make Python benchmarking CLI application
