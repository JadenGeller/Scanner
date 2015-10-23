//
//  Base.swift
//  Scanner
//
//  Created by Jaden Geller on 10/23/15.
//  Copyright © 2015 Jaden Geller. All rights reserved.
//

import Parsley
import Foundation
import Spork

/**
    Scan the string and initialize the variables in the pattern.

    - Parameter pattern: The pattern to match.
*/
extension String {
    func scan(pattern: CompoundScanPattern) -> Bool {
        return pattern.match(ParseState(forkableGenerator: characters.generate()))
    }
}

/**
    Scan a string from the standard input and initialize the variables in the pattern.

    - Parameter pattern: The pattern to match.
*/
func scan(pattern: CompoundScanPattern) -> Bool {
    let stdin = NSFileHandle.fileHandleWithStandardInput()
    guard var inputString = NSString(data: stdin.availableData, encoding: NSUTF8StringEncoding) as String? else { return false }
    inputString.removeAtIndex(inputString.endIndex.predecessor()) // Remove new line character
    return inputString.scan(pattern)
}

public protocol ScanInitializable {
    static var scanner: Parser<Character, Self> { get }
}

/// A value that can be initialized by scanning.
public class Scannable<Value: ScanInitializable> {
    
    public required init() { }
    
    /**
    The scanned value.
    
    It is illegal to access this value unless it is used in a successful
    call to scan.
    */
    var value: Value!
    
    private func match(stream: ParseState<Character>) -> Bool {
        do {
            try self.value = Value.scanner.parse(stream)
            return true
        } catch {
            return false
        }
    }
}

public struct CompoundScanPattern: StringInterpolationConvertible, StringLiteralConvertible {
    private let matchers: [ParseState<Character> -> Bool]

    public init(stringLiteral value: String) {
        matchers = [{ stream in
            do {
                try string(value).parse(stream)
                return true
            } catch {
                return false
            }
            }]
    }
    
    public init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(stringLiteral: value)
    }
    
    private func match(stream: ParseState<Character>) -> Bool {
        for matcher in matchers {
            guard matcher(stream) else { return false }
        }
        do {
            try terminating(none()).parse(stream)
            return true
        } catch {
            return false
        }
    }
    
    public init(stringInterpolation strings: CompoundScanPattern...) {
        matchers = strings.map{ $0.matchers }.reduce([], combine: +)
    }
    
    public init<M: ScanInitializable>(stringInterpolationSegment expr: Scannable<M>) {
        matchers = [expr.match]
    }
    
    public init(stringInterpolationSegment expr: String) {
        self.init(stringLiteral: expr)
    }
    
    public init<T>(stringInterpolationSegment expr: T) {
        fatalError("CompoundScanPattern can only be constructed with `Match` type and `MatchVerifyable` types.")
    }
}

