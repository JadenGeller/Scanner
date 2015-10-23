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
    func parse(string: String) throws -> Result {
        return try parse(string.characters.generate())
    }
}

extension ParserType where Result == [Character] {
    
    /**
        Converts a parser that results in an array of characters into a parser that
        results in a String.
    */
    func stringify() -> Parser<Token, String> {
        return map(String.init)
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
    Constructs a `Parser` that matches a given string of text.

    - Parameter text: The string of text to match against.
*/
public func string(text: String) -> Parser<Character, [Character]> {
    return sequence(text.characters.map(token)).withError("string(\(text)")
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

