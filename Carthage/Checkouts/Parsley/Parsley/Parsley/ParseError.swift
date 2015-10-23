//
//  ParseError.swift
//  Parsley
//
//  Created by Jaden Geller on 10/14/15.
//  Copyright © 2015 Jaden Geller. All rights reserved.
//

public struct ParseError: ErrorType, CustomStringConvertible {
    let message: String
    
    public init(_ message: String) {
        self.message = message
    }
    
    public var description: String {
        return "Parse Error! Unable to parse \(message)."
    }
}

extension ParserType {
    
    /**
        Constructs a `Parser` that, on error, catches the error, maps transform onto its message, and rethrows the error.
    
        - Parameter transfomr: The transform to map onto the caught message.
    */
    public func mapError(transform: String -> String) -> Parser<Token, Result> {
        return Parser { state in
            do {
                return try self.parse(state)
            } catch let error as ParseError {
                throw ParseError(transform(error.message))
            }
        }
    }
    
    /**
        Constructs a `Parser` that, on error, discards the previously thrown error and throws instead
        a new error with the given message.

        - Parameter message: The message to include in the `ParseError`.
    */
    public func withError(message: String) -> Parser<Token, Result> {
        return mapError { _ in message }
    }
    
    /**
        Constructs a `Parser` that catches an error and transforms it into a successful result.
    
        - Parameter recovery: Function that transforms the error into a valid result.
    */
    public func recover(recovery: ParseError -> Result) -> Parser<Token, Result> {
        return Parser { state in
            do {
                return try self.parse(state)
            }
            catch let error as ParseError {
                return recovery(error)
            }
        }
    }
    
}

// MARK: Helpers

func wrapped(outer: String) -> String -> String {
    return { inner in outer + "(" + inner + ")" }
}
