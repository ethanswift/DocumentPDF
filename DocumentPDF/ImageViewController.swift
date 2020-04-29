//
//  ImageViewController.swift
//  DocumentPDF
//
//  Created by ehsan sat on 4/28/20.
//  Copyright © 2020 ehsan sat. All rights reserved.
//

import UIKit
import Vision

class ImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false

        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as! CIImage
//        imagePicker.dismiss(animated: true, completion: nil) ??

    }
    
    func rectDetection (image: CIImage) -> String {
        
        let rectangleRequest = VNDetectRectanglesRequest { (request, error) in
            let results = request.results as! [VNRectangleObservation]
            
        }
        let imageHandler = VNImageRequestHandler(ciImage: image, options: [:])
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
