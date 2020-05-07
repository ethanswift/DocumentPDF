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
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.926155746, green: 0.9410773516, blue: 0.9455420375, alpha: 1)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.cameraCaptureMode = .photo
        if segmentControl == false {
           imagePicker.allowsEditing = false
            presentAlert()
        } else {
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }


        // Do any additional setup after loading the view.
    }
    
    func presentAlert () {
        let alert = UIAlertController(title: "Camera Orientation", message: "In Order To Capture Most Accurately, Your Camera Shouldn't Have Angle With The Document. Slanted Document Pictures Usually Results In Incomplete Images.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if self.segmentControl == false {
            if var originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
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
            }
 
//        if resultImage == nil {
//            print("Error; No image has been found")
//        } else if resultImage != nil {
//            self.imageView.image = resultImage
////            performSegue(withIdentifier: "goToPDF", sender: self)
//        }
            
        } else if self.segmentControl == true {
            if var editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
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
            if let results = request.results as? [VNRectangleObservation] {
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
      
                let xCor: CGFloat = result.boundingBox.minX * image.extent.width
                let yCor: CGFloat = result.boundingBox.minY * image.extent.height
                let width: CGFloat = (result.boundingBox.width) * image.extent.width
                let height: CGFloat = (result.boundingBox.height) * image.extent.height

                let rect = CGRect(x: xCor, y: yCor, width: width, height: height)
                //            var rect = CGRect()
                //            rect.origin.x = (self.view.frame.size.width) * result.boundingBox.origin.y
                //            rect.origin.y = (self.view.frame.size.height) * result.boundingBox.origin.x
                //            rect.size.height = (self.view.frame.size.height) * result.boundingBox.width
                //            rect.size.width = (self.view.frame.size.width) * result.boundingBox.height
                
//                                let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -self.imageView.bounds.height).scaledBy(x: self.imageView.bounds.width, y: self.imageView.bounds.height)
                    
                            if self.imageView.image?.imageOrientation == .up || self.imageView.image?.imageOrientation == .upMirrored {
                                print("Image Orientation up")
                            } else if self.imageView.image?.imageOrientation == .leftMirrored || self.imageView.image?.imageOrientation == .left {
                                print("Image Orientation Left Mirrored")
                            } else if self.imageView.image?.imageOrientation == .right || self.imageView.image?.imageOrientation == .rightMirrored {
                                print("Image Orientation right")
                            } else if self.imageView.image?.imageOrientation == .down || self.imageView.image?.imageOrientation == .downMirrored {
                                print("Image Orientation Down")
                            }
                  finalImage = self.cropImage(image: self.imageView.image!, rect: rect)

                    self.imageView.image = finalImage
                }
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
            if let vc = segue.destination as? PDFViewController {
                if self.segmentControl == false {
                        vc.resultImage = self.resultImage
                    } else {
                        vc.resultImage = self.resultImage
                    }
            }
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
