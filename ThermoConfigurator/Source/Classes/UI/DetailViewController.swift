//
//  DetailViewController.swift
//  ThermoConfigurator
//
//  Created by Thomas Bonk on 20.03.20.
//  Copyright © 2020 Thomas Bonk. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    /// MARK: - Properties

    var detailItem: NetService? {
        didSet {
            // Update the view.
            configureView()
        }
    }


    /// MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }


    /// MARK: - Show Data

    func configureView() {

    }
}

