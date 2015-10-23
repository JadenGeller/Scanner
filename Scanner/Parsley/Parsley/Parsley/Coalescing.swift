//
//  Coalescing.swift
//  Parsley
//
//  Created by Jaden Geller on 10/19/15.
//  Copyright © 2015 Jaden Geller. All rights reserved.
//

/**
    Constructs a `Parser` that will parse with the first element of `parsers` that succeeds.

    - Parameter parsers: The sequence of parsers to attempt.
*/
public func coalesce<Token, Result, Sequence: SequenceType where Sequence.Generator.Element == Parser<Token, Result>>
    (parsers: Sequence) -> Parser<Token, Result> {
        return Parser { state in
            var errors = [ParseError]()
            for parser in parsers {
                do {
                    return try attempt(parser).parse(state)
                } catch let error as ParseError {
                    errors.append(error)
                }
            }
            let message = errors.reduce("") { result, next in result + ", " + next.message }
            throw ParseError("anyOf(\(message))")
        }
}

/**
    Constructs a `Parser` that will parse with the first element of `parsers` that succeeds.

    - Parameter parsers: A variadic list of parsers to attempt.
*/
public func coalesce<Token, Result>(parsers: (Parser<Token, Result>)...) -> Parser<Token, Result> {
    return coalesce(parsers)
}

/**
    Constructs a `Parser` that will parse with `rightParser` whenever `leftParser` fails.

    - Parameter leftParser: The parser to run first.
    - Parameter rightParser: The parser to run whenever the first parser fails.
*/
public func either<Token, LeftResult, RightResult>(leftParser: Parser<Token, LeftResult>, _ rightParser: Parser<Token, RightResult>) -> Parser<Token, Either<LeftResult, RightResult>> {
    return Parser { state in
        do {
            return .Left(try attempt(leftParser).parse(state))
        } catch let leftError as ParseError {
            do {
                return .Right(try rightParser.parse(state))
            } catch let rightError as ParseError {
                throw ParseError("either(\(leftError), \(rightError))")
            }
        }
    }
}

// MARK: Helpers

/**
    A datatype that can manifest itself as one of two types.
*/
public enum Either<A, B> {
    case Left(A)
    case Right(B)
}
