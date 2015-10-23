//
//  Base.swift
//  Parsley
//
//  Created by Jaden Geller on 10/14/15.
//  Copyright © 2015 Jaden Geller. All rights reserved.
//

/**
    Constructs a `Parser` that consumes no input and returns `value`.

    - Parameter value: The value to return on parse.
*/
public func pure<Token, Result>(value: Result) -> Parser<Token, Result> {
    return Parser { _ in
        return value
    }
}

/**
    Constructs a `Parser` that consumes no input and returns nothing.
*/
public func none<Token>() -> Parser<Token, ()> {
    return pure(())
}

/**
    Constructs a `Parser` that consumes a single token and returns it.
*/
public func any<Token>() -> Parser<Token, Token> {
    return Parser { state in
        guard let token = state.next() else { throw ParseError("any") }
        return token
    }
}

/**
    Constructs a `Parser` that succeeds if the input is empty. This parser
    consumes no input and returns nothing.
*/
public func end<Token>() -> Parser<Token, ()> {
    return Parser { state in
        guard state.next() == nil else { throw ParseError("end") }
        return ()
    }
}

/**
    Constructs a `Parser` that consumes a single token and returns the token
    if it satisfies `condition`; otherwise, it throws a `ParseError`.

    - Parameter condition: The condition that the token must satisfy.
*/
public func satisfy<Token>(condition: Token -> Bool) -> Parser<Token, Token> {
    return satisfy("", condition)
}

public func satisfy<Token>(description: String, _ condition: Token -> Bool) -> Parser<Token, Token> {
    return any().requiring(description, condition).mapError(wrapped("satisfy"))
}

/**
    Constructs a `Parser` that consumes a single token and returns the token
    if it is equal to the argument `token`.

    - Parameter token: The token that the input is tested against.
*/
public func token<Token: Equatable>(token: Token) -> Parser<Token, Token> {
    return satisfy{ $0 == token }.withError("token(\(token))")
}

/**
    Constructs a `Parser` that consumes a single token and returns the token
    if it is within the interval `interval`.

    - Parameter interval: The interval that the input is tested against.
*/
public func within<I: IntervalType>(interval: I) -> Parser<I.Bound, I.Bound> {
    return satisfy(interval.contains).withError("within(\(interval))")
}

/**
    Constructs a `Parser` that consumes a single token and returns the token
    if it is within the sequence `sequence`.

    - Parameter sequence: The sequence that the input is tested against.
*/
public func within<S: SequenceType where S.Generator.Element: Equatable>(sequence: S) -> Parser<S.Generator.Element, S.Generator.Element> {
    return satisfy(sequence.contains).withError("within(\(sequence)")
}

///**
//    Constructs a `Parser` that consumes a single token and returns the token
//    if it is within the variadic list `tokens`.
//
//    - Parameter tokens: The variadic list that the input is tested against.
//*/
//public func anyOf<Token: Equatable>(tokens: Token...) -> Parser<Token, Token> {
//    return within(tokens)
//}
