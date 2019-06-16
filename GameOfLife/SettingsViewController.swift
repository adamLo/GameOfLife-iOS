//
//  SettingsViewController.swift
//  GameOfLife
//
//  Created by Adam Lovastyik on 26/05/2019.
//  Copyright © 2019 xelion.nl. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var columnsStaticLabel: UILabel!
    @IBOutlet weak var rowsStaticLabel: UILabel!
    
    @IBOutlet weak var columnsValueLabel: UILabel!
    @IBOutlet weak var rowsValueLabel: UILabel!
    
    @IBOutlet weak var columnsStepper: UIStepper!
    @IBOutlet weak var rowsStepper: UIStepper!
    
    @IBOutlet weak var regenerateButton: UIButton!
    
    private weak var boardViewController: BoardViewController!
    
    // MARK: - Controller lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        setupUI()
        updateControlsState()
        updateColumnsAndRowsValues()
        createBoard()
    }
    
    // MASK: - UI Customization
    
    private func setupUI() {
        
        columnsStaticLabel.text = NSLocalizedString("Columns:", comment: "Number of columns title")
        rowsStaticLabel.text = NSLocalizedString("Rows:", comment: "Number of rows title")
        
        regenerateButton.setTitle(NSLocalizedString("Re-generate", comment: "Regenerate button title"), for: .normal)
        
        typeSegmentedControl.setTitle(NSLocalizedString("Custom", comment: "Custom layout title"), forSegmentAt: 0)
        typeSegmentedControl.setTitle(NSLocalizedString("Xelion", comment: "Xelion layout title"), forSegmentAt: 1)
        typeSegmentedControl.setTitle(NSLocalizedString("Random", comment: "Random layout title"), forSegmentAt: 2)
        
        columnsStepper.value = 4
        rowsStepper.value = 4
    }
    
    private func updateColumnsAndRowsValues() {
        
        let cols = Int(exactly: columnsStepper.value) ?? 0
        let rows = Int(exactly: rowsStepper.value) ?? 0
        
        columnsValueLabel.text = "\(cols)"
        rowsValueLabel.text = "\(rows)"
    }
    
    private func updateControlsState() {
        
        columnsStepper.isEnabled = typeSegmentedControl.selectedSegmentIndex == 0
        rowsStepper.isEnabled = typeSegmentedControl.selectedSegmentIndex == 0
        regenerateButton.isEnabled = typeSegmentedControl.selectedSegmentIndex == 2
    }
    
    private func createBoard() {
        
        var seed = [Coordinate]()
        var cols = Int(exactly: columnsStepper.value) ?? 0
        var rows = Int(exactly: rowsStepper.value) ?? 0
        if typeSegmentedControl.selectedSegmentIndex == 1 {
            // Xelion
            cols = 4
            rows = 4
            seed = [Coordinate(column: 2, row: 0), Coordinate(column: 0, row: 2), Coordinate(column: 1, row: 2), Coordinate(column: 1, row: 3), Coordinate(column: 3, row: 3)]
        }
        else if typeSegmentedControl.selectedSegmentIndex == 2 {
            // Random
            cols = Int.random(in: 3...7)
            rows = cols
            for _ in 0..<(Int(exactly: (rows * rows) / 2) ?? rows) {
                let coordinate = Coordinate(column: Int.random(in: 0..<cols), row: Int.random(in: 0..<cols))
                if !seed.contains(coordinate) {
                    seed.append(coordinate)
                }
            }
        }
        
        columnsStepper.value = Double(cols)
        rowsStepper.value = Double(rows)
        
        boardViewController.createBoard(numberOfColumns: cols, numberOfRows: rows, seed: seed)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let _controller = segue.destination as? BoardViewController {
            boardViewController = _controller
        }
    }
    
    // MARK: - Actions
    
    @IBAction func typeSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        updateControlsState()
        updateColumnsAndRowsValues()
        createBoard()
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        
        updateColumnsAndRowsValues()
        createBoard()
    }
    
    @IBAction func regenerateButtonTouched(_ sender: Any) {
        
        if typeSegmentedControl.selectedSegmentIndex == 2 {
            createBoard()
        }
    }
}
