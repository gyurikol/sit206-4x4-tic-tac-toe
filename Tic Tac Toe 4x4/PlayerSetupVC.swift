//
//  PlayerSetupVC.swift
//  Tic Tac Toe 4x4
//
//  Created by George Kolecsanyi on 12/4/18.
//  Copyright © 2018 Deakin. All rights reserved.
//

import UIKit

class PlayerSetupVC: UIViewController {
    
    // IBOUTLETS
    @IBOutlet weak var pOneNameText: UITextField!
    @IBOutlet weak var pTwoTitle: UILabel!
    @IBOutlet weak var pTwoNameTitle: UILabel!
    @IBOutlet weak var pTwoNameText: UITextField!
    @IBOutlet weak var pOneSymbol: UISwitch!
    @IBOutlet weak var setupNavBar: UINavigationBar!
    @IBOutlet weak var setupNavItem: UINavigationItem!
    @IBOutlet weak var musicButton: UIButton!
    
    // VARS
    var singlePlayer = false
    var imgMusic : [UIImage] = [ // array of image names for music on/off
        UIImage(named: "music-off")!,
        UIImage(named: "music-on")!
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // if single player then hide player 2 ui elements
        if singlePlayer == true
        {
            pTwoTitle.isHidden = true
            pTwoNameTitle.isHidden = true
            pTwoNameText.isHidden = true
        }
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
    
    // prepare for data passing between view controllers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is ViewController
        {
            // pass data accross to view controllers
            let vc = segue.destination as? ViewController
            vc?.playerOneName = (self.pOneNameText.text?.capitalized)!
            vc?.playerTwoName = (self.pTwoNameText.text?.capitalized)!
            vc?.singlePlayer = self.singlePlayer
            if !pOneSymbol.isOn
            { vc?.playerOneSymbol = 0 }
            else
            { vc?.playerOneSymbol = 1 }
        }
    }
    
    @IBAction func musicOnOff(_ sender: Any) {
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
