//
//  Backtracking.swift
//  Parsley
//
//  Created by Jaden Geller on 10/14/15.
//  Copyright © 2015 Jaden Geller. All rights reserved.
//

/**
    Constructs a `Parser` that runs attempts to run `parser` and backtracks on failure.
    On successful parse, this parser returns the result of `parse`; on failure, this parser
    catches the error, rewinds the `ParseState` back to the state before the parse, and
    rethrows the error.

    - Parameter attempt: The parser to run.
*/
public func attempt<Token, Result>(parser: Parser<Token, Result>) -> Parser<Token, Result> {
    return Parser { state in
        let snapshot = state.snapshot()
        do {
            return try parser.parse(state)
        }
        catch let error as ParseError {
            state.rewind(toSnapshot: snapshot)
            throw error
        }
    }
}

/**
    Constructs a `Parser` that runs `parser` without actually consuming any input.

    - Parameter parser: The parser to run.
*/
public func lookahead<Token, Result>(parser: Parser<Token, Result>) -> Parser<Token, Result> {
    return Parser { state in
        let snapshot = state.snapshot()
        defer { state.rewind(toSnapshot: snapshot) }
        return try parser.parse(state)
    }
}

/**
    Constructs a `Parser` that runs `condition` without consuming any input, running and returing the
    result of `parser` on success.

    - Parameter condition: The parser that must succeed to continue.
    - Parameter parser: The parser to run to determine the result.
*/
public func precondition<Token, Discard, Result>(condition: Parser<Token, Discard>, thenParse parser: Parser<Token, Result>) -> Parser<Token, Result> {
    return dropLeft(lookahead(condition), parser)
}

/**
    Constructs a `Parser` that will run `parser`; if `parser` succeeds, this parser will throw an error.
    If `parser` fails, this parser will succeed, consuming the input and returning nothing.

    - Parameter parser: The parser to run.
*/
public func not<Token, Result>(parser: Parser<Token, Result>) -> Parser<Token, ()> {
    return Parser { state in
        do {
            try parser.parse(state)
        } catch _ as ParseError {
            return ()
        }
        throw ParseError("not(\(parser))")
    }
}

/**
    Constructs a `Parser` that will run `parser` only if `condition` fails. Note that `condition` will not consume any input.

    - Parameter condition: The condition that we check to be false before parsing.
    - Parameter parser: The parser to run.
*/
public func unless<Token, Ignore, Result>(condition: Parser<Token, Ignore>, parse parser: Parser<Token, Result>) -> Parser<Token, Result> {
    return precondition(not(condition), thenParse: parser)
}

/**
    Constructs a `Parser` that will parse a single token only if `condition` fails. Note that `condition` will not consume any input.

    - Parameter condition: The condition that we check to be false before parsing.
*/
public func unless<Token, Ignore>(condition: Parser<Token, Ignore>) -> Parser<Token, Token> {
    return unless(condition, parse: any())
}


