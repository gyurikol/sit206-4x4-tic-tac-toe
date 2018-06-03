//
//  ViewController.swift
//  Tic Tac Toe 4x4
//
//  Created by George Kolecsanyi on 11/4/18.
//  Copyright © 2018 Deakin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // IBOUTLETS
    @IBOutlet weak var b00: UIButton! // IBOutlets for buttons
    @IBOutlet weak var b10: UIButton!
    @IBOutlet weak var b20: UIButton!
    @IBOutlet weak var b30: UIButton!
    @IBOutlet weak var b01: UIButton!
    @IBOutlet weak var b11: UIButton!
    @IBOutlet weak var b21: UIButton!
    @IBOutlet weak var b31: UIButton!
    @IBOutlet weak var b02: UIButton!
    @IBOutlet weak var b12: UIButton!
    @IBOutlet weak var b22: UIButton!
    @IBOutlet weak var b32: UIButton!
    @IBOutlet weak var b03: UIButton!
    @IBOutlet weak var b13: UIButton!
    @IBOutlet weak var b23: UIButton!
    @IBOutlet weak var b33: UIButton!
    @IBOutlet weak var pStatus: UILabel!  // IBOutlet for the player turn label
    @IBOutlet weak var pOneName: UILabel!
    @IBOutlet weak var pTwoName: UILabel!
    @IBOutlet weak var pOneScore: UILabel!
    @IBOutlet weak var pTwoScore: UILabel!
    @IBOutlet weak var defaultTextColor: UILabel!
    @IBOutlet weak var playAgain: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var musicButton: UIButton!
    @IBOutlet weak var svHistory: UIScrollView!
    
    
    // VARS
    var winHistory = [UIImageView]() // empty image array for winner
    
    var singlePlayer = Bool()
    var playerOneName = String()
    var playerTwoName = String()
    var playerOneSymbol = Int()
    var playerScores = [Int]()
    var playerColor = [UIColor]()
    
    var imgMusic : [UIImage] = [ // array of image names for music on/off
        UIImage(named: "music-off")!,
        UIImage(named: "music-on")!
    ]
    
    var playerTurn = Int() // var for initial player turn
    
    var imgs = [UIImage]() // empty image array before symbol selection
    var drawImg = UIImage(named: "draw")
    var playerOneNought = Bool()
    
    public var buttons = [UIButton]() // prepare empty array of buttons
    var winConditions = [[Int]]() // empty array of button patterns
    
    // ENUM
    enum GameTermination {  // game termination enums
        case win
        case draw
        case null
    }
    
    // FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // initialize game
        initGame()
        
        buttons = [ // array of all buttons for iteration purposes
             b00, b10, b20, b30, b01, b11, b21, b31, b02, b12, b22, b32, b03, b13, b23, b33
        ]
        winConditions = [ // fill array of buttons with win condition patterns
                [ 0, 1, 2, 3 ],         // horizontal
                [ 4, 5, 6, 7 ],         // horizontal
                [ 8, 9, 10, 11 ],       // horizontal
                [ 12, 13, 14, 15 ],     // horizontal
                [ 0, 4, 8, 12 ],        // vertical
                [ 1, 5, 9, 13 ],        // vertical
                [ 2, 6, 10, 14 ],       // vertical
                [ 3, 7, 11, 15 ],       // vertical
                [ 0, 5, 10, 15 ],       // diagonal
                [ 3, 6, 9, 12 ]         // diagonal
        ]
    }
    
    // update background music element when view visible
    override func viewWillAppear(_ animated: Bool) {
        checkMusic()
    }
    
    // on relead reset image and music tags for view
    func checkMusic() {
        if (SKTAudio.sharedInstance().backgroundMusicPlayer?.isPlaying)! {
            musicButton.setBackgroundImage(imgMusic[1], for: .normal)
            musicButton.tag = 1
        } else {
            musicButton.setBackgroundImage(imgMusic[0], for: .normal)
            musicButton.tag = 0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func winLossDrawCheck() -> (termType: GameTermination, descText: String, color: UIColor) { // check for game termination condition
        // check if any pattern is satisfied
        for pattern in winConditions{
            if( buttons[pattern[0]].tag == buttons[pattern[1]].tag &&
                buttons[pattern[0]].tag == buttons[pattern[2]].tag &&
                buttons[pattern[0]].tag == buttons[pattern[3]].tag &&
                buttons[pattern[0]].tag != -1 &&
                buttons[pattern[1]].tag != -1 &&
                buttons[pattern[2]].tag != -1 &&
                buttons[pattern[3]].tag != -1) {
                playerScores[playerTurn] += 1
                
                for btn in buttons  // remove background color
                { btn.backgroundColor = nil }
                
                for btn in pattern  // show only winner background color
                { buttons[btn].backgroundColor = playerColor[playerTurn] }
                
                playAgain.setTitleColor(UIColor.green, for: .normal)
                
                updateHistory(winner: playerTurn) // add to historuy ledger
                if playerTurn == 0 {
                    return (GameTermination.win, "\(playerOneName.uppercased()) WINS!!!",color: playerColor[playerTurn])
                }
                return (GameTermination.win, "\(playerTwoName.uppercased()) WINS!!!", color: playerColor[playerTurn])
            }
        }
        
        // check if all buttons have been pressed
        for btn in buttons {
            if btn.tag == -1 {
                return (GameTermination.null, "", color: UIColor.black) // no termination event found
            }
        }
        
        playerScores[2] += 1
        updateHistory(winner: -1) // add to historuy ledger
        return (GameTermination.draw, "DRAW!!!",color: UIColor.black) // terminate due to draw
    }
    
    func pStatusText(statusText: String, color: UIColor) { // set text for pStatus Label
        pStatus.text = statusText
        pStatus.textColor = color
    }
    func pStatusText(statusText: String, color: UIColor, gameEnum: GameTermination) { // set text for pStatus Label
        if gameEnum == GameTermination.win {
            pStatus.text = statusText
            pStatus.backgroundColor = color
            pStatus.textColor = UIColor.white
        } else if gameEnum == GameTermination.draw {
            pStatus.text = statusText
            pStatus.backgroundColor = UIColor.yellow
            pStatus.textColor = color
        }
    }
    
    func updateScoreUI() {
        pOneScore.text = String(playerScores[0])
        pTwoScore.text = String(playerScores[1])
    }
    
    func initGame() {
        playerTurn = 1
        
        // set player names
        if playerOneName.count == 0 {
            playerOneName = "Player 1"
        }
        if singlePlayer == false {
            if playerTwoName.count == 0 {
                playerTwoName = "Player 2"
            }
        } else {
            playerTwoName = "Computer"
        }
        
        // set player one symbols
        if playerOneSymbol == 0 {
            imgs = [UIImage(named: "nought")!, UIImage(named: "cross")!]
        } else {
            imgs = [UIImage(named: "cross")!, UIImage(named: "nought")!]
        }
        
        // set player colors for easy on eyes play
        playerColor = [
            pOneName.textColor,
            pTwoName.textColor
        ]
        
        // set players turn and labelling
        changePlayer()
        
        // set starting playerscores
        playerScores = [ 0,0,0 ]
        
        // change score name labels
        pOneName.text = playerOneName
        pTwoName.text = playerTwoName
        updateScoreUI()
    }
    
    // function to make a move for the computer
    func computersTurn() {
        var opposeCompletion = [Int: Int]() // how much of the pattern he human has completed
        var computerCompletion = [Int: Int]() // how much of the patter the COMPUTER has completed
        
        // check for availability of patterns and if close to winning
        outer: for pattern in 0...(winConditions.count-1) {
            computerCompletion[pattern] = 0
            var flagged = true
            for btn in winConditions[pattern] { // are you able to write in pattern
                if buttons[btn].tag == -1 { flagged = false }
            }
            if flagged == true { continue outer } // quit due to lack of availability to play in pattern
            for btn in winConditions[pattern] { // does pattern contain a computer tag field
                if buttons[btn].tag == 1 {
                    computerCompletion[pattern] = (computerCompletion[pattern]! + 1)
                }
            }
        }
        let sortedComputerCompletion = computerCompletion.sorted(by: { ($0.value) > ($1.value) }) // sort to find patterns of COMPUTER winning occurences
        
        // check for availability of patterns and human completions
        outer: for pattern in 0...(winConditions.count-1) {
            opposeCompletion[pattern] = 0
            var flagged = true
            for btn in winConditions[pattern] { // are you able to write in pattern
                if buttons[btn].tag == -1 { flagged = false }
            }
            if flagged == true { continue outer } // quit due to lack of availability to play in pattern
            for btn in winConditions[pattern] { // does pattern contain an opposition field
                if buttons[btn].tag == 0 {
                    opposeCompletion[pattern] = (opposeCompletion[pattern]! + 1)
                }
            }
        }
        
        let sortedOpposeCompletion = opposeCompletion.sorted(by: { ($0.value) > ($1.value) }) // sort to find pattern of HUMANS best occurences
        
        // get best available pattern
        var chosenPattern = [Int]()
        if sortedOpposeCompletion.first?.value != nil && sortedComputerCompletion.first?.value != nil{ // if both players have occurences in match
            if sortedOpposeCompletion.first!.value >= sortedComputerCompletion.first!.value { // if human is doing equal or better then computer in best occurence of both players
                chosenPattern = winConditions[(sortedOpposeCompletion.first?.key)!] // fight against player occurences
            } else {
                chosenPattern = winConditions[(sortedComputerCompletion.first?.key)!] // else go for computers best pattern for the win
            }
        } else {
            chosenPattern = winConditions[(sortedOpposeCompletion.first?.key)!] // by defualt, fight humans best occurence
        }
        
        // iterate through pattern for first spot of availability
        for btn in chosenPattern {
            if buttons[btn].tag == -1 {
                clickButton(buttons[btn])   // play the available button
                return // end computer side function
            }
        }
    }
    
    func clickButton(_ btn: UIButton) {
        btn.setImage(imgs[playerTurn], for: .normal)  // change image
        btn.tag = playerTurn                          // set button tag
        btn.backgroundColor = playerColor[playerTurn] // set background of image to players color
        
        // check each button event if move was game terminating or not
        let wldResult = winLossDrawCheck()
        if( wldResult.termType == GameTermination.null ) {
            changePlayer() // change players turn
        }
        else
        {
            // disable buttons due to game termination
            for btn in buttons {
                btn.isEnabled = false
            }
            updateScoreUI() // update score in the ui
            pStatusText(statusText: wldResult.descText, color: wldResult.color, gameEnum: wldResult.termType ) // set status label
            playAgain.isHidden = false
        }
    }
    
    // get best buttons for computer
    func getAvailableButtonList() {
        
    }
    
    // change players turn
    func changePlayer() {
        // set player turn rotations
        if playerTurn == 0
        { playerTurn = 1 }
        else
        { playerTurn = 0 }
        
        // change label text for player turn
        if playerTurn == 0 {
            pStatusText(statusText: "\(playerOneName)'s Turn", color: playerColor[playerTurn])
        } else {
            pStatusText(statusText: "\(playerTwoName)'s Turn", color: playerColor[playerTurn])
        }
    }
    
    // update history ledger
    func updateHistory(winner: Int) {
        let totalGames = playerScores[0] + playerScores[1] + playerScores[2]
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        if winner != -1 {
            imageView.image = imgs[winner]
            imageView.backgroundColor = playerColor[winner]
        } else {
            imageView.image = drawImg
            imageView.backgroundColor = UIColor.yellow
        }
        let xPosition = (self.svHistory.frame.height * CGFloat(totalGames - 1))
        imageView.frame = CGRect(x: xPosition, y: 0, width: self.svHistory.frame.height, height: self.svHistory.frame.height)
        svHistory.contentSize.width = svHistory.frame.height * CGFloat(totalGames)
        svHistory.addSubview(imageView)
    }
    
    // IBACTIONS
    @IBAction func buttonTouched(_ sender: UIButton) { // Gameplay button click event
        // if button has been clicked prior, then escape further action
        if singlePlayer == true && playerTurn == 1 { return } // computers turn
        if sender.tag != -1 { return }
        
        sender.setImage(imgs[playerTurn], for: .normal)  // change image
        sender.tag = playerTurn                          // set button tag
        sender.backgroundColor = playerColor[playerTurn] // set background of image to players color
        
        // check each button event if move was game terminating or not
        let wldResult = winLossDrawCheck()
        if( wldResult.termType == GameTermination.null ) {
            changePlayer() // change players turn
            if singlePlayer == true && playerTurn == 1 {
                computersTurn()
            } // computers turn
        }
        else
        {
            // disable buttons due to game termination
            for btn in buttons {
                btn.isEnabled = false
            }
            updateScoreUI() // update score in the ui
            pStatusText(statusText: wldResult.descText, color: wldResult.color, gameEnum: wldResult.termType ) // set status label
            playAgain.isHidden = false
        }
    }
    
    @IBAction func btnPlayAgain(_ sender: UIButton) {
        for btn in buttons {
            btn.setImage(nil, for: .normal) // reset grid images
            btn.isEnabled = true            // re-enable buttons
            btn.tag = -1                    // reset button tags to untouched tag
            btn.backgroundColor = nil       // reset btn background color
        }
        changePlayer() // change players turn
        pStatus.backgroundColor = nil
        playAgain.isHidden = true
    }
    
    @IBAction func ResetGame(_ sender: UIButton) {
        for btn in buttons {
            btn.setImage(nil, for: .normal) // reset grid images
            btn.isEnabled = true            // re-enable buttons
            btn.tag = -1                    // reset button tags to untouched tag
            btn.backgroundColor = nil       // reset btn background color
        }
        pStatus.backgroundColor = nil
        playAgain.isHidden = true
        initGame()
        for subview in svHistory.subviews { subview.removeFromSuperview() } // remove contents of svhistory
    }
    
    @IBAction func musicOnOff(_ sender: UIButton) {
        // if music is on
        if musicButton.tag == 1 {
            // start background music
            SKTAudio.sharedInstance().pauseBackgroundMusic()
            musicButton.tag = 0 // change tag accordingly
        } else {
            // start background music
            SKTAudio.sharedInstance().playBackgroundMusic()
            musicButton.tag = 1 // change tag accordingly
        }
        musicButton.setBackgroundImage(imgMusic[musicButton.tag], for: UIControlState.normal) // set button image
    }
}



