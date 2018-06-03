//
//  MainMenyVC.swift
//  Tic Tac Toe 4x4
//
//  Created by George Kolecsanyi on 12/4/18.
//  Copyright © 2018 Deakin. All rights reserved.
//

import UIKit

class MainMenuVC: UIViewController {
    
    // IBOUTLETS
    @IBOutlet weak var spVal: UISwitch!
    @IBOutlet weak var musicButton: UIButton!
    
    // VARS
    var imgMusic : [UIImage] = [ // array of image names for music on/off
        UIImage(named: "music-off")!,
        UIImage(named: "music-on")!
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // set music icon to on
        musicButton.setBackgroundImage(imgMusic[1], for: .normal)
        
        // start background music
        SKTAudio.sharedInstance().playBackgroundMusic()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    // prepare data passing between view controllers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is PlayerSetupVC
        {
            // pass data to setup view controller
            let vc = segue.destination as? PlayerSetupVC
            if spVal.isOn {
                vc?.singlePlayer = true
            } else
            {
                vc?.singlePlayer = false
            }
        } else if segue.destination is ViewController
        {
            // pass data to setup view controller
            let vc = segue.destination as? ViewController
            if spVal.isOn {
                vc?.singlePlayer = true
            } else
            {
                vc?.singlePlayer = false
            }
        }
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
