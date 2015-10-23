//
//  ForkableGeneratorType.swift
//  Spork
//
//  Created by Jaden Geller on 10/12/15.
//
//

public protocol ForkableGeneratorType: GeneratorType {
    // Returns an identical generator that will generate the same elements
    // (and will not change state in response to a state change of the parent generator)
    func fork() -> Self
}

// Generators that already have value-like semantics or whose elements can be easily computed
// can conform to this protocol to provide a more efficient implementation of fork
extension IndexingGenerator: ForkableGeneratorType {
    public func fork() -> IndexingGenerator { return self }
}
