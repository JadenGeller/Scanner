//
//  Tokenizer.swift
//  Parsley
//
//  Created by Jaden Geller on 10/13/15.
//  Copyright © 2015 Jaden Geller. All rights reserved.
//

//public func tokenize<Unit, Token>(patterns: [Parser<Unit, Token>], ignoring: [Parser<Unit, ()>]) -> Parser<Unit, [Token]> {
//    return terminating(many(either(coalesce(patterns), coalesce(ignoring)))).map { arr in
//        var jank = [Token]()
//        for x in arr {
//            if case let .Left(y) = x {
//                jank.append(y)
//            }
//        }
//        return jank
//    }
//}

//public func tokenize<Unit, Token>(patterns: (Parser<Unit, Token?>)...) -> Parser<Unit, [Token]> {
//    return tokenize(patterns)
//}