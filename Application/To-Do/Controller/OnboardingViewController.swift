//
//  OnboardingViewController.swift
//  To-Do
//
//  Created by Abraao Levi on 03/10/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    let userDefaultsKey = "already_shown_onboarding"
    
    @IBOutlet weak var nextButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func alreadyShown() -> Bool {
        return UserDefaults.standard.bool(forKey: userDefaultsKey)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        markAsSeen()
        dismiss(animated: true)
    }
    
    private func markAsSeen() {
        UserDefaults.standard.set(true, forKey: userDefaultsKey)
    }

    fileprivate func setupViews() {
        nextButton.layer.cornerRadius = 10
        nextButton.clipsToBounds = true
    }

}
