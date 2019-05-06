//
//  GameTests.swift
//  GameOfLifeTests
//
//  Created by Adam Lovastyik on 06/05/2019.
//  Copyright © 2019 xelion.nl. All rights reserved.
//

import XCTest

class GameTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEmptyInit() {
        
        let game = Game(columns: 2, rows: 2)
        
        XCTAssertNotNil(game)
        XCTAssertNotNil(game.iterations)
        XCTAssertEqual(game.iterations.count, 1)
        XCTAssertEqual(game.iterations.first?.cells.count, 4)
        XCTAssertEqual(game.iterations.first?.aliveCellCount, 0)
        XCTAssertTrue(game.isFinished)
    }

    func testEmptyInitWithBoard() {
        
        let board = CellBoard(columns: 2, rows: 2, aliveCellsSeed: [Coordinate(column: 0, row: 0), Coordinate(column: 1, row: 1)])
        let game = Game(board: board)
        
        XCTAssertNotNil(game)
        XCTAssertNotNil(game.iterations)
        XCTAssertEqual(game.iterations.count, 1)
        XCTAssertEqual(game.iterations.first?.cells.count, 4)
        XCTAssertEqual(game.iterations.first?.aliveCellCount, 2)
    }
    
    func testFirstIterationPositive() {
        
        let board = CellBoard(columns: 4, rows: 4, aliveCellsSeed: [Coordinate(column: 2, row: 0), Coordinate(column: 0, row: 2), Coordinate(column: 1, row: 2), Coordinate(column: 1, row: 3), Coordinate(column: 3, row: 3)])
        var game = Game(board: board)
        
        XCTAssertNotNil(game)
        XCTAssertNotNil(game.iterations)
        XCTAssertEqual(game.iterations.count, 1)
        XCTAssertEqual(game.iterations.first?.cells.count, 16)
        XCTAssertEqual(game.iterations.first?.aliveCellCount, 5)
        XCTAssertTrue(game.iterations.first?.cells[Coordinate(column: 2, row: 0)] ?? false)
        XCTAssertTrue(game.iterations.first?.cells[Coordinate(column: 0, row: 2)] ?? false)
        XCTAssertTrue(game.iterations.first?.cells[Coordinate(column: 1, row: 2)] ?? false)
        XCTAssertTrue(game.iterations.first?.cells[Coordinate(column: 1, row: 3)] ?? false)
        XCTAssertTrue(game.iterations.first?.cells[Coordinate(column: 3, row: 3)] ?? false)
        
        let result = game.iterate()
        XCTAssertTrue(result)
        XCTAssertEqual(game.iterations.count, 2)
        if game.iterations.count > 1 {
            let board = game.iterations[1]
            XCTAssertEqual(board.aliveCellCount, 7)
            XCTAssertTrue(board.cells[Coordinate(column: 1, row: 1)] ?? false)
            XCTAssertTrue(board.cells[Coordinate(column: 0, row: 2)] ?? false)
            XCTAssertTrue(board.cells[Coordinate(column: 1, row: 2)] ?? false)
            XCTAssertTrue(board.cells[Coordinate(column: 2, row: 2)] ?? false)
            XCTAssertTrue(board.cells[Coordinate(column: 0, row: 3)] ?? false)
            XCTAssertTrue(board.cells[Coordinate(column: 1, row: 3)] ?? false)
            XCTAssertTrue(board.cells[Coordinate(column: 2, row: 3)] ?? false)
        }
        
        XCTAssertFalse(game.isFinished)
    }
}
