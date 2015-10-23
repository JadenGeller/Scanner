//
//  Optional.swift
//  Parsley
//
//  Created by Jaden Geller on 10/19/15.
//  Copyright © 2015 Jaden Geller. All rights reserved.
//

extension Parser {
    /**
        Constructs a `Parser` that catches an error and returns `recovery` instead.
    
        - Parameter recovery: Result to be returned in case of an error.
    */
    public func otherwise(recovery: Result) -> Parser {
        return attempt(self).recover { _ in recovery }
    }
}

/**
    Constructs a `Parser` that will attempt to parse with `parser`, but will backtrack and return `nil` on failure

    - Parameter parser: The parser to run.
*/
public func optional<Token, Result>(parser: Parser<Token, Result>) -> Parser<Token, Result?> {
    return parser.map(Optional.Some).otherwise(nil)
}

/**
Constructs a `Parser` that will attempt to parse with `parser`, but will backtrack and return `nil` on failure

- Parameter parser: The parser to run.
*/
public func optional<Token, Result>(parser: Parser<Token, [Result]>) -> Parser<Token, [Result]> {
    return parser.otherwise([])
}

/**
    Constructs a `Parser` that will attempt to parse with `parser`, but will backtrack and return `otherwise` on failure

    - Parameter parser: The parser to run.
    - Parameter otherwise: The default value to return on failure.
*/
public func optional<Token, Result>(parser: Parser<Token, Result>, otherwise: Result) -> Parser<Token, Result> {
    return parser.otherwise(otherwise)
}