# asak

[![Build Status](https://travis-ci.com/nobrakal/asak.svg?branch=master)](https://travis-ci.com/nobrakal/asak)

Asak is an OCaml library that allows to identify similar OCaml codes.

## Why ?

* For teaching: the module `Asak.Partition` offers a function `create` that produces a partition of codes implementing the same function, where two codes are in the same class if they are syntactically "close".

* For redundancy detection: `Asak.Redundancy` provides a function `search` which takes filenames and produces a clustering of the closest toplevel let-definitions.

## How ?

The idea is to compare AST (Abstract Syntax Tree) of codes. However, the OCaml AST is too rich for our purpose (since, for example, `match x with ...` and `function ...` generate two different AST). We decided instead to use the Lambda language, an intermediate language in the OCaml compilation pipeline, where such syntactic sugar is optimized away.

To efficiently compare Lambda trees, we use the idea of [Chilowicz et al.](http://igm.univ-mlv.fr/~chilowi/research/syntax_tree_fingerprinting/syntax_tree_fingerprinting_ICPC09.default_pdf.pdf) which consist in hashing recursively trees.

We then compare hashes and provide a clustering of the closest functions.

### But really, how ?

There is two cores:

* `Asak.Lambda_hash`, that defines a function `hash_lambda` which is hashing a Lambda expression, capturing the shape of the AST.

* `Asak.Clustering`, that defines a function `cluster` which is making a kind of complete-linkage clustering of a list of hashes. This function can parallelize some work.

## Documentation

The documentation of the API is available here: [https://nobrakal.github.io/asak/asak/](https://nobrakal.github.io/asak/asak/).

#### The name

This tool is about making partitions. "Partition" is the word in french for "sheet music". Consequently, its name is about music: [asak](https://en.wikipedia.org/wiki/Tuareg_people#Music) is the name of Tuareg's traditional songs accompanied by a monochord violin.

## License and copyright

Asak is released under the MIT license. The copyright is held by IRIF / OCaml Software Foundation.

### Authors

Asak is developed by Alexandre Moine.
