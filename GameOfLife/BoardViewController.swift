//
//  BoardViewController.swift
//  GameOfLife
//
//  Created by Adam Lovastyik on 25/05/2019.
//  Copyright © 2019 xelion.nl. All rights reserved.
//

import UIKit

class BoardViewController: UIViewController {

    @IBOutlet weak var boardScrollView: UIScrollView!
    
    private struct CellWrapper {
        let coordinate: Coordinate
        weak var view: UIView!
        var isAlive = false
        
        mutating func update(isAlive: Bool) {
            if view != nil {
                view.backgroundColor = isAlive ? UIColor.red : UIColor.clear
                self.isAlive = isAlive
            }
        }
    }
    
    private weak var holderView: UIView!
    private var cells = [CellWrapper]()
    
    // MARK: - Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - UI Customization

    private func create(board: CellBoard) {
        
        if holderView == nil {
            let _view = UIView()
            boardScrollView.addSubview(_view)
            holderView = _view
            holderView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
            
            holderView.layer.borderWidth = 1.0
            holderView.layer.borderColor = UIColor.black.cgColor
            holderView.clipsToBounds = true
        }
        
        let cellSize: CGFloat = min(max(UIScreen.main.bounds.size.width / CGFloat(max(board.numberOfColumns, 1)), UIScreen.main.bounds.size.width / 30), UIScreen.main.bounds.size.width / 20)
        
        let holderFrame = CGRect(x: 0, y: 0, width: cellSize * CGFloat(board.numberOfColumns), height: cellSize * CGFloat(board.numberOfRows))
        holderView.frame = holderFrame
        holderView.center = boardScrollView.center
        
        for cell in board.cells {
            
            let coordinate = cell.key
            let view = UIView()
            view.frame = CGRect(x: CGFloat(coordinate.column) * cellSize , y: CGFloat(coordinate.row) * cellSize, width: cellSize, height: cellSize)
            holderView.addSubview(view)
            var wrapper = CellWrapper(coordinate: coordinate, view: view, isAlive: cell.value)
            wrapper.update(isAlive: cell.value)
            cells.append(wrapper)
        }
    }
    
    public func update(with board: CellBoard) {
        
        if holderView == nil || cells.count != board.numberOfColumns * board.numberOfRows {
            
            clearBoard()
            create(board: board)
        }
        else {
        
            for cell in board.cells {
                for var wrapper in cells {
                    if wrapper.coordinate == cell.key {
                        wrapper.update(isAlive: cell.value)
                    }
                }
            }
        }
    }
    
    private func clearBoard() {
        
        for wrapper in cells {
            if wrapper.view != nil {
                wrapper.view.removeFromSuperview()
            }
        }
        cells.removeAll()
    }
}
