//
//  Game.swift
//  GameOfLife
//
//  Created by Adam Lovastyik on 04/05/2019.
//  Copyright © 2019 xelion.nl. All rights reserved.
//

import Foundation

struct Game {
    
    private(set) var iterations = [CellBoard]()
    private(set) var events = [CellEvents]()
    
    init(board: CellBoard? = nil) {
        
        if let _board = board {
            iterations = [_board]
        }
    }
    
    init(columns: Int, rows: Int) {
        
        let board = CellBoard(columns: columns, rows: rows)
        iterations = [board]
    }
    
    mutating func iterate() -> Bool {
        
        if let board = iterations.last {
        
            let results = board.iterate()
            
            let newBoard = results.newBoard
            iterations.append(newBoard)
            
            let newEvents = results.events
            events.append(newEvents)
            
            return true
        }
        
        return false
    }
    
    var isFinished: Bool {
        
        guard let last = iterations.last else {return false}
        
        let liveCount = last.aliveCellCount
        if liveCount == 0 {
            return true
        }
        else if liveCount == last.numberOfColumns * last.numberOfRows {
            return true
        }
        
        if iterations.count > 1 {
            let last = iterations[iterations.count - 1]
            let previous = iterations[iterations.count - 2]
            if last == previous {
                return true
            }
        }
        
        return false
    }
}
