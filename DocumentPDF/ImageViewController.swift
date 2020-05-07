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
    
    var segmentControl: Bool = false
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        if segmentControl == false {
           imagePicker.allowsEditing = false
        } else {
            imagePicker.allowsEditing = true
        }
        imagePicker.cameraCaptureMode = .photo
//        imagePicker.cameraDevice = .rear
        
          self.present(imagePicker, animated: true, completion: nil)

        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if self.segmentControl == false {
            var originalImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            imagePicker.dismiss(animated: true, completion: nil)
            if originalImage == nil { print("Error Not Found An Image")}
            imageView.contentMode = .scaleAspectFit
            imageView.backgroundColor = UIColor.lightGray
//            originalImage = UIImage(cgImage: originalImage.cgImage!, scale: originalImage.scale, orientation: .up)
            imageView.image = originalImage
            if let originalImageCI = CIImage(image: originalImage) {
                self.resultImage = rectDetection(image: originalImageCI)
                self.imageView.image = resultImage
            }
//        if resultImage == nil {
//            print("Error; No image has been found")
//        } else if resultImage != nil {
//            self.imageView.image = resultImage
////            performSegue(withIdentifier: "goToPDF", sender: self)
//        }
            
        } else if self.segmentControl == true {
            var editedImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
            imagePicker.dismiss(animated: true, completion: nil)
            if editedImage == nil { print("Error Not Found An Image")} else {
                self.imageView.contentMode = .scaleAspectFit
                self.imageView.backgroundColor = UIColor.lightGray
//            editedImage = UIImage(cgImage: originalImage.cgImage!, scale: originalImage.scale, orientation: .up)
                self.imageView.image = editedImage
                self.resultImage = editedImage
                if self.resultImage != nil {
                  performSegue(withIdentifier: "goToPDF", sender: self)
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func rectDetection (image: CIImage) -> UIImage {
        
        var finalImage: UIImage?
        
        let imageHandler = VNImageRequestHandler(ciImage: image, orientation: .up, options: [:])
        
        let rectangleRequest = VNDetectRectanglesRequest { (request, error) in
            if error != nil {
                print(error?.localizedDescription)
            }
            let results = request.results as! [VNRectangleObservation]
            print(results)
            if results == [] {
                print("No results was found")
            }
            // if resutls more than one ??? what to do
//            for result in results {
//                print("results received: ", result)
//            }
            guard let result = results.first else {
                // alert
                print(error!.localizedDescription, "No Results Was Found!")
                return
            }

            let rect = CGRect(x: CGFloat(result.boundingBox.minX * image.extent.width), y: CGFloat(result.boundingBox.minY * image.extent.height), width: CGFloat((result.boundingBox.width) * image.extent.width) , height: CGFloat((result.boundingBox.height) * image.extent.height))
            
            print("Min, mid max X:", result.boundingBox.minX, result.boundingBox.midX, result.boundingBox.maxX)
            print("Min, Mid, Max Y: ", result.boundingBox.minY, result.boundingBox.midY, result.boundingBox.maxY)

//            var rect = CGRect()
//            rect.origin.x = (self.view.frame.size.width) * result.boundingBox.origin.y
//            rect.origin.y = (self.view.frame.size.height) * result.boundingBox.origin.x
//            rect.size.height = (self.view.frame.size.height) * result.boundingBox.width
//            rect.size.width = (self.view.frame.size.width) * result.boundingBox.height

            print("Rect: ", rect)
            print("Image: ", image.extent)
            print("Bounding Box: ", result.boundingBox)
            
                let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -self.imageView.bounds.height).scaledBy(x: self.imageView.bounds.width, y: self.imageView.bounds.height)
            
            if self.imageView.image?.imageOrientation == .up || self.imageView.image?.imageOrientation == .upMirrored {
                print("Image Orientation up")
            } else if self.imageView.image?.imageOrientation == .leftMirrored || self.imageView.image?.imageOrientation == .left {
                print("Image Orientation Left Mirrored")
            } else if self.imageView.image?.imageOrientation == .right || self.imageView.image?.imageOrientation == .rightMirrored{
                print("Image Orientation right")
            } else if self.imageView.image?.imageOrientation == .down || self.imageView.image?.imageOrientation == .downMirrored {
                print("Image Orientation Down")
            }

            print(result.topLeft)
            print(result.topRight)
            print(result.bottomLeft)
            print(result.bottomRight)
            print(result.boundingBox)
            
            finalImage = self.cropImage(image: self.imageView.image!, rect: rect)

            self.imageView.image = finalImage
        }
        
        do {
            try imageHandler.perform([rectangleRequest])
        } catch {
            print(error)
        }
        return finalImage!
    }

    func cropImage (image: UIImage, rect: CGRect) -> UIImage {

        let resImage = CIImage(image: image, options: [:])

        let croppedImage = resImage?.cropped(to: rect)
        let img = UIImage(ciImage: croppedImage!, scale: image.scale, orientation: image.imageOrientation)

        return img
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPDF" {
            let vc = segue.destination as! PDFViewController
            if self.segmentControl == false {
                vc.resultImage = self.resultImage
            } else {
                vc.resultImage = self.resultImage
            }
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
