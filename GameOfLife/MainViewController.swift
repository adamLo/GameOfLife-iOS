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
    
    // MARK: - Actions
    
    @objc func startButtonTouched(_ sender: Any) {
        
        if let _game = game, step < _game.iterations.count {
            
            stop = false
            playback()
        }
        else {
            
            playXelionGame()
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
