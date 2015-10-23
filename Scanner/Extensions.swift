//
//  Scannable.swift
//  Scanner
//
//  Created by Jaden Geller on 10/23/15.
//  Copyright © 2015 Jaden Geller. All rights reserved.
//

import Parsley

extension String: ScanInitializable {
    public static let scanner = many1(letter()).stringify()
}

extension Int: ScanInitializable {
    public static let scanner = appending(
            optional(within("+-").stringify(), otherwise: ""),
            many1(digit()).stringify()
        ).map { Int($0)! }
}

extension Double: ScanInitializable {
    public static let scanner = appending(
            optional(within("+-").stringify(), otherwise: ""),
            many1(digit()).stringify(),
            optional(appending(
                character(".").stringify(),
                many1(digit()).stringify()
            ), otherwise: "")
        ).map { Double($0)! }
}

extension Float: ScanInitializable {
    public static let scanner = Double.scanner.map(Float.init)
}