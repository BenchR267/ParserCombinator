//
//  Lexical_TestCase.swift
//  ParselTests
//
//  Created by Benjamin Herzog on 21.08.17.
//

import XCTest
import Parsel

class Lexical_TestCase: XCTestCase {
    
    func test_char() throws {
        let p = L.char
        
        let res1 = p.parse("ab")
        XCTAssertEqual(try res1.unwrap(), "a")
        XCTAssertEqual(try res1.rest(), "b")
        
        let res2 = p.parse("")
        guard case let .unexpectedToken(expected, got) = try res2.error() as! L.Error else {
            return XCTFail()
        }
        XCTAssertEqual(expected, "char")
        XCTAssertEqual(got, "")
    }
    
    func test_string() throws {
        let p = L.string("abc")
        
        let res1 = p.parse("abcde")
        XCTAssertEqual(try res1.unwrap(), "abc")
        XCTAssertEqual(try res1.rest(), "de")
        
        let res2 = p.parse("edcba")
        guard case let .unexpectedToken(expected, got) = try res2.error() as! L.Error else {
            return XCTFail()
        }
        XCTAssertEqual(expected, "abc")
        XCTAssertEqual(got, "edc")
    }
    
    func test_digit() throws {
        let p = L.digit
        
        let res1 = p.parse("1a")
        XCTAssertEqual(try res1.unwrap(), 1)
        XCTAssertEqual(try res1.rest(), "a")
        
        let res2 = p.parse("a1")
        guard case let .unexpectedToken(expected, got) = try res2.error() as! L.Error else {
            return XCTFail()
        }
        XCTAssertEqual(expected, "digit")
        XCTAssertEqual(got, "a")
    }
    
    func test_binaryDigit() throws {
        let p = L.binaryDigit
        
        let res1 = p.parse("11a")
        XCTAssertEqual(try res1.unwrap(), 1)
        XCTAssertEqual(try res1.rest(), "1a")
        
        let res2 = p.parse("2")
        guard case let .unexpectedToken(expected, got) = try res2.error() as! L.Error else {
            return XCTFail()
        }
        XCTAssertEqual(expected, "0 or 1")
        XCTAssertEqual(got, "2")
    }
    
    func test_binaryNumber() throws {
        let p = L.binaryNumber
        
        let res1 = p.parse("0b10110110a")
        XCTAssertEqual(try res1.unwrap(), 182)
        XCTAssertEqual(try res1.rest(), "a")
        
        let res2 = p.parse("0xAF3410")
        guard case let .unexpectedToken(expected, got) = try res2.error() as! L.Error else {
            return XCTFail()
        }
        XCTAssertEqual(expected, "0b")
        XCTAssertEqual(got, "0x")
        
        let res3 = p.parse("0b2")
        guard case let .unexpectedToken(expected2, got2) = try res3.error() as! L.Error else {
            return XCTFail()
        }
        XCTAssertEqual(expected2, "0 or 1")
        XCTAssertEqual(got2, "2")
    }
    
    func test_octalDigit() throws {
        let p = L.octalDigit
        
        let res1 = p.parse("77a")
        XCTAssertEqual(try res1.unwrap(), 7)
        XCTAssertEqual(try res1.rest(), "7a")
        
        let res2 = p.parse("8")
        guard case let .unexpectedToken(expected, got) = try res2.error() as! L.Error else {
            return XCTFail()
        }
        XCTAssertEqual(expected, "0 to 7")
        XCTAssertEqual(got, "8")
    }
    
    func test_octalNumber() throws {
        let p = L.octalNumber
        
        let res1 = p.parse("0o12372106a")
        XCTAssertEqual(try res1.unwrap(), 2749510)
        XCTAssertEqual(try res1.rest(), "a")
        
        let res2 = p.parse("0xAF3410")
        guard case let .unexpectedToken(expected, got) = try res2.error() as! L.Error else {
            return XCTFail()
        }
        XCTAssertEqual(expected, "0o")
        XCTAssertEqual(got, "0x")
        
        let res3 = p.parse("0o8")
        guard case let .unexpectedToken(expected2, got2) = try res3.error() as! L.Error else {
            return XCTFail()
        }
        XCTAssertEqual(expected2, "0 to 7")
        XCTAssertEqual(got2, "8")
    }
    
    func test_hexadecimalDigit() throws {
        let p = L.hexadecimalDigit
        
        let res1 = p.parse("a7a")
        XCTAssertEqual(try res1.unwrap(), 10)
        XCTAssertEqual(try res1.rest(), "7a")
        
        let res2 = p.parse("A7A")
        XCTAssertEqual(try res2.unwrap(), 10)
        XCTAssertEqual(try res2.rest(), "7A")
        
        let res3 = p.parse("F7F")
        XCTAssertEqual(try res3.unwrap(), 15)
        XCTAssertEqual(try res3.rest(), "7F")
        
        let res4 = p.parse("f7f")
        XCTAssertEqual(try res4.unwrap(), 15)
        XCTAssertEqual(try res4.rest(), "7f")
        
        let res5 = p.parse("g")
        guard case let .unexpectedToken(expected, got) = try res5.error() as! L.Error else {
            return XCTFail()
        }
        XCTAssertEqual(expected, "0 to 15")
        XCTAssertEqual(got, "16")
        
        let res6 = p.parse(",")
        guard case let .unexpectedToken(expected2, got2) = try res6.error() as! L.Error else {
            return XCTFail()
        }
        XCTAssertEqual(expected2, "0 to 15")
        XCTAssertEqual(got2, "-1")
        
        let res7 = p.parse("")
        guard case let .unexpectedToken(expected3, got3) = try res7.error() as! L.Error else {
            return XCTFail()
        }
        XCTAssertEqual(expected3, "char")
        XCTAssertEqual(got3, "")
    }
    
    func test_hexadecimalNumber() throws {
        let p = L.hexadecimalNumber
        
        let res1 = p.parse("0xdeadbeafg")
        XCTAssertEqual(try res1.unwrap(), 3735928495)
        XCTAssertEqual(try res1.rest(), "g")
        
        let res2 = p.parse("0xDEADBEAFG")
        XCTAssertEqual(try res2.unwrap(), 3735928495)
        XCTAssertEqual(try res2.rest(), "G")
        
        let res3 = p.parse("0bAF3410")
        guard case let .unexpectedToken(expected, got) = try res3.error() as! L.Error else {
            return XCTFail()
        }
        XCTAssertEqual(expected, "0x")
        XCTAssertEqual(got, "0b")
        
        let res4 = p.parse("0xg")
        guard case let .unexpectedToken(expected2, got2) = try res4.error() as! L.Error else {
            return XCTFail()
        }
        XCTAssertEqual(expected2, "0 to 15")
        XCTAssertEqual(got2, "16")
    }
    
}

#if os(Linux)
    extension Lexical_TestCase {
        static var allTests = [
            ("test_char", test_char),
            ("test_string", test_string),
            ("test_digit", test_digit),
            ("test_binaryDigit", test_binaryDigit),
            ("test_binaryNumber", test_binaryNumber),
            ("test_octalDigit", test_octalDigit),
            ("test_octalNumber", test_octalNumber),
            ("test_hexadecimalDigit", test_hexadecimalDigit),
            ("test_hexadecimalNumber", test_hexadecimalNumber),
        ]
    }
#endif
