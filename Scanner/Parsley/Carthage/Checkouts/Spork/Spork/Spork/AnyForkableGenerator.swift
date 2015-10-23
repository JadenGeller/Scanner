//
//  AnyForkableGenerator.swift
//  Spork
//
//  Created by Jaden Geller on 10/12/15.
//
//

public final class AnyForkableGenerator<Element>: ForkableGeneratorType {
    private let _next: () -> Element?
    private let _fork: () -> AnyForkableGenerator
    
    internal init(next: () -> Element?, fork: () -> AnyForkableGenerator) {
        _next = next
        _fork = fork
    }
    
    public func fork() -> AnyForkableGenerator<Element> {
        return _fork()
    }
    
    public func next() -> Element? {
        return _next()
    }
}

public func anyForkableGenerator<G: ForkableGeneratorType>(var base: G) -> AnyForkableGenerator<G.Element> {
    return AnyForkableGenerator(next: { base.next() }, fork: { anyForkableGenerator(base.fork()) })
}

public func anyForkableGenerator<State, Element>(var state: State, duplicate: State -> State, next: inout State -> Element?) -> AnyForkableGenerator<Element> {
    return AnyForkableGenerator(next: { next(&state) }, fork: { anyForkableGenerator(duplicate(state), duplicate: duplicate, next: next) })
}