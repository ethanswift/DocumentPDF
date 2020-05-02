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
    
    var resultImage: UIImage?
    
    
    @IBOutlet weak var cameraButtonNav: UIBarButtonItem!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cameraNavPressed(_ sender: UIBarButtonItem) {
         self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         let originalImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imagePicker.dismiss(animated: true, completion: nil)
        if originalImage == nil { print("Error Not Found An Image")}
            imageView.image = originalImage
        if let originalImageCI = CIImage(image: originalImage) {
            resultImage = rectDetection(image: originalImageCI)
        }
        if resultImage == nil {
            print("Error; No image has been found")
        } else if resultImage != nil {
            performSegue(withIdentifier: "goToPDF", sender: self)
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func rectDetection (image: CIImage) -> UIImage {
        
        var finalImage: UIImage?
        
        let imageHandler = VNImageRequestHandler(ciImage: image, options: [:])
        
        let rectangleRequest = VNDetectRectanglesRequest { (request, error) in
            if error != nil {
                print(error?.localizedDescription)
            }
            let results = request.results as! [VNRectangleObservation]
            guard let result = results.first else {
                // alert
                print(error?.localizedDescription, "No Results Was Found!")
                return
            }
            let rec = CGRect(origin: (result.topLeft), size: CGSize(width: ((result.topRight.x) - (result.topLeft.x)) , height: ((result.topLeft.y) - (result.bottomLeft.y))))
            finalImage = UIImage(cgImage: (image.cgImage?.cropping(to: rec))!)
        }
        
        do {
            try imageHandler.perform([rectangleRequest])
        } catch {
            print(error)
        }
        return finalImage!
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPDF" {
            let vc = segue.destination as! PDFViewController
            vc.resultImage = resultImage
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
