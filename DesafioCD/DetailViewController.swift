//
//  DetailViewController.swift
//  DesafioCD
//
//  Created by ios7126 on 9/19/17.
//  Copyright © 2017 Caelum. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                let dateFormatter: DateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss"
                let dtHora = dateFormatter.string(from: detail.timestamp! as Date)

                label.text = detail.device!.description + ", " + dtHora
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Event? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }


}

