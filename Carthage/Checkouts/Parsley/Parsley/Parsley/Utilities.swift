//
//  Utilities.swift
//  Parsley
//
//  Created by Jaden Geller on 10/14/15.
//  Copyright © 2015 Jaden Geller. All rights reserved.
//

/**
    Constructs a `Parser` that will run `leftParser` followed by `rightParser`, discarding the result from
    `rightParser` and returning the result from `leftParser`.

    - Parameter leftParser: The parser whose result will be propagated.
    - Parameter rightParser: The parser whose result will be discarded.
*/
public func dropRight<Token, LeftResult, RightResult>(leftParser: Parser<Token, LeftResult>, _ rightParser: Parser<Token, RightResult>) -> Parser<Token, LeftResult> {
    return sequence(leftParser, rightParser).map { left, _ in left }
}

/**
    Constructs a `Parser` that will run `leftParser` followed by `rightParser`, discarding the result from
    `leftParser` and returning the result from `rightParser`.

    - Parameter leftParser: The parser whose result will be discarded.
    - Parameter rightParser: The parser whose result will be propagated.
*/
public func dropLeft<Token, LeftResult, RightResult>(leftParser: Parser<Token, LeftResult>, _ rightParser: Parser<Token, RightResult>) -> Parser<Token, RightResult> {
    return sequence(leftParser, rightParser).map { _, right in right }
}

/**
    Constructs a `Parser` that will run `left` followed by `parser` followed by `right`,
    discarding the result from `left` and `right` and returning the result from `parser`.

    - Parameter left: The first parser whose result will be discarded.
    - Parameter right: The second parser whose result will be discarded.
    - Parameter parser: The parser that will be run between the other two parsers.
*/
public func between<Token, LeftIgnore, RightIgnore, Result>(left: Parser<Token, LeftIgnore>, _ right: Parser<Token, RightIgnore>, parse parser: Parser<Token, Result>) -> Parser<Token, Result> {
    return sequence(left, parser, right).map { _, result, _ in result }
}

/**
    Constructs a `Parser` that will run `parser` and ensure that no input remains upon `parser`'s completion.
    If any input does remain, an error is thrown.

    - Parameter parser: The parser to be run.
*/
public func terminating<Token, Result>(parser: Parser<Token, Result>) -> Parser<Token, Result> {
    return dropRight(parser, end())
}



