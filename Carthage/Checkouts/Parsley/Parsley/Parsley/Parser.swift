//
//  Other.swift
//  Parsley
//
//  Created by Jaden Geller on 10/14/15.
//  Copyright © 2015 Jaden Geller. All rights reserved.
//

/**
    Represents a parser that takes in a seqeunce of type `Token` as input and returns
    a single instance of type `Result` as output.
*/
public struct Parser<Token, Result>: ParserType {
    typealias Implementation = ParseState<Token> throws -> Result
    
    internal let implementation: Implementation
    init(_ implementation: Implementation) {
        self.implementation = implementation
    }
    
    /**
        Runs the parser on the passed in `state`.
    
        - Parameter state: The state representing remaining input to be parsed.
    
        - Throws: `ParseError` if unable to parse.
        - Returns: The result of the parsing, `Result`.
    */
    public func parse(state: ParseState<Token>) throws -> Result {
        return try implementation(state)
    }
    
    /**
        Returns a `Parser` that, on successful parse, continues parsing with the parser resulting
        from mapping `transform` over its result value; returns the result of this new parser.
    
        Can be used to chain parsers together sequentially.
    
        - Parameter transform: The transform to map over the result.
    */
    public func flatMap<MappedResult>(transform: Result throws -> Parser<Token, MappedResult>) -> Parser<Token, MappedResult> {
        return Parser<Token, MappedResult> { state in
            return try transform(self.parse(state)).parse(state)
        }
    }
}

extension ParserType {
    /**
        Returns a `Parser` that, on successful parse, returns the result of mapping `transform`
        over its previous result value
    
        - Parameter transform: The transform to map over the result.
    */
    public func map<MappedResult>(transform: Result throws -> MappedResult) -> Parser<Token, MappedResult> {
        return flatMap { result in
            try pure(transform(result))
        }
    }
    
    /**
        Returns a `Parser` that, on successful parse, discards its previous result and returns `value` instead.
    
        - Parameter value: The value to return on successful parse.
    */
    public func replace<NewResult>(value: NewResult) -> Parser<Token, NewResult> {
        return map { _ in value }
    }
    
    /**
        Returns a `Parser` that, on successful parse, discards its result.
    */
    public func discard() -> Parser<Token, ()> {
        return replace(())
    }
    
    /**
        Returns a `Parser` that calls the callback `glimpse` before returning its result.
    
        - Parameter glimpse: Callback that recieves the parser's result as input.
    */
    public func peek(glimpse: Result throws -> ()) -> Parser<Token, Result> {
        return map { result in
            try glimpse(result)
            return result
        }
    }
    
    /**
        Returns a `Parser` that verifies that its result passes the condition before returning
        its result. If the result fails the condition, throws an error.
    
        - Parameter condition: The condition used to test the result.
    */
    public func requiring(condition: Result -> Bool) -> Parser<Token, Result> {
        return requiring("", condition)
    }
    
    public func requiring(description: String, _ condition: Result -> Bool) -> Parser<Token, Result> {
        return peek { result in
            if !condition(result) { throw ParseError("requiring(\(description))") }
        }
    }
}
