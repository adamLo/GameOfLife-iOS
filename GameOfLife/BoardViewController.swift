//
//  BoardViewController.swift
//  GameOfLife
//
//  Created by Adam Lovastyik on 25/05/2019.
//  Copyright © 2019 xelion.nl. All rights reserved.
//

import UIKit

class BoardViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var boardScrollView: UIScrollView!
    
    public static let aliveColor = UIColor.red
    public static let deadColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
    
    private class CellWrapper {
        
        let coordinate: Coordinate
        weak var view: UIView!
        var isAlive = false
        
        func update(isAlive: Bool) {
            if view != nil {
                view.backgroundColor = isAlive ? BoardViewController.aliveColor : BoardViewController.deadColor
                self.isAlive = isAlive
            }
        }
        
        init(coordinate: Coordinate, view: UIView, isAlive: Bool) {
            self.coordinate = coordinate
            self.isAlive = isAlive
            self.view = view
        }
    }
    
    private weak var holderView: UIView!
    private var cells = [CellWrapper]()
    
    private var editBoard = false
    private var tapGestureRecognizers = [UITapGestureRecognizer]()
    
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
        
        let cellSize: CGFloat = min(max(UIScreen.main.bounds.size.width / CGFloat(max(board.numberOfColumns, 1)), UIScreen.main.bounds.size.width / 32), UIScreen.main.bounds.size.width / 8)
        
        let holderFrame = CGRect(x: 0, y: 0, width: cellSize * CGFloat(board.numberOfColumns), height: cellSize * CGFloat(board.numberOfRows))
        holderView.frame = holderFrame
        holderView.center = boardScrollView.center
        
        boardScrollView.contentSize = holderFrame.size
        boardScrollView.isScrollEnabled = true
        
        for cell in board.cells {
            
            let coordinate = cell.key
            
            let view = UIView()
            view.frame = CGRect(x: CGFloat(coordinate.column) * cellSize , y: CGFloat(coordinate.row) * cellSize, width: cellSize, height: cellSize)
            view.layer.borderWidth = 0.5
            view.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0).cgColor
            holderView.addSubview(view)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
            tapGestureRecognizer.delegate = self
            view.addGestureRecognizer(tapGestureRecognizer)
            tapGestureRecognizers.append(tapGestureRecognizer)
            view.isUserInteractionEnabled = true
            
            let wrapper = CellWrapper(coordinate: coordinate, view: view, isAlive: cell.value)
            wrapper.update(isAlive: cell.value)
            cells.append(wrapper)
        }
    }
    
    public func update(with board: CellBoard, forceClear: Bool = false) {
        
        if forceClear || holderView == nil || cells.count != board.numberOfColumns * board.numberOfRows {
            
            clearBoard()
            create(board: board)
        }
        else {
        
            for cell in board.cells {
                for wrapper in cells {
                    if wrapper.coordinate == cell.key {
                        wrapper.update(isAlive: cell.value)
                    }
                }
            }
        }
    }
    
    private func clearBoard() {
        
        tapGestureRecognizers.removeAll()
        
        for wrapper in cells {
            if wrapper.view != nil {
                wrapper.view.removeFromSuperview()
            }
        }
        cells.removeAll()
    }
    
    // MARK: - Create custom board
    
    func createBoard(numberOfColumns: Int, numberOfRows: Int, seed: [Coordinate]? = nil) {
        
        editBoard = true
        
        let board = CellBoard(columns: numberOfColumns, rows: numberOfRows, aliveCellsSeed: seed)
        update(with: board, forceClear: true)
    }
    
    var customBoard: CellBoard? {
        
        var seed = [Coordinate]()
        var columns = 0
        var rows = 0
        
        for wrapper in cells {
            if wrapper.isAlive {
                seed.append(wrapper.coordinate)
            }
            columns = max(wrapper.coordinate.column, columns)
            rows = max(wrapper.coordinate.row, rows)
        }
        
        return seed.count > 0 && columns > 0 && rows > 0 ? CellBoard(columns: columns + 1, rows: rows + 1, aliveCellsSeed: seed) : nil
    }
    
    // MARK: - Actions

    @objc func cellTapped(_ sender: UITapGestureRecognizer) {

        if editBoard, let cellView = sender.view {
            for wrapper in cells {
                if wrapper.view == cellView {
                    wrapper.update(isAlive: !wrapper.isAlive)
                    return
                }
            }
        }
    }
    
    // MARK: - Gesture Recognizer
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
