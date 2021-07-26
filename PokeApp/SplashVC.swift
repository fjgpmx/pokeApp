//
//  SplashVC.swift
//  PokeApp
//
//  Created by Francisco Garcia on 21/07/21.
//

import UIKit

public class SplashVC: UIViewController {
    
    // MARK: VAIABLES
    
    // MARK: CONSTANTS
    private let userDefualts = UserDefaults()
    private var flag = 0
    
    // MARK: OUTLETS
    @IBOutlet weak var lblTittle: UILabel!
    @IBOutlet weak var imgSplash: UIImageView!
    
    
    // MARK: LIFECYCLE
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if (userDefualts.integer(forKey: "FlagSplash") != 0) {
            flag = 1
        } else {
            flag = 0
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if (flag != 0) {
            UI(on: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let resultViewController = storyBoard.instantiateViewController(withIdentifier: "NavigationVC") as! UINavigationController
                self.present(resultViewController, animated:true, completion:nil)
            }
            
        } else {
            UI(on: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
                self.userDefualts.set(1, forKey: "FlagSplash")
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let resultViewController = storyBoard.instantiateViewController(withIdentifier: "NavigationVC") as! UINavigationController
                self.present(resultViewController, animated:true, completion:nil)
            }
        }
    }
    
    // MARK: METHODS
    public func UI(on: Bool) {
        lblTittle.isHidden = (on == true) ? false : true
        imgSplash.isHidden = (on == true) ? false : true
        view.backgroundColor = (on == true) ? (UIColor.white) : (UIColor.black)
    }
}
