//
//  Repeating.swift
//  Parsley
//
//  Created by Jaden Geller on 10/14/15.
//  Copyright © 2015 Jaden Geller. All rights reserved.
//

/**
    Constructs a `Parser` that will run `parser` 0 or more times, as many times as possible,
    and will result in an array of the results from each invocation.

    - Parameter parser: The parser to run repeatedly.
*/
public func many<Token, Result>(parser: Parser<Token, Result>) -> Parser<Token, [Result]> {
    return Parser { state in
        var results = [Result]()
        while let result = try? attempt(parser).parse(state) {
            results.append(result)
        }
        return results
    }.mapError(wrapped("many"))
}

/**
    Constructs a `Parser` that will run `parser` 1 or more time, as many times as possible,
    and will result in an array of the results from each invocation.

    - Parameter parser: The parser to run repeatedly.
*/
public func many1<Token, Result>(parser: Parser<Token, Result>) -> Parser<Token, [Result]> {
    return many(parser).requiring("isEmpty"){ !$0.isEmpty }
}

/**
    Constructs a `Parser` that will run `parser` 0 or more times, as many times as possible,
    each subsequent time seperated by a delimiter, and will result in an array of the results
    from each invocation.

    - Parameter parser: The parser to run repeatedly.
    - Parameter delimiter: The parser that matches the required delimiter.
*/
public func manyDelimited<Token, Ignore, Result>(parser: Parser<Token, Result>, delimiter: Parser<Token, Ignore>) -> Parser<Token, [Result]> {
    return sequence(parser, many(dropLeft(delimiter, parser))).map{ lhs, rhs in [lhs] + rhs }.otherwise([])
}

/**
    Constructs a `Parser` that will run `parser` 1 or more time, as many times as possible,
    each subsequent time seperated by a delimiter, and will result in an array of the results
    from each invocation.

    - Parameter parser: The parser to run repeatedly.
    - Parameter delimiter: The parser that matches the required delimiter.
*/
public func many1Delimited<Token, Ignore, Result>(parser: Parser<Token, Result>, delimiter: Parser<Token, Ignore>) -> Parser<Token, [Result]> {
    return manyDelimited(parser, delimiter: delimiter).requiring("isEmpty") { !$0.isEmpty }
}

/**
    Constructs a `Parser` that will repeatedly run `condition` without consuming any input. Each time
    `condition` fails, `parse` will be run. Once `condition` succeeds, an array of the results from
    previous invocations of `parse` will be returned.

    It is important to note that this does not guarentee that a token sequence matched by `condition`
    will not pass through. In fact, `until` will only prevent the passage of such a token sequence
    if it lies on a "parse-boundary", that is, if it never occurs anywhere other than the beginning
    of the input `parse` will run on.

- Parameter condition: The parser that will consume no input and will be used to determine when to stop running `parse`.
- Parameter parser: The parser that is run over and over to determine the result.
*/
public func until<Token, Discard, Result>(condition: Parser<Token, Discard>, parse parser: Parser<Token, Result>) -> Parser<Token, [Result]> {
    return many(unless(condition, parse: parser))
}

/**
    Constructs a `Parser` that will repeatedly run `condition` without consuming any input. Each time
    `condition` fails, a single token will be parsed. Once `condition` succeeds, an array of parsed tokens
    will be returned.

    - Parameter condition: The parser that will consume no input and will be used to determine when to stop parsing.
*/
public func until<Token, Discard>(condition: Parser<Token, Discard>) -> Parser<Token, [Token]> {
    return many(precondition(not(condition), thenParse: any()))
}

/**
    Constructs a `Parser` that will repeatedly run `condition` without consuming any input. Each time
    `condition` fails, `parse` will be run. Once `condition` succeeds, an array of the results from
    previous invocations of `parse` with the final invocation of `condition` appended will be returned.

    It is important to note that this does not guarentee that a token sequence matched by `condition`
    will not pass through. In fact, `until` will only prevent the passage of such a token sequence
    if it lies on a "parse-boundary", that is, if it never occurs anywhere other than the beginning
    of the input `parse` will run on.

    - Parameter condition: The parser that will consume no input and will be used to determine when to stop running `parse`.
    - Parameter parser: The parser that is run over and over to determine the result.
*/
public func through<Token, Result>(condition: Parser<Token, Result>, parse parser: Parser<Token, Result>) -> Parser<Token, [Result]> {
    return sequence(until(condition, parse: parser), condition).map { most, last in most + [last] }
}

