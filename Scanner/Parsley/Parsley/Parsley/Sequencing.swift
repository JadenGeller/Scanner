//
//  Sequencing.swift
//  Parsley
//
//  Created by Jaden Geller on 10/14/15.
//  Copyright © 2015 Jaden Geller. All rights reserved.
//

/**
    Constructs a `Parser` that will parse will each element of `parsers`, sequentially. Parsing only succeeds if every
    parser succeeds, and the resulting parser returns an array of the results.

    - Parameter parsers: The sequence of parsers to sequentially run.
*/
public func sequenced<Token, Result, Sequence: SequenceType where Sequence.Generator.Element == Parser<Token, Result>>
    (parsers: Sequence) -> Parser<Token, [Result]> {
    return Parser { state in
        var results = [Result]()
        for parser in parsers {
            results.append(try parser.parse(state))
        }
        return results
    }
}

/**
    Constructs a `Parser` that will parse will each element of `parsers`, sequentially. Parsing only succeeds if every
    parser succeeds, and the resulting parser returns an array of the results.

    - Parameter parsers: The variadic list of parsers to sequentially run.
*/
public func sequenced<Token, Result>(parsers: (Parser<Token, Result>)...) -> Parser<Token, [Result]> {
    return sequenced(parsers)
}

/**
    Constructs a `Parser` that will run the passed-in parsers sequentially. Parsing only succeeds if all
    parsers succeed, and the resulting parser returns an tuple of the results.
*/
public func sequence<Token, A, B>(parserA: Parser<Token, A>, _ parserB: Parser<Token, B>) -> Parser<Token, (A, B)> {
    return parserA.flatMap { a in
        parserB.map { b in
            return (a, b)
        }
    }
}

/**
    Constructs a `Parser` that will run the 2 passed-in parsers sequentially. Parsing only succeeds if both
    parsers succeed, and the resulting parser returns an tuple of the results.
*/
public func sequence<Token, A, B, C>(parserA: Parser<Token, A>, _ parserB: Parser<Token, B>, _ parserC: Parser<Token, C>) -> Parser<Token, (A, B, C)> {
    return sequence(sequence(parserA, parserB), parserC).map { ($0.0, $0.1, $1) }
}

/**
    Constructs a `Parser` that will run the 3 passed-in parsers sequentially. Parsing only succeeds if all
    parsers succeed, and the resulting parser returns an tuple of the results.
*/
public func sequence<Token, A, B, C, D>(parserA: Parser<Token, A>, _ parserB: Parser<Token, B>, _ parserC: Parser<Token, C>, _ parserD: Parser<Token, D>) -> Parser<Token, (A, B, C, D)> {
    return sequence(sequence(parserA, parserB, parserC), parserD).map { ($0.0, $0.1, $0.2, $1) }
}

/**
    Constructs a `Parser` that will run the 4 passed-in parsers sequentially. Parsing only succeeds if all
    parsers succeed, and the resulting parser returns an tuple of the results.
*/
public func sequence<Token, A, B, C, D, E>(parserA: Parser<Token, A>, _ parserB: Parser<Token, B>, _ parserC: Parser<Token, C>, _ parserD: Parser<Token, D>, _ parserE: Parser<Token, E>) -> Parser<Token, (A, B, C, D, E)> {
    return sequence(sequence(parserA, parserB, parserC, parserD), parserE).map { ($0.0, $0.1, $0.2, $0.3, $1) }
}

/**
    Constructs a `Parser` that will run the 5 passed-in parsers sequentially. Parsing only succeeds if all
    parsers succeed, and the resulting parser returns an tuple of the results.
*/
public func sequence<Token, A, B, C, D, E, F>(parserA: Parser<Token, A>, _ parserB: Parser<Token, B>, _ parserC: Parser<Token, C>, _ parserD: Parser<Token, D>, _ parserE: Parser<Token, E>, _ parserF: Parser<Token, F>) -> Parser<Token, (A, B, C, D, E, F)> {
    return sequence(sequence(parserA, parserB, parserC, parserD, parserE), parserF).map { ($0.0, $0.1, $0.2, $0.3, $0.4, $1) }
}

/**
    Constructs a `Parser` that will run the 6 passed-in parsers sequentially. Parsing only succeeds if all
    parsers succeed, and the resulting parser returns an tuple of the results.
*/
public func sequence<Token, A, B, C, D, E, F, G>(parserA: Parser<Token, A>, _ parserB: Parser<Token, B>, _ parserC: Parser<Token, C>, _ parserD: Parser<Token, D>, _ parserE: Parser<Token, E>, _ parserF: Parser<Token, F>, _ parserG: Parser<Token, G>) -> Parser<Token, (A, B, C, D, E, F, G)> {
    return sequence(sequence(parserA, parserB, parserC, parserD, parserE, parserF), parserG).map { ($0.0, $0.1, $0.2, $0.3, $0.4, $0.5, $1) }
}

/**
    Constructs a `Parser` that will run the 7 passed-in parsers sequentially. Parsing only succeeds if all
    parsers succeed, and the resulting parser returns an tuple of the results.
*/
public func sequence<Token, A, B, C, D, E, F, G, H>(parserA: Parser<Token, A>, _ parserB: Parser<Token, B>, _ parserC: Parser<Token, C>, _ parserD: Parser<Token, D>, _ parserE: Parser<Token, E>, _ parserF: Parser<Token, F>, _ parserG: Parser<Token, G>, _ parserH: Parser<Token, H>) -> Parser<Token, (A, B, C, D, E, F, G, H)> {
    return sequence(sequence(parserA, parserB, parserC, parserD, parserE, parserF, parserG), parserH).map { ($0.0, $0.1, $0.2, $0.3, $0.4, $0.5, $0.6, $1) }
}

/**
    Constructs a `Parser` that will run the 8 passed-in parsers sequentially. Parsing only succeeds if all
    parsers succeed, and the resulting parser returns an tuple of the results.
*/
public func sequence<Token, A, B, C, D, E, F, G, H, I>(parserA: Parser<Token, A>, _ parserB: Parser<Token, B>, _ parserC: Parser<Token, C>, _ parserD: Parser<Token, D>, _ parserE: Parser<Token, E>, _ parserF: Parser<Token, F>, _ parserG: Parser<Token, G>, _ parserH: Parser<Token, H>, _ parserI: Parser<Token, I>) -> Parser<Token, (A, B, C, D, E, F, G, H, I)> {
    return sequence(sequence(parserA, parserB, parserC, parserD, parserE, parserF, parserG, parserH), parserI).map { ($0.0, $0.1, $0.2, $0.3, $0.4, $0.5, $0.6, $0.7, $1) }
}

/**
    Constructs a `Parser` that will run the 9 passed-in parsers sequentially. Parsing only succeeds if all
    parsers succeed, and the resulting parser returns an tuple of the results.
*/
public func sequence<Token, A, B, C, D, E, F, G, H, I, J>(parserA: Parser<Token, A>, _ parserB: Parser<Token, B>, _ parserC: Parser<Token, C>, _ parserD: Parser<Token, D>, _ parserE: Parser<Token, E>, _ parserF: Parser<Token, F>, _ parserG: Parser<Token, G>, _ parserH: Parser<Token, H>, _ parserI: Parser<Token, I>,  _ parserJ: Parser<Token, J>) -> Parser<Token, (A, B, C, D, E, F, G, H, I, J)> {
    return sequence(sequence(parserA, parserB, parserC, parserD, parserE, parserF, parserG, parserH, parserI), parserJ).map { ($0.0, $0.1, $0.2, $0.3, $0.4, $0.5, $0.6, $0.7, $0.8, $1) }
}
