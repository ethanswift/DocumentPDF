//
//  InitialViewController.swift
//  DocumentPDF
//
//  Created by ehsan sat on 5/6/20.
//  Copyright © 2020 ehsan sat. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var cameraButton: UIButton!
    
    var segmentControlPass: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
           self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
           self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.926155746, green: 0.9410773516, blue: 0.9455420375, alpha: 1)
           self.navigationController?.navigationBar.prefersLargeTitles = true
        
        cameraButton.layer.cornerRadius = 15
        self.view.backgroundColor = #colorLiteral(red: 0.926155746, green: 0.9410773516, blue: 0.9455420375, alpha: 1)
        self.descriptionLabel.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.
    }
    
    @IBAction func segmentControled(_ sender: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            self.segmentControlPass = true
        case 1:
            self.segmentControlPass = false
        default:
            break
        }
    }
    
    @IBAction func cameraPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "goToImagePicker", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToImagePicker" {
            if let vc = segue.destination as? ImageViewController {
                vc.segmentControl = self.segmentControlPass
            }
            
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
