//
//  ViewController.swift
//  Tic Tac Toe
//
//  Created by Mike Choe on 10/12/16.
//  Copyright © 2016 cheezy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var ActiveGame = true // Boolean to check if the game is still ongoing or finished
    
    var ActivePlayer = 1  // By default, player 1 (O's) goes first. This can be changed with a button that enables choice of order for players
    
    var AIPlayer = true   // Checking to see if 1 player mode vs AI, by default 1 player
    
    // Implementation of one player mode.
    // Requires: Touch of "1 Player" button on top left of screen
    // Action: Sets AIPlayer bool to true and begins a new game regardless if ongoing game or not
    // Hides the play again button and winner declaration while game is active
    
    @IBAction func oneplayer(_ sender: AnyObject) {
        
        AIPlayer = true
        ActiveGame = true
        
        turn = 0
        
        ActivePlayer = 1
        
        gameState = [0, 0, 0, 0, 0, 0, 0, 0, 0]
        
        for i in 1..<10 {
            //cast cuz it returns general view, cast it to button
            if let button = view.viewWithTag(i) as? UIButton {
                
                button.setImage(nil, for: [])
                
            }
            winnerLabel.isHidden = true
            playagainbutton.isHidden = true
            
            winnerLabel.center = CGPoint(x: winnerLabel.center.x-500, y: winnerLabel.center.y)
            
            playagainbutton.center = CGPoint(x: winnerLabel.center.x-500, y: winnerLabel.center.y)
        }

        
    }
    
    // Implementation of two player mode.
    // Requires: Touch of "2 Player" button on top right of screen.
    // Action: Sets AIPlayer bool to false and begins a new game regardless if ongoing game or not
    // Hides the play again button and winner declaration while game is active.
    // Input is now dependent on human touch only, and AI will be deactivated.

    
    @IBAction func twoplayer(_ sender: AnyObject) {
        
        AIPlayer = false
        ActiveGame = true
        
        turn = 0
        
        ActivePlayer = 1
        
        gameState = [0, 0, 0, 0, 0, 0, 0, 0, 0]
        
        for i in 1..<10 {
            //cast cuz it returns general view, cast it to button
            if let button = view.viewWithTag(i) as? UIButton {
                
                button.setImage(nil, for: [])
                
            }
            winnerLabel.isHidden = true
            playagainbutton.isHidden = true
            
            winnerLabel.center = CGPoint(x: winnerLabel.center.x-500, y: winnerLabel.center.y)
            
            playagainbutton.center = CGPoint(x: winnerLabel.center.x-500, y: winnerLabel.center.y)
        }

    }
    
    // Outlet declarations of nine buttons for each square.
    // Used to update images of buttons for AI mode.
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!
    
    
    // winnerLabel is a text label that declares the winning symbol.
    @IBOutlet weak var winnerLabel: UILabel!
    
    
    // playagainbutton is simply a button that allows the user to reset the board and play again. 
    // Only shows up after game is over either by one side winning or a stalemate.
    // The button is both an outlet (for animation purposes) and action.
    @IBOutlet weak var playagainbutton: UIButton!
    
    @IBAction func playAgain(_ sender: AnyObject) {
        
        ActiveGame = true
        
        turn = 0         // Sets turn back to zero
        
        ActivePlayer = 1 // Sets the active player to 1 by default
        
        gameState = [0, 0, 0, 0, 0, 0, 0, 0, 0] // Board positions are set back to zero
        
        for i in 1..<10 {
            //cast cuz it returns general view, cast it to button
            if let button = view.viewWithTag(i) as? UIButton {
                // Clearing image names for each position, making it empty again.
                button.setImage(nil, for: [])
                
            }
            
            // Finally hiding the winning text label and play again button off screen until winner/stalemate is decided.
            
            winnerLabel.isHidden = true
            playagainbutton.isHidden = true
            
            winnerLabel.center = CGPoint(x: winnerLabel.center.x-500, y: winnerLabel.center.y)
            
            playagainbutton.center = CGPoint(x: winnerLabel.center.x-500, y: winnerLabel.center.y)
        }
        
        
    }
    
    var turn = 0 // Turn is a variable keeping track of the current turn, which cannot surpass 9.
    
    var i = 0 // i is a variable used in playAgain to reset the game board.
    
    var gameState = [0, 0, 0, 0, 0, 0, 0, 0, 0] // 0 represents empty, 1-noughts, 2-crosses
    
    // All possible winning combination and their respective locations in the gameState array.
    
    let winningCombinations = [[0, 1, 2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0, 4, 8], [2, 4, 6]]
    
    
    // Implementation of AI strategy.
    // Requires: Touch of "1 Player" button on top right of screen.
    // Action: Allows the AI to choose a space on the board depending on current status of the board.
    // Activates after player takes his turn and sets one empty position on board to X.
    // Currently it will only go second after the player.
    
    // Strategy breakdown in descending priority.
    // 1. Take center piece if open.
    // 2. Check positions in winning Combinations for 022, 220, 202 and place X in empty position for win.
    // 3. Check positions in winning Combinations for 011, 110, 101 and place X to prevent win of player.
    // 4. Randomly generate a number between 0 and 8, and check if board is empty at that position. Insert there. This is if there is no better move.
    
    func aiTurn() {
        
        var j = 4
        
        if ActiveGame == false {
            return
        }
        
        // 1. Take center piece if open.
        
        if gameState[4] == 0 {
            gameState[4] = 2
            
            i = 4
            button5.setImage(UIImage(named: "cross.png"),for: []) // set image to X
            turn += 1
            return
            
        }
        
        // 2. Check positions in winning Combinations for 022, 220, 202 and place X in empty position for win.
        
        for combination in winningCombinations {
            
            if gameState[combination[0]] == 0 && gameState[combination[1]] == 2 && gameState[combination[2]] == 2  {
                
                gameState[combination[0]] = 2
                if(combination[0] == 0) {
                    button1.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[0] == 1) {
                    button2.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[0] == 2) {
                    button3.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[0] == 3) {
                    button4.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[0] == 4) {
                    button5.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[0] == 5) {
                    button6.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[0] == 6) {
                    button7.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[0] == 7) {
                    button8.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[0] == 8) {
                    button9.setImage(UIImage(named: "cross.png"),for: [])
                }
                turn += 1
                return
                
            }
            
            else if gameState[combination[0]] == 2 && gameState[combination[1]] == 0 && gameState[combination[2]] == 2  {
                
                 gameState[combination[1]] = 2
                
                if(combination[1] == 0) {
                    button1.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[1] == 1) {
                    button2.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[1] == 2) {
                    button3.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[1] == 3) {
                    button4.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[1] == 4) {
                    button5.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[1] == 5) {
                    button6.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[1] == 6) {
                    button7.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[1] == 7) {
                    button8.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[1] == 8) {
                    button9.setImage(UIImage(named: "cross.png"),for: [])
                }
                turn += 1
                return
            }
            
            else if gameState[combination[0]] == 2 && gameState[combination[1]] == 2 && gameState[combination[2]] == 0  {
                
                 gameState[combination[2]] = 2
                
                if(combination[2] == 0) {
                    button1.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[2] == 1) {
                    button2.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[2] == 2) {
                    button3.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[2] == 3) {
                    button4.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[2] == 4) {
                    button5.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[2] == 5) {
                    button6.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[2] == 6) {
                    button7.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[2] == 7) {
                    button8.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[2] == 8) {
                    button9.setImage(UIImage(named: "cross.png"),for: [])
                }
                turn += 1
                return
            }
            
            

            
        }
        
        // 3. Check positions in winning Combinations for 011, 110, 101 and place X to prevent win of player.

        
        for combination in winningCombinations {
            
            if gameState[combination[0]] == 0 && gameState[combination[1]] == 1 && gameState[combination[2]] == 1  {
                
                gameState[combination[0]] = 2
                
                if(combination[0] == 0) {
                    button1.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[0] == 1) {
                    button2.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[0] == 2) {
                    button3.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[0] == 3) {
                    button4.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[0] == 4) {
                    button5.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[0] == 5) {
                    button6.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[0] == 6) {
                    button7.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[0] == 7) {
                    button8.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[0] == 8) {
                    button9.setImage(UIImage(named: "cross.png"),for: [])
                }
                turn += 1
                return
                
            }
                
            else if gameState[combination[0]] == 1 && gameState[combination[1]] == 0 && gameState[combination[2]] == 1  {
                
                gameState[combination[1]] = 2
                
                if(combination[1] == 0) {
                    button1.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[1] == 1) {
                    button2.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[1] == 2) {
                    button3.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[1] == 3) {
                    button4.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[1] == 4) {
                    button5.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[1] == 5) {
                    button6.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[1] == 6) {
                    button7.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[1] == 7) {
                    button8.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[1] == 8) {
                    button9.setImage(UIImage(named: "cross.png"),for: [])
                }
                turn += 1
                return
            }
                
            else if gameState[combination[0]] == 1 && gameState[combination[1]] == 1 && gameState[combination[2]] == 0  {
                
                gameState[combination[2]] = 2
                
                if(combination[2] == 0) {
                    button1.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[2] == 1) {
                    button2.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[2] == 2) {
                    button3.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[2] == 3) {
                    button4.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[2] == 4) {
                    button5.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[2] == 5) {
                    button6.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[2] == 6) {
                    button7.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[2] == 7) {
                    button8.setImage(UIImage(named: "cross.png"),for: [])
                }
                else if(combination[2] == 8) {
                    button9.setImage(UIImage(named: "cross.png"),for: [])
                }
                turn += 1
                return
            }
            
            
            
        }
        
        // 4. Randomly generate a number between 0 and 8, and check if board is empty at that position. Insert there. This is if there is no better move.
        
        while gameState[j] != 0  {
            
            j = Int(arc4random_uniform(9))
            
            print (j)
            
        }
        
        if gameState[j] == 0 {
            
            gameState[j] = 2
            
            if(j == 0) {
                button1.setImage(UIImage(named: "cross.png"),for: [])
            }
            else if(j == 1) {
                button2.setImage(UIImage(named: "cross.png"),for: [])
            }
            else if(j == 2) {
                button3.setImage(UIImage(named: "cross.png"),for: [])
            }
            else if(j == 3) {
                button4.setImage(UIImage(named: "cross.png"),for: [])
            }
            else if(j == 4) {
                button5.setImage(UIImage(named: "cross.png"),for: [])
            }
            else if(j == 5) {
                button6.setImage(UIImage(named: "cross.png"),for: [])
            }
            else if(j == 6) {
                button7.setImage(UIImage(named: "cross.png"),for: [])
            }
            else if(j == 7) {
                button8.setImage(UIImage(named: "cross.png"),for: [])
            }
            else if(j == 8) {
                button9.setImage(UIImage(named: "cross.png"),for: [])
            }
            
            turn += 1
            return

        }
        
        
        
        
    }
    
    // Implementation of response to button pressed by human player(s)
    // Requires: Touch of any position on board in both 1 player and 2 player modes.
    // Action: Sets the space to a certain image depending on identity of ActivePlayer, 
    // checks for a winning combination after each turn, updates turn by 1 after each player's turn, 
    // and finally checks for a stalemate if it's turn 9 and there is no winner.

    // Output is determined by both human touch and AI turn function.
    
    @IBAction func buttonPressed(_ sender: AnyObject) {
        
        let activePosition = sender.tag - 1
        
        if gameState[activePosition] == 0 && ActiveGame {
            
            gameState[activePosition] = ActivePlayer
            
            // Two player mode. Both O's and X's placement are determined by human touch.
            
            if AIPlayer == false {
                if ActivePlayer == 1 {
                
                    sender.setImage(UIImage(named: "nought.png"), for: [])
                    ActivePlayer = 2
                    turn += 1
                
                } else {
                    sender.setImage(UIImage(named: "cross.png"), for: [])
                    ActivePlayer = 1
                    turn += 1
                
                    }
            }
            
            // One player mode. O's are determined by human player. X's are AI.
                
            else {
                
                    
                    sender.setImage(UIImage(named: "nought.png"), for: [])
                    turn += 1
                    print ("turn after player: \(turn)")
                    checkWinner()
                
                if(turn < 9) {
                    aiTurn()
                    print ("turn after AI: \(turn)")
                    checkWinner()
                }
                
                
            }
            
            // if turn 9 and there is still no winner, execute stalemate message and end game.
            
            if (turn == 9 && ActiveGame == true) {
                        
                    ActiveGame = false
                    
                    winnerLabel.isHidden = false
                    playagainbutton.isHidden = false
                    
                    winnerLabel.text = "Stalemate!"
                    
                    UIView.animate(withDuration: 1, animations: {
                        
                        self.winnerLabel.center = CGPoint(x:self.winnerLabel.center.x + 500, y:self.winnerLabel.center.y)
                        
                        self.playagainbutton.center = CGPoint(x:self.playagainbutton.center.x + 500, y:self.playagainbutton.center.y)
                    })
                
                

                
            }
            

        }
        
                //print (sender.tag)
    }

    // Implementation of function to check for winning combination
    // Requires: End of a turn, either by a player or AI.
    // Action: Goes through the winning combination array and checks to see if there are three consecutive spaces with the same symbol.
    // If the identity of the symbol is 1, O's have won. Otherwise if it's 2, X's won.
    //
    
    // Output is determined by both human touch and AI turn function.

    
    func checkWinner() {
        for combination in winningCombinations {
            
            if gameState[combination[0]] != 0 && gameState[combination[0]] == gameState[combination[1]] && gameState[combination[1]] == gameState[combination[2]] {
                
                // We have a winner!
                
                // Stop the game now.
                ActiveGame = false
                
                winnerLabel.isHidden = false
                playagainbutton.isHidden = false
                
                
                // Check the first value in gameState array. If it is 1, O's win, if it is 2, X's win.
                
                if gameState[combination[0]] == 1 {
                    
                    winnerLabel.text = "O's have won!"
                }
                    
                else {
                    winnerLabel.text = "X's have won!"
                }
                
                // Bring in the winning text label and play again button from off screen.
                
                UIView.animate(withDuration: 1, animations: {
                    
                    self.winnerLabel.center = CGPoint(x:self.winnerLabel.center.x + 500, y:self.winnerLabel.center.y)
                    
                    self.playagainbutton.center = CGPoint(x:self.playagainbutton.center.x + 500, y:self.playagainbutton.center.y)
                })
            }
            
        }
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // When application loads, we simply hide the winnerLabel and playagainbutton off screen.
        
        winnerLabel.isHidden = true
        playagainbutton.isHidden = true
        
        winnerLabel.center = CGPoint(x: winnerLabel.center.x-500, y: winnerLabel.center.y)
        
        playagainbutton.center = CGPoint(x: winnerLabel.center.x-500, y: winnerLabel.center.y)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

