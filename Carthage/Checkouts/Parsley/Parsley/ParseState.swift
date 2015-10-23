//
//  Parse.swift
//  Parsley
//
//  Created by Jaden Geller on 10/12/15.
//  Copyright © 2015 Jaden Geller. All rights reserved.
//

import Spork

public struct ParseStateSnapshot<Element> {
    private let backing: AnyForkableGenerator<Element>
    
    private init(_ backing: AnyForkableGenerator<Element>) {
        self.backing = backing
    }
    
    public func restoreImage() -> AnyForkableGenerator<Element> {
        return backing.fork()
    }
}

public final class ParseState<Element>: GeneratorType {
    private var generator: AnyForkableGenerator<Element>
    
    public convenience init<G: GeneratorType where G.Element == Element>(bridgedFromGenerator generator: G) {
        self.init(forkableGenerator: BufferingGenerator(bridgedFromGenerator: generator))
    }
    
    public init<G: ForkableGeneratorType where G.Element == Element>(forkableGenerator: G) {
        self.generator = anyForkableGenerator(forkableGenerator.fork())
    }

    public func next() -> Element? {
        return generator.next()
    }
    
    public func snapshot() -> ParseStateSnapshot<Element> {
        return ParseStateSnapshot(generator.fork())
    }
    
    public func rewind(toSnapshot snapshot: ParseStateSnapshot<Element>) {
        generator = snapshot.restoreImage()
    }
}

extension ParseState {
    convenience init<Sequence: SequenceType where Sequence.Generator: ForkableGeneratorType, Sequence.Generator.Element == Element>(sequence: Sequence) {
        self.init(forkableGenerator: sequence.generate())
    }
    
    convenience init<Sequence: SequenceType where Sequence.Generator.Element == Element>(sequence: Sequence) {
        self.init(bridgedFromGenerator: sequence.generate())
    }
}
