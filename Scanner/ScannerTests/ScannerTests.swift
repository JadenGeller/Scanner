//
//  ScannerTests.swift
//  ScannerTests
//
//  Created by Jaden Geller on 10/23/15.
//  Copyright © 2015 Jaden Geller. All rights reserved.
//

import XCTest
@testable import Scanner

class ScannerTests: XCTestCase {
    
    func testStringScan() {
        let input = "Hello"
        
        guard input.scan("Hello") else { return XCTFail() }
    }
    
    func testStringValue() {
        let input = "Hello"
        
        let word = Scannable<String>()
        
        guard input.scan("\(word)") else { return XCTFail() }
        
        XCTAssertEqual("Hello", word.value)
    }
    
    func testSimpleScan() {
        let input = "Hello world!"
        
        let place = Scannable<String>()
        
        guard input.scan("Hello \(place)!") else { return XCTFail() }
        
        XCTAssertEqual("world", place.value)
    }
    
    func testAdvancedScan() {
        let input = "There are 5 apples in the bowl."
        
        let count  = Scannable<Int>()
        let object = Scannable<String>()
        let place  = Scannable<String>()
        
        guard input.scan("There are \(count) \(object) in the \(place).") else { return XCTFail() }
        
        XCTAssertEqual(5,        count.value)
        XCTAssertEqual("apples", object.value)
        XCTAssertEqual("bowl",   place.value)
    }
}
