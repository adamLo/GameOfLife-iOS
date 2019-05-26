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
    }
    
    // MASK: - UI Customization
    
    private func setupUI() {
        
        columnsStaticLabel.text = NSLocalizedString("Columns:", comment: "Number of columns title")
        rowsStaticLabel.text = NSLocalizedString("Rows:", comment: "Number of rows title")
        
        regenerateButton.setTitle(NSLocalizedString("Re-generate", comment: "Regenerate button title"), for: .normal)
        
        typeSegmentedControl.setTitle(NSLocalizedString("Custom", comment: "Custom layout title"), forSegmentAt: 0)
        typeSegmentedControl.setTitle(NSLocalizedString("Xelion", comment: "Xelion layout title"), forSegmentAt: 1)
        typeSegmentedControl.setTitle(NSLocalizedString("Random", comment: "Random layout title"), forSegmentAt: 2)
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
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let _controller = segue.destination as? BoardViewController {
            boardViewController = _controller
        }
    }
    
    // MARK: - Actions
    
    @IBAction func typeSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        updateControlsState()
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        
        updateColumnsAndRowsValues()
    }
    
    @IBAction func regenerateButtonTouched(_ sender: Any) {
    }
}
