# OxCaml Project Notes

This is a hello-world project using the `oxidizing` opam switch (`ocaml-variants.5.2.0+ox`, dune 3.22.2).

## Syntax differences from the "Oxidizing OCaml" paper

### Mode annotations in type expressions

The paper wraps the annotated type in extra parentheses:
```ocaml
((('a, 'b) pair) @ unique) -> ...
```
The current parser only accepts `@ mode` at the outermost level of a type in a function arrow — extra wrapping parens cause a syntax error:
```ocaml
('a, 'b) pair @ unique -> ...   (* correct *)
```

### `overwrite` record expression

The paper's record-overwrite syntax no longer exists:
```ocaml
{ overwrite pair with snd = c }   (* paper — parse error in current compiler *)
```
It has been replaced by:
```ocaml
overwrite_ pair with { snd = c }   (* current syntax *)
```
However, **`overwrite_` is not yet implemented in the backend** as of `5.2.0+ox`. It parses and type-checks but hits a fatal error at code generation. It also requires the `-extension-universe alpha` compiler flag. Use a regular `{ pair with snd = c }` as a placeholder until a future release implements it.
