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
    
    @IBOutlet weak var cameraButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cameraPressed(_ sender: UIButton) {
        self.imagePicker.takePicture()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as! CIImage
        resultImage = rectDetection(image: image)
        if resultImage != nil {
            performSegue(withIdentifier: "goToPDF", sender: self)
        }
        imagePicker.dismiss(animated: true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func rectDetection (image: CIImage) -> UIImage {
        
        var finalImage: UIImage?
        
        let imageHandler = VNImageRequestHandler(ciImage: image, options: [:])
        
        let rectangleRequest = VNDetectRectanglesRequest { (request, error) in
            if error != nil {}
            let results = request.results as! [VNRectangleObservation]
            let rec = CGRect(origin: (results.first?.topLeft)!, size: CGSize(width: ((results.first?.topRight.x)! - (results.first?.topLeft.x)!) , height: ((results.first?.topLeft.y)! - (results.first?.bottomLeft.y)!)))
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
