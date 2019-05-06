//
//  GameOfLifeTests.swift
//  GameOfLifeTests
//
//  Created by Adam Lovastyik on 04/05/2019.
//  Copyright © 2019 xelion.nl. All rights reserved.
//

import XCTest
@testable import GameOfLife

class GameOfLifeTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCoordinate() {
        
        let coordinate1 = Coordinate(column: 1, row: 2)
        XCTAssertEqual(coordinate1.column, 1)
        XCTAssertEqual(coordinate1.row, 2)
        
        let coordinate2 = Coordinate(column: -1, row: -2)
        XCTAssertEqual(coordinate2.column, -1)
        XCTAssertEqual(coordinate2.row, -2)
        
        let coordinate3 = Coordinate(column: 0, row: 0)
        XCTAssertEqual(coordinate3.column, 0)
        XCTAssertEqual(coordinate3.row, 0)
        
        let coordinate4 = Coordinate(column: 999999, row: -999999)
        XCTAssertEqual(coordinate4.column, 999999)
        XCTAssertEqual(coordinate4.row, -999999)
    }
    
    func testCellBoardInitializationAllFalse() {
        
        let board = CellBoard(columns: 2, rows: 2)
        
        XCTAssertFalse(board.cells[Coordinate(column: 0, row: 0)] ?? true)
        XCTAssertFalse(board.cells[Coordinate(column: 1, row: 0)] ?? true)
        XCTAssertFalse(board.cells[Coordinate(column: 0, row: 1)] ?? true)
        XCTAssertFalse(board.cells[Coordinate(column: 1, row: 1)] ?? true)
    }
    
    func testCellBoardInitializationSeed() {
        
        let board = CellBoard(columns: 2, rows: 2, aliveCellsSeed: [Coordinate(column: 0, row: 0), Coordinate(column: 0, row: 1), Coordinate(column: 1, row: 0), Coordinate(column: 1, row: 1)])
        
        XCTAssertTrue(board.cells[Coordinate(column: 0, row: 0)] ?? false)
        XCTAssertTrue(board.cells[Coordinate(column: 1, row: 0)] ?? false)
        XCTAssertTrue(board.cells[Coordinate(column: 0, row: 1)] ?? false)
        XCTAssertTrue(board.cells[Coordinate(column: 1, row: 1)] ?? false)
    }
    
    func testCellBoardReset() {
        
        var board = CellBoard(columns: 2, rows: 2, aliveCellsSeed: [Coordinate(column: 0, row: 0), Coordinate(column: 0, row: 1), Coordinate(column: 1, row: 0), Coordinate(column: 1, row: 1)])
        
        XCTAssertTrue(board.cells[Coordinate(column: 0, row: 0)] ?? false)
        XCTAssertTrue(board.cells[Coordinate(column: 1, row: 0)] ?? false)
        XCTAssertTrue(board.cells[Coordinate(column: 0, row: 1)] ?? false)
        XCTAssertTrue(board.cells[Coordinate(column: 1, row: 1)] ?? false)
        
        board.reset()
        
        XCTAssertFalse(board.cells[Coordinate(column: 0, row: 0)] ?? true)
        XCTAssertFalse(board.cells[Coordinate(column: 1, row: 0)] ?? true)
        XCTAssertFalse(board.cells[Coordinate(column: 0, row: 1)] ?? true)
        XCTAssertFalse(board.cells[Coordinate(column: 1, row: 1)] ?? true)
    }
    
    func testNeighborsListCenter() {
        
        let board = CellBoard(columns: 3, rows: 3)
        let neighbors = board.neighbous(of: Coordinate(column: 1, row: 1))
        XCTAssertNotNil(neighbors)
        XCTAssertEqual(neighbors.count, 8)
    }
    
    func testNeighborsListCornerTopLeft() {
        
        let board = CellBoard(columns: 3, rows: 3)
        let neighbors = board.neighbous(of: Coordinate(column: 0, row: 0))
        XCTAssertNotNil(neighbors)
        XCTAssertEqual(neighbors.count, 3)
    }
    
    func testNeighborsListCornerTopRight() {
        
        let board = CellBoard(columns: 3, rows: 3)
        let neighbors = board.neighbous(of: Coordinate(column: 2, row: 0))
        XCTAssertNotNil(neighbors)
        XCTAssertEqual(neighbors.count, 3)
    }
    
    func testNeighborsListCornerBottomLeft() {
        
        let board = CellBoard(columns: 3, rows: 3)
        let neighbors = board.neighbous(of: Coordinate(column: 0, row: 2))
        XCTAssertNotNil(neighbors)
        XCTAssertEqual(neighbors.count, 3)
    }
    
    func testNeighborsListCornerBottomRight() {
        
        let board = CellBoard(columns: 3, rows: 3)
        let neighbors = board.neighbous(of: Coordinate(column: 2, row: 2))
        XCTAssertNotNil(neighbors)
        XCTAssertEqual(neighbors.count, 3)
    }
    
    func testAliveNeighborsCount0() {
        
        let board = CellBoard(columns: 3, rows: 3)
        let neighbors = board.aliveNeigbors(of: Coordinate(column: 1, row: 1))
        XCTAssertEqual(neighbors, 0)
    }
    
    func testAliveNeighborsCount1() {
        
        let board = CellBoard(columns: 3, rows: 3, aliveCellsSeed: [Coordinate(column: 1, row: 0)])
        let neighbors = board.aliveNeigbors(of: Coordinate(column: 1, row: 1))
        XCTAssertEqual(neighbors, 1)
    }
    
    func testAliveCellsCount0() {
        
        let board = CellBoard(columns: 3, rows: 3)
        let alive = board.aliveCellCount
        XCTAssertEqual(alive, 0)
    }
    
    func testAliveCellsCount1() {
        
        let board = CellBoard(columns: 3, rows: 3, aliveCellsSeed: [Coordinate(column: 1, row: 0)])
        let alive = board.aliveCellCount
        XCTAssertEqual(alive, 1)
    }
    
    func testIterateAllDead() {
        
        let board0 = CellBoard(columns: 3, rows: 3)
        XCTAssertEqual(board0.aliveCellCount, 0)
        
        let board1 = CellBoard(iterate: board0)
        XCTAssertEqual(board1.aliveCellCount, 0)
    }
    
    func testIterateUnderPopulationWith0() {
        
        let board0 = CellBoard(columns: 3, rows: 3, aliveCellsSeed: [Coordinate(column: 1, row: 1)])
        XCTAssertEqual(board0.aliveCellCount, 1)
        
        let board1 = CellBoard(iterate: board0)
        XCTAssertEqual(board1.aliveCellCount, 0)
    }
    
    func testIterateUnderPopulationWith1() {
        
        let board0 = CellBoard(columns: 3, rows: 3, aliveCellsSeed: [Coordinate(column: 1, row: 0), Coordinate(column: 1, row: 1)])
        XCTAssertEqual(board0.aliveCellCount, 2)
        
        let board1 = CellBoard(iterate: board0)
        XCTAssertEqual(board1.aliveCellCount, 0)
    }
    
    func testIterateSurvivalWith2() {
        
        let board0 = CellBoard(columns: 3, rows: 3, aliveCellsSeed: [Coordinate(column: 1, row: 0), Coordinate(column: 1, row: 2), Coordinate(column: 1, row: 1)])
        XCTAssertEqual(board0.aliveCellCount, 3)
        
        let board1 = CellBoard(iterate: board0)
        XCTAssertTrue(board1.cells[Coordinate(column: 1, row: 1)] ?? false)
    }
    
    func testIterateSurvivalWith3() {
        
        let board0 = CellBoard(columns: 3, rows: 3, aliveCellsSeed: [Coordinate(column: 1, row: 0), Coordinate(column: 1, row: 2), Coordinate(column: 1, row: 1), Coordinate(column: 2, row: 0)])
        XCTAssertEqual(board0.aliveCellCount, 4)
        
        let board1 = CellBoard(iterate: board0)
        XCTAssertTrue(board1.cells[Coordinate(column: 1, row: 1)] ?? false)
    }
    
    func testOverPopulationWith4() {
        
        let board0 = CellBoard(columns: 3, rows: 3, aliveCellsSeed: [Coordinate(column: 1, row: 0), Coordinate(column: 1, row: 2), Coordinate(column: 1, row: 1), Coordinate(column: 2, row: 0), Coordinate(column: 0, row: 0)])
        XCTAssertEqual(board0.aliveCellCount, 5)
        
        let board1 = CellBoard(iterate: board0)
        XCTAssertFalse(board1.cells[Coordinate(column: 1, row: 1)] ?? true)
    }
}
