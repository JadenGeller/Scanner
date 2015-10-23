//
//  Text.swift
//  Parsley
//
//  Created by Jaden Geller on 10/14/15.
//  Copyright © 2015 Jaden Geller. All rights reserved.
//

extension ParserType where Token == Character {
    
    /**
        Parse a given `String` and return the result.
    
        - Parameter string: `String` to parse.
        - Returns: Result of parsing.
    */
    public func parse(string: String) throws -> Result {
        return try parse(string.characters.generate())
    }
}

extension ParserType where Result == [Character] {
    
    /**
        Converts a parser that results in an array of characters into a parser that
        results in a String.
    */
    public func stringify() -> Parser<Token, String> {
        return map(String.init)
    }
}

extension ParserType where Result == Character {
    
    /**
        Converts a parser that results in single characters into a parser that
        results in a String.
    */
    public func stringify() -> Parser<Token, String> {
        return map { String($0) }
    }
}

/**
    Construct a `Parser` that matches a given character.

    - Parameter character: The character to match against.
*/
public func character(character: Character) -> Parser<Character, Character> {
    return token(character).withError("character(\(character)")
}

/**
Constructs a `Parser` that consumes a single token and returns the token
if it is within the variadic list `tokens`.

- Parameter tokens: The variadic list that the input is tested against.
*/
public func anyCharacter(characters: Character...) -> Parser<Character, Character> {
    return within(characters)
}

/**
    Constructs a `Parser` that matches a given string of text.

    - Parameter text: The string of text to match against.
*/
public func string(text: String) -> Parser<Character, [Character]> {
    return sequenced(text.characters.map(token)).withError("string(\(text)")
}

/**
    Constructs a `Parser` that succeeds upon consuming a letter
    from the English alphabet.
*/
public func letter() -> Parser<Character, Character> {
    return within("A"..."z").withError("letter")
}

/**
    Constructs a `Parser` that succeeds upon consuming an
    Arabic numeral.
*/
public func digit() -> Parser<Character, Character> {
    return within("0"..."9").withError("digit")
}

/**
    Constructs a `Parser` that succeeds upon consuming whitespace character.
*/
public func whitespace() -> Parser<Character, Character> {
    return token(" ").withError("whitespace")
}

/**
    Constructs a `Parser` that consumes a single token and returns the token
    if it is within the string `string`.

    - Parameter sequence: The sequence that the input is tested against.
*/
public func within(string: String) -> Parser<Character, Character> {
    return within(string.characters)
}

/**
Constructs a `Parser` that will parse will each element of `parsers`, sequentially. Parsing only succeeds if every
parser succeeds, and the resulting parser returns an array of the results.

- Parameter parsers: The variadic list of parsers to sequentially run.
*/
public func appending<Token>(parsers: (Parser<Token, String>)...) -> Parser<Token, String> {
    return sequenced(parsers).map { $0.reduce("", combine: +) }
}


