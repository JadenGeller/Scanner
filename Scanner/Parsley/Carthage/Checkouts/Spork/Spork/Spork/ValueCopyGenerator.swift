//
//  ValueCopyGenerator.swift
//  Spork
//
//  Created by Jaden Geller on 10/12/15.
//
//

// Automatically forks a generator on copy
public struct ValueCopyGenerator<Element>: GeneratorType {
    private var backing: AnyForkableGenerator<Element>
    
    public init<Base: ForkableGeneratorType where Base.Element == Element>(_ base: Base) {
        backing = anyForkableGenerator(base)
    }
    
    public mutating func next() -> Element? {
        if !isUniquelyReferencedNonObjC(&backing) { backing = backing.fork() }
        return backing.next()
    }
}
