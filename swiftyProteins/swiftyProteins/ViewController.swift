//
//  ViewController.swift
//  swiftyProteins
//
//  Created by Yaroslava HLIBOCHKO on 7/17/19.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
   
    @IBOutlet weak var loginTouchIDButton: UIButton!
    @IBOutlet weak var loginFaceIDButton: UIButton!
    let context = LAContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            if context.biometryType == .faceID {
                loginTouchIDButton.removeFromSuperview()
                loginFaceIDButton.layer.cornerRadius = 5
            } else {
                loginFaceIDButton.removeFromSuperview()
                loginTouchIDButton.layer.cornerRadius = 5
            }
        }
    }
    
    
    @IBAction func loginButton(_ sender: UIButton) {
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "You need to be authenticate") {succes,error in
            if succes {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "authenticateSucces", sender: "Foo")
                }
            } else {
                print(error)
            }
        }
    }

    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true)
    }
}

