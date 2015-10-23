# Spork
Spork defines Swift generators that can be copied while maintaining independent state.

Normally, some generators work this way...
```swift
let indexingGenerator = [1,2,3].generate()
let copy = indexingGenerator
print(indexingGenerator.next()) // -> 1
print(copy.next())              // -> 1
```

But other generators work like this...
```swift
let sharedStateGenerator = anyGenerator(indexingGenerator)
let copy = sharedStateGenerator
print(sharedStateGenerator.next()) // -> 1
print(copy.next())                 // -> 2
```

That's to say, there's nothing that guarentees that your generator copy won't share its state with the original generator. Spork defines a protocol `ForkableGeneratorType` with a method `fork` that guarentees unique state among forked copies. Spork also defines a type BufferingGenerator that bridges *any* type of generator to be a `ForkableGenerator` by maintaining a list of forked listeners and holding onto any still-needed elements for these generators.

```swift
let bufferingGenerator = BufferingGenerator(bridgedFromGenerator: sharedStateGenerator)
let copy = bufferingGenerator.fork()
print(bufferingGenerator.next()) // -> 1
print(copy.next())               // -> 1
```

Just like `AnyGenerator` is used for `GeneratorType` type-erasure, Spork defines a class `AnyForkableGenerator` that's used for `ForkableGeneratorType` type-erasure.
```swift
let typeErasedGenerator = anyGenerator(bufferingGenerator)
```

Spork also defines a `ValueCopyGenerator` that works like `BufferingGenerator`, but has value-semantics.
```swift
let valueCopyGenerator = ValueCopyGenerator(bufferingGenerator)
let copy = valueCopyGenerator
print(valueCopyGenerator.next()) // -> 1
print(copy.next())               // -> 1
```
