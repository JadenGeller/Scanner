//
//  ParserType.swift
//  Parsley
//
//  Created by Jaden Geller on 10/14/15.
//  Copyright © 2015 Jaden Geller. All rights reserved.
//

import Spork

public protocol ParserType {
    typealias Token
    typealias Result
    
    func parse(state: ParseState<Token>) throws -> Result
    func flatMap<MappedResult>(transform: Result throws -> Parser<Token, MappedResult>) -> Parser<Token, MappedResult>
}

extension ParserType {
    public func parse<Sequence: SequenceType where Sequence.Generator: ForkableGeneratorType, Sequence.Generator.Element == Token>(sequence: Sequence) throws -> Result {
        return try parse(ParseState(sequence: sequence))
    }
    
    public func parse<Sequence: SequenceType where Sequence.Generator.Element == Token>(sequence: Sequence) throws -> Result {
        return try parse(ParseState(sequence: sequence))
    }
}

