//
//  ViewController.swift
//  GameOfLife
//
//  Created by Adam Lovastyik on 04/05/2019.
//  Copyright © 2019 xelion.nl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let seed = CellBoard(columns: 4, rows: 4, aliveCellsSeed: [Coordinate(column: 2, row: 0), Coordinate(column: 0, row: 2), Coordinate(column: 1, row: 2), Coordinate(column: 1, row: 3), Coordinate(column: 3, row: 3)])
        var game = Game(board: seed)
        var step = 0
        let maxStep = 100
        var go = true
        while go && step < maxStep {
            
            go = game.iterate()
            if go && game.isFinished {
                go = false
            }
            step += go ? 1 : 0
        }
        
        print("Finished after \(step + 1) iterations")
        step = 0
        for board in game.iterations {
            if step == 0 {
                print("Initial state")
            }
            else {
                print("\(step). iteration")
            }
            print(board.description)
            step += 1
        }
    }
}

