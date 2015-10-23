//
//  SchemeTest.swift
//  Parsley
//
//  Created by Jaden Geller on 10/14/15.
//  Copyright © 2015 Jaden Geller. All rights reserved.
//

import Foundation

import XCTest
import Parsley

enum SchemeToken: Equatable, CustomStringConvertible {
    case BareWord(String)
    case IntegerLiteral(String)
    case FloatingPointLiteral(String)
    case StringLiteral(String)
    case Symbol(Character)
    
    var description: String {
        switch self {
        case .BareWord(let word): return word
        case .IntegerLiteral(let value): return Int(value)!.description
        case .FloatingPointLiteral(let value): return Float(value)!.description
        case .StringLiteral(let value): return "\"" + value + "\""
        case .Symbol(let value): return String(value)
        }
    }
}

enum Expression: CustomStringConvertible {
    indirect case SExpression([Expression])
    case Token(SchemeToken)
    
    var description: String {
        switch self {
        case .SExpression(let expressions): return expressions.description
        case .Token(let token): return token.description
        }
    }
}

func ==(lhs: SchemeToken, rhs: SchemeToken) -> Bool {
    switch (lhs, rhs) {
    case let (.BareWord(lhs), .BareWord(rhs)): return lhs == rhs
    case let (.IntegerLiteral(lhs), .IntegerLiteral(rhs)): return lhs == rhs
    case let (.FloatingPointLiteral(lhs), .FloatingPointLiteral(rhs)): return lhs == rhs
    case let (.StringLiteral(lhs), .StringLiteral(rhs)): return lhs == rhs
    case let (.Symbol(lhs), .Symbol(rhs)): return lhs == rhs
    default: return false
    }
}

class SchemeTest: XCTestCase {
    
    func testScheme() {
        let whitespace = many1(anyCharacter(" ", "\n")).withError("whitespace").stringify()
        
        let bareWord = appending(
            letter().stringify(),
            many1(coalesce(
                letter(),
                digit()
            )).stringify()
        ).withError("bare word")
        
        let integerLiteral = appending(
            within("+-").stringify().otherwise(""),
            many1(digit()).stringify()
        ).withError("integer literal")
        
        let floatingPointLiteral = appending(
            integerLiteral,
            character(".").stringify(),
            many(digit()).stringify()
        ).withError("floating point literal")
        
        let stringLiteral = between(character("\""), character("\""), parse: until(character("\""))).stringify().withError("string literal")
        
        let symbol = within("()+-*/").withError("symbol")
        
        let comment = recurive { parser in
            between(string("/*"), string("*/"), parse: appending(
                until(coalesce(string("/*"), string("*/"))).stringify(),
                appending(
                    parser,
                    until(coalesce(string("/*"), string("*/"))).stringify()
                ).otherwise("")
        ))
        }.withError("comment")
        
        let tokens = terminating(manyDelimited(coalesce(
            bareWord.map(SchemeToken.BareWord),
            stringLiteral.map(SchemeToken.StringLiteral),
            floatingPointLiteral.map(SchemeToken.FloatingPointLiteral),
            integerLiteral.map(SchemeToken.IntegerLiteral),
            symbol.map(SchemeToken.Symbol)
        ), delimiter: many(coalesce(whitespace, comment))))
        
        do {
            let result = try tokens.parse("((hello (+5 * -3  /* this is a /* nested */ comment */ ) 5.0   \"world\" -43.56  )4  whoa)")
            XCTAssertEqual(15, result.count)
            
            let sExpression = recurive { (parser: Parser<SchemeToken, Expression>) in
                coalesce(
                    between(token(SchemeToken.Symbol("(")), token(SchemeToken.Symbol(")")), parse: many(parser)).map(Expression.SExpression),
                    unless(token(SchemeToken.Symbol(")"))).map(Expression.Token)
                )
            }
            
            if case let .SExpression(arr) = try sExpression.parse(result) {
                print(arr)
                XCTAssertEqual(3, arr.count)
            } else {
                XCTFail()
            }
            
        } catch let error {
            XCTFail(String(error))
        }
    }
}

