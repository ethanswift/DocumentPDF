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
        
        navigationController?.delegate = self
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        imagePicker.cameraCaptureMode = .photo
        imagePicker.cameraDevice = .rear
//        imagePicker.cameraOverlayView =

        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cameraNavPressed(_ sender: UIBarButtonItem) {
         self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         var originalImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imagePicker.dismiss(animated: true, completion: nil)
        if originalImage == nil { print("Error Not Found An Image")}
            imageView.contentMode = .scaleAspectFit
            imageView.backgroundColor = UIColor.lightGray
        originalImage = UIImage(cgImage: originalImage.cgImage!, scale: originalImage.scale, orientation: .up)
            imageView.image = originalImage
//        let croppedImage = cropImage(image: originalImage, rect: CGRect(x: 0, y: 0, width: 2141, height: 2650))
//        imageView.image = croppedImage
        if let originalImageCI = CIImage(image: originalImage) {
            resultImage = rectDetection(image: originalImageCI)
            self.imageView.image = resultImage
        }
//        if resultImage == nil {
//            print("Error; No image has been found")
//        } else if resultImage != nil {
//            self.imageView.image = resultImage
////            performSegue(withIdentifier: "goToPDF", sender: self)
//        }
        
    }
    
//    func fixOrientation (image: UIImage) -> UIImage {
//
//        var transformOrient = CGAffineTransform.identity
//
//        if self.imageView.image?.imageOrientation == .up || self.imageView.image?.imageOrientation == .upMirrored {
//            print("Image Orientation up")
//        } else if self.imageView.image?.imageOrientation == .leftMirrored || self.imageView.image?.imageOrientation == .left {
//            print("Image Orientation Left Mirrored")
//        } else if self.imageView.image?.imageOrientation == .right || self.imageView.image?.imageOrientation == .rightMirrored{
//            transformOrient = transformOrient.translatedBy(x: 0, y: self.imageView.bounds.width)
//            transformOrient = transformOrient.rotated(by: CGFloat(-Double.pi/2.0))
//            image.
//            print("Image Orientation right")
//        } else if self.imageView.image?.imageOrientation == .down || self.imageView.image?.imageOrientation == .downMirrored {
//            print("Image Orientation Down")
//        }
//        return
//    }
    
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
            print(results)
            if results == nil {
                print("No results was found")
            }
            for result in results {
                print("results received: ", result)
            }
            guard let result = results.first else {
                // alert
                print(error?.localizedDescription, "No Results Was Found!")
                return
            }
//            let imageFrame = self.imageView.bounds
//            let imageSize = CGSize(width: result.boundingBox.width * imageFrame.width, height: result.boundingBox.height * imageFrame.height)
//            let point = CGPoint(x: result.boundingBox.minX * imageFrame.width , y: (1 - result.boundingBox.minY) * imageFrame.height - imageSize.height )
//            let rectang = CGRect(origin: point, size: imageSize)
//            print(rectang)
//            let rectan = VNNormalizedRectForImageRect(image.extent, Int(exactly: image.extent.width)!, Int(exactly: image.extent.height)!)
//
//            print("Image: ", rectan)
//
//            let rectang = VNImageRectForNormalizedRect(image.extent, Int(exactly: image.extent.width)!, Int(exactly: image.extent.height)!)
//
//            print("Bounding Box: ", rectang)
            
            let rect = CGRect(x: result.topLeft.x * image.extent.width , y:image.extent.height - (result.topLeft.y * image.extent.height), width: (result.bottomRight.x - result.bottomLeft.x ) * image.extent.width  , height: (result.topRight.y - result.bottomRight.y ) * image.extent.height  )

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

//            let translate = CGAffineTransform.identity.scaledBy(x: self.view.frame.width, y: self.view.frame.height)
//
//            let resultBoundsRect = result.boundingBox.applying(transform)
//
//            print("result rect: ", resultBoundsRect)
            
            print(result.topLeft)
            print(result.topRight)
            print(result.bottomLeft)
            print(result.bottomRight)
            print(result.boundingBox)
            
//            let size = self.imageView.image?.size
//            let rect = CGRect(x: (size?.width)! * result.topLeft.x, y: (size?.width)! * result.bottomLeft.y, width: (size?.width)! * result.boundingBox.width, height: (size?.width)! * result.boundingBox.height)
//            print(rect)
            finalImage = self.cropImage(image: self.imageView.image!, rect: rect)
            self.imageView.image = finalImage
//            let rec = CGRect(origin: (result.topLeft), size: CGSize(width: ((result.topRight.x) - (result.topLeft.x)) , height: ((result.topLeft.y) - (result.bottomLeft.y))))
//            finalImage = self.imageView.image
        }
        
        do {
            try imageHandler.perform([rectangleRequest])
        } catch {
            print(error)
        }
        return finalImage!
    }
    
    
    
    func cropImage (image: UIImage, rect: CGRect) -> UIImage {
//
//        print("width: ", image.size.width, "height: ",  image.size.height)
//        print(rect)
        let resImage = CIImage(image: image, options: [:])
        var ciRect = rect
        ciRect.origin.y = (resImage?.extent.height)! - ciRect.origin.y - ciRect.height
        let croppedImage = resImage?.cropped(to: rect)
        let img = UIImage(ciImage: croppedImage!, scale: 1, orientation: image.imageOrientation)

        return img
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
