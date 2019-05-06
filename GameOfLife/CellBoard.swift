//
//  CellBoard.swift
//  GameOfLife
//
//  Created by Adam Lovastyik on 04/05/2019.
//  Copyright © 2019 xelion.nl. All rights reserved.
//

import Foundation

struct Coordinate: Hashable {
    let column: Int
    let row: Int
}

enum IterationEvent {
    case dead
    case deathByUnderpopulation(aliveNeighborsCount: Int)
    case survivial(aliveNeighborsCount: Int)
    case deathByOverpopulation(aliveNeighborsCount: Int)
    case reproduction
}

typealias Cells = [Coordinate : Bool]

struct Rules {
    // Anyliving cell with less than survivalMinCount live neighbors will die of underpopulation
    static let survivalMinCount = 2 // Any living cell with at least this amount of live neighbors wil survive
    static let survivalMaxCount = 3 // Any living cell with maximum this amount of live neighbors will survive
    // Anyliving cell with more than survivalMaxCount live neighbors will die of overpopulation
    static let reproductionCount   = 3 // Any dead cell with exactly this amount of live neighbors will become live as reporoduction
}

struct CellBoard {
    
    private(set) var cells = Cells()
    
    let numberOfRows: Int
    let numberOfColumns: Int
    
    init(columns: Int, rows: Int, aliveCellsSeed: [Coordinate]? = nil) {
        
        numberOfColumns = columns
        numberOfRows = rows
        
        reset()
        
        if let seed = aliveCellsSeed {
            for coordinate in seed {
                cells[coordinate] = true
            }
        }
    }
    
    func iterate() -> (newBoard: CellBoard, events: [IterationEvent]) {
        
        var board = CellBoard(columns: numberOfColumns, rows: numberOfRows)
        var events = [IterationEvent]()
        
        for column in 0..<numberOfColumns {
            for row in 0..<numberOfRows {
                let coordinate = Coordinate(column: column, row: row)
                let results = toggle(at: coordinate)
                board.cells[coordinate] = results.newStatus
                events.append(results.event)
            }
        }
        
        return (board, events)
    }
    
    func toggle(at coordinate: Coordinate) -> (newStatus: Bool, event: IterationEvent) {
        
        var isAlive = cells[coordinate] ?? false
        let aliveNeighborsCount = aliveNeigbors(of: coordinate)
        var event: IterationEvent = .dead
        
        if isAlive && aliveNeighborsCount < Rules.survivalMinCount {
            isAlive = false // Underpopulation
            event = .deathByUnderpopulation(aliveNeighborsCount: aliveNeighborsCount)
        }
        else if isAlive && aliveNeighborsCount > Rules.survivalMaxCount {
            isAlive = false // Overpopulation
            event = .deathByOverpopulation(aliveNeighborsCount: aliveNeighborsCount)
        }
        else if !isAlive && aliveNeighborsCount == Rules.reproductionCount {
            isAlive = true // Reproduction
            event = .reproduction
        }
        else if isAlive {
            event = .survivial(aliveNeighborsCount: aliveNeighborsCount) // Survival
        }
        
        return (isAlive, event)
    }
    
//    init(iterate board: CellBoard) {
//
//        numberOfColumns = board.numberOfColumns
//        numberOfRows = board.numberOfRows
//
//        for cell in board.cells {
//
//            let coordinate = cell.key
//            var isAlive = cell.value
//
//            let aliveNeighborsCount = board.aliveNeigbors(of: coordinate)
//
//            if isAlive && aliveNeighborsCount < Rules.survivalMinCount {
//                isAlive = false // Underpopulation
//            }
//            else if isAlive && aliveNeighborsCount > Rules.survivalMaxCount {
//                isAlive = false // Overpopiulation
//            }
//            else if !isAlive && aliveNeighborsCount == Rules.reproductionCount {
//                isAlive = true // Reproduction
//            }
//
//            cells[coordinate] = isAlive
//        }
//    }
    
    mutating func reset() {
        for row in 0..<numberOfRows {
            for column in 0..<numberOfColumns {
                let coordinate = Coordinate(column: column, row: row)
                self.cells[coordinate] = false
            }
        }
    }
    
    func neighbous(of coordinate: Coordinate) -> Cells {
        
        let startRow = max(coordinate.row - 1, 0)
        let endRow = min(coordinate.row + 1, numberOfRows - 1)
        
        let startColumn = max(coordinate.column - 1, 0)
        let endColumn = min(coordinate.column + 1, numberOfColumns - 1)
        
        var neighbors = Cells()
        
        for row in startRow...endRow {
            for column in startColumn...endColumn {
                if column != coordinate.column || row != coordinate.row {
                    let coordinate = Coordinate(column: column, row: row)
                    if let cell = cells[coordinate] {
                        neighbors[coordinate] = cell
                    }
                    else {
                        neighbors[coordinate] = false
                    }
                }
            }
        }
        
        return neighbors
    }
    
    func aliveNeigbors(of coordinate: Coordinate) -> Int {
        
        var alive = 0
        for cell in neighbous(of: coordinate) {
            alive += cell.value ? 1 : 0
        }
        
        return alive
    }
    
    var aliveCellCount: Int {
        
        var _count = 0
        for cell in cells {
            _count += cell.value ? 1 : 0
        }
        return _count
    }
    
    var description: String {
        
        var desc = ""
        for row in 0..<numberOfRows {
            var rowDesc = ""
            for column in 0..<numberOfColumns {
                let coordinate = Coordinate(column: column, row: row)
                let isAlive = cells[coordinate] ?? false
                rowDesc = "\(rowDesc)\(isAlive ? "X" : "-")"
            }
            desc = "\(desc)\(desc.isEmpty ? "" : "\n")\(rowDesc)"
        }
        
        return desc
    }
}
