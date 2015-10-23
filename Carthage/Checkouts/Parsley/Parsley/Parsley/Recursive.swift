//
//  Recursive.swift
//  Parsley
//
//  Created by Jaden Geller on 10/14/15.
//  Copyright © 2015 Jaden Geller. All rights reserved.
//

/**
    Constructs a `Parser` that is able to recurse on itself.

    - Parameter recurse: A function that receives its `Parser` return value as an argument.
*/
public func recurive<Token, Result>(recurse: Parser<Token, Result> -> Parser<Token, Result>) -> Parser<Token, Result> {
    return Parser { state in
        try fixedPoint{ recurse(Parser($0)).implementation }(state)
    }
}

// MARK: Helpers

/**
    A function that enables anonymous functions to recurse on themselves.

    - Parameter recurse: A function that recieves itself as an argument.
*/
private func fixedPoint<T, V>(recurse: (T throws -> V) -> (T throws -> V)) -> T throws -> V {
    return { try recurse(fixedPoint(recurse))($0) }
}