/**
    Constructs a `Parser` that will repeatedly run `condition` without consuming any input. Each time
    `condition` fails, `parse` will be run. Once `condition` succeeds, an array of the results from
    previous invocations of `parse` and the final invocation of `condition` will be returned.

    It is important to note that this does not guarentee that a token sequence matched by `condition`
    will not pass through. In fact, `until` will only prevent the passage of such a token sequence
    if it lies on a "parse-boundary", that is, if it never occurs anywhere other than the beginning
    of the input `parse` will run on.

    - Parameter condition: The parser that will consume no input and will be used to determine when to stop running `parse`.
    - Parameter parser: The parser that is run over and over to determine the result.
*/
public func through<Token, Result>(condition: Parser<Token, [Result]>, parse parser: Parser<Token, Result>) -> Parser<Token, [Result]> {
    return through(condition, parse: parser.map { [$0] })
}

/**
    Constructs a `Parser` that will repeatedly run `condition` without consuming any input. Each time
    `condition` fails, `parse` will be run. Once `condition` succeeds, an array of the results from
    previous invocations of `parse` with the final invocation of `condition` appended will be returned.

    It is important to note that this does not guarentee that a token sequence matched by `condition`
    will not pass through. In fact, `until` will only prevent the passage of such a token sequence
    if it lies on a "parse-boundary", that is, if it never occurs anywhere other than the beginning
    of the input `parse` will run on.

    - Parameter condition: The parser that will consume no input and will be used to determine when to stop running `parse`.
    - Parameter parser: The parser that is run over and over to determine the result.
*/
public func through<Token, Result>(condition: Parser<Token, Result>, parse parser: Parser<Token, [Result]>) -> Parser<Token, [Result]> {
    return through(condition.map { [$0] }, parse: parser)
}

/**
    Constructs a `Parser` that will repeatedly run `condition` without consuming any input. Each time
    `condition` fails, `parse` will be run. Once `condition` succeeds, an array of the results from
    previous invocations of `parse` with the final invocation of `condition` appended will be returned.

    It is important to note that this does not guarentee that a token sequence matched by `condition`
    will not pass through. In fact, `until` will only prevent the passage of such a token sequence
    if it lies on a "parse-boundary", that is, if it never occurs anywhere other than the beginning
    of the input `parse` will run on.

    - Parameter condition: The parser that will consume no input and will be used to determine when to stop running `parse`.
    - Parameter parser: The parser that is run over and over to determine the result.
*/
public func through<Token, Result>(condition: Parser<Token, [Result]>, parse parser: Parser<Token, [Result]>) -> Parser<Token, [Result]> {
    return through(condition.map { [$0] }, parse: condition.map { [$0] }).map { Array($0.flatten()) }
}

/**
    Constructs a `Parser` that will repeatedly run `condition` without consuming any input. Each time
    `condition` fails, a single token will be parsed. Once `condition` succeeds, an array of parsed token
    with the final invocation of `condition` appended will be returned.

    - Parameter condition: The parser that will consume no input and will be used to determine when to stop parsing.
*/
public func through<Token>(condition: Parser<Token, Token>) -> Parser<Token, [Token]> {
    return through(condition, parse: any())
}

/**
    Constructs a `Parser` that will repeatedly run `condition` without consuming any input. Each time
    `condition` fails, a single token will be parsed. Once `condition` succeeds, an array of parsed token
    and the final invocation of `condition` will be returned.

    - Parameter condition: The parser that will consume no input and will be used to determine when to stop parsing.
*/
public func through<Token>(condition: Parser<Token, [Token]>) -> Parser<Token, [Token]> {
    return through(condition, parse: any())
}

