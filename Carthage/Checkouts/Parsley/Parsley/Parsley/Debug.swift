//
//  Debug.swift
//  Parsley
//
//  Created by Jaden Geller on 10/19/15.
//  Copyright © 2015 Jaden Geller. All rights reserved.
//

extension ParserType {
    public func printAttempt(message: String? = nil) -> Parser<Token, Result> {
        return Parser { state in
            var output = "attempt"
            if let message = message { output += "(" + message + ")" }
            print(output)
            return try self.parse(state)
        }
    }
    
    public func printSuccess(message: String? = nil) -> Parser<Token, Result> {
        return peek { result in
            var output = "success"
            if let message = message { output += "(" + message + ")" }
            output += " = \(result)"
            print(output)
        }
    }
    
    public func printFailure(message: String? = nil) -> Parser<Token, Result> {
        return Parser { state in
            do {
                return try self.parse(state)
            }
            catch let error {
                var output = "failure"
                if let message = message { output += "(" + message + ")" }
                output += " = \(error)"
                print(output)
                throw error
            }
        }
    }
    
    public func printNext(message: String? = nil) -> Parser<Token, Result> {
        return Parser { state in
            let saved = state.snapshot()
            var output = "next"
            if let message = message { output += "(" + message + ")" }
            output += " = \(state.next())"
            print(output)
            state.rewind(toSnapshot: saved)
            return try self.parse(state)
        }
    }

    public func printAll(message: String? = nil) -> Parser<Token, Result> {
        return printNext(message).printAttempt(message).printSuccess(message).printFailure(message)
    }
}
