//
//  MainViewController.swift
//  GameOfLife
//
//  Created by Adam Lovastyik on 25/05/2019.
//  Copyright © 2019 xelion.nl. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITabBarDelegate {

    private weak var boardViewController: BoardViewController!
    private weak var settingsViewController: SettingsViewController!
    
    @IBOutlet weak var playbackHolderView: UIView!
    @IBOutlet weak var settingsHolderView: UIView!
    
    @IBOutlet weak var mainTabBar: UITabBar!
    
    
    private var step = 0
    private var stop = false
    private var game: Game?
    private var isPlaying = false
    
    // MARK: - Controller Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        setupUI()
    }
    
    // MARK: - UI Customization
    
    private func setupUI() {
        
        title = NSLocalizedString("Game Of Life", comment: "Main screen title")
        
        addStartButton()
        setupTabbar()
    }
    
    private func addStartButton() {
        
        let button = UIBarButtonItem(title: NSLocalizedString("Start", comment: "Start buttont title"), style: .plain, target: self, action: #selector(startButtonTouched(_:)))
        navigationItem.rightBarButtonItem = button
    }
    
    private func addStopButton() {
        
        let button = UIBarButtonItem(title: NSLocalizedString("Stop", comment: "Stop btton title"), style: .plain, target: self, action: #selector(stopButtonTouched(_:)))
        navigationItem.rightBarButtonItem = button
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? BoardViewController {
            boardViewController = controller
        }
        else if let controller = segue.destination as? SettingsViewController {
            settingsViewController = controller
        }
    }

    private func playXelionGame() {
        
        DispatchQueue.global(qos: .userInitiated).async {

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
            
            print("Finished in \(step) iterations")
            
            DispatchQueue.main.async {
                
                self.game = game
                self.step = 0
                self.stop = false
                self.isPlaying = false
                
                self.playback()

//                print("Finished after \(step + 1) iterations")
//                step = 0
//                for board in game.iterations {
//                    if step == 0 {
//                        print("Initial state")
//                    }
//                    else {
//                        print("\(step). iteration")
//                    }
//                    print(board.description)
//
//                    if step > 0 && step < game.events.count {
//                        print("Events:\n\(game.events[step].description)")
//                    }
//
//                    step += 1
//                }
            }
        }
    }
    
    private func playback() {
        
        if let _game = game, _game.iterations.count > step && !stop {
            
            if !isPlaying {
                isPlaying = true
                addStopButton()
            }
            
            let board = _game.iterations[step]
            boardViewController.update(with: board, forceClear: true)
            step += 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.playback()
            }
        }
        else {
            isPlaying = false
            stop = false
            addStartButton()
        }
    }
    
    private func playGame() {
        
        guard settingsViewController != nil, let board = settingsViewController.gameBoard else {
            
            let alert = UIAlertController(title: nil, message: NSLocalizedString("Please create a board!", comment: "Error message when board is not set up"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK button title"), style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        guard settingsViewController != nil, settingsViewController.iterations > 0 else {
            
            let alert = UIAlertController(title: nil, message: NSLocalizedString("Please set the maximum number of iterations", comment: "Error message when iterations count not set"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK button title"), style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let maxIterations = settingsViewController.iterations
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            var game = Game(board: board)
            var step = 0
            var go = true
            while go && step < maxIterations {
                
                go = game.iterate()
                if go && game.isFinished {
                    go = false
                }
                step += go ? 1 : 0
            }
            
            print("Finished in \(step) iterations")
            
            DispatchQueue.main.async {
                
                self.game = game
                self.step = 0
                self.stop = false
                self.isPlaying = false
                
                self.playback()
            }
        }
    }
    
    // MARK: - Actions
    
    @objc func startButtonTouched(_ sender: Any) {
        
        if let _game = game, step < _game.iterations.count {
            
            let alert = UIAlertController(title: nil, message: NSLocalizedString("There's already one geame created. Would you like to continue or start a new one?", comment: "Play dialog message when game in progress"), preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Continue", comment: "Continue button title"), style: .default, handler: { (_) in
            
                self.stop = false
                self.playback()
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("New game", comment: "New game button titke"), style: .destructive, handler: { (_) in
                self.playGame()
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel button title"), style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        else {
            
            playGame()
        }
    }
    
    @objc func stopButtonTouched(_ sender: Any) {
        
        stop = true
    }
    
    // MARK: - Tab bar
    
    private func setupTabbar() {
        
        mainTabBar.items?.removeAll()
        
        let playbackItem = UITabBarItem(title: NSLocalizedString("Playback", comment: "Playback tab bar item title"), image: nil, tag: 0)
        let setupItem = UITabBarItem(title: NSLocalizedString("Config", comment: "Configuration tab bar item title"), image: nil, tag: 1)
        
        mainTabBar.items = [playbackItem, setupItem]
        mainTabBar.selectedItem = playbackItem
        
        updateScreens()
    }
    
    // MARK: Delegate
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        updateScreens()
    }
    
    func updateScreens() {
    
        playbackHolderView.isHidden = true
        settingsHolderView.isHidden = true
        
        if let item = mainTabBar.selectedItem {
            
            switch item.tag {
            case 0:
                playbackHolderView.isHidden = false
            case 1:
                settingsHolderView.isHidden = false
            default:
                break
            }
        }
    }
}
