//
//  SporkTests.swift
//  SporkTests
//
//  Created by Jaden Geller on 10/12/15.
//
//

import XCTest
@testable import Spork

class SporkTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAnonymousAnyForkableGenerator() {
        let generator = anyForkableGenerator(0, duplicate: { $0 }, next: { (inout x: Int) in x++ })
        let forkedGenerator = generator.fork()
        XCTAssertEqual(0, forkedGenerator.next())
        XCTAssertEqual([1,2,3], Array(anyGenerator(forkedGenerator).prefix(3)))
        XCTAssertEqual([0,1,2], Array(anyGenerator(generator).prefix(3)))
    }
    
    func testBufferingGeneratorIndependentState() {
        let sharedStateGenerator = anyGenerator((0...100).generate())
        let generator = BufferingGenerator(bridgedFromGenerator: sharedStateGenerator)
        XCTAssertEqual(0, generator.next())
        let fork = generator.fork()
        XCTAssertEqual(1, generator.next())
        XCTAssertEqual(1, fork.next())
    }
    
    func testBufferingGeneratorTrimState() {
        let sharedStateGenerator = anyGenerator(EmptyGenerator<()>().generate())
        let generator = BufferingGenerator(bridgedFromGenerator: sharedStateGenerator)
        XCTAssertEqual(0, generator.state.buffer.count)
        generator.peek()
        XCTAssertEqual(1, generator.state.buffer.count)
        generator.next()
        XCTAssertEqual(0, generator.state.buffer.count)
    }
    
    func testValueCopyGenerator() {
        let sharedStateGenerator = anyGenerator([0,1].generate())
        let bufferingGenerator = BufferingGenerator(bridgedFromGenerator: sharedStateGenerator)
        var generator = ValueCopyGenerator(bufferingGenerator)
        XCTAssertEqual(0, generator.next())
        var copy = generator
        XCTAssertEqual(1, generator.next())
        XCTAssertEqual(1, copy.next())
    }
    
}
