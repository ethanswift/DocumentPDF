//
//  PDFViewController.swift
//  DocumentPDF
//
//  Created by ehsan sat on 4/29/20.
//  Copyright © 2020 ehsan sat. All rights reserved.
//

import UIKit
import PDFKit
import WebKit

class PDFViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    var resultImage: UIImage?
    
    var pdfFileName: String = ""
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if resultImage != nil {
            print(resultImage!.pngData()!)
        } else {
            print("Result Image is empty!")
        }

        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.backgroundColor = #colorLiteral(red: 0.926155746, green: 0.9410773516, blue: 0.9455420375, alpha: 1)
        
        self.view.backgroundColor = #colorLiteral(red: 0.926155746, green: 0.9410773516, blue: 0.9455420375, alpha: 1)
        
        self.imageView.image = self.resultImage
        
         presentAlert()
        
        // Do any additional setup after loading the view.
    }
    
    func presentAlert () {
        let alert = UIAlertController(title: "File Name", message: "Choose A Name For Your File", preferredStyle: .alert)
        alert.addTextField { (textFiled) in
            textFiled.placeholder = "Name"
            self.pdfFileName = textFiled.text!
            self.navigationController?.title = textFiled.text!
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (alertAction) in
            self.savePDF()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alertAction) in
            self.webView.isHidden = true
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func savePDF () {
        if self.resultImage == nil {
            print("No Image Has been recieved!")
        }
        if self.resultImage != nil {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            print(documentDirectory!)
            let pdfFileName = self.pdfFileName
            print(self.pdfFileName)
            let pdfURL = documentDirectory?.appendingPathComponent("\(self.pdfFileName).pdf")
            print(pdfURL!)
            let pdf = PDFDocument()
            let pdfPage = PDFPage(image: resultImage!)
            pdf.insert(pdfPage!, at: 0)
            let pdfData = pdf.dataRepresentation()
            do {
                try pdfData?.write(to: pdfURL!)
            } catch {
                fatalError("Error!! writing data")
            }
//            let pdf = PDFDocument(data: (resultImage?.jpegData(compressionQuality: 1)?.base64EncodedData())!)
//            //(resultImage?.jpegData(compressionQuality: 1))!
//            print(pdf)
//            pdf?.write(to: pdfURL!)
            if pdfData != nil {
                print(pdfData!, "PDF Data available")
                print(pdfURL!)
                self.webView.load(pdfData!, mimeType: "application/pdf", characterEncodingName: "utf-8", baseURL: pdfURL!)
                    self.view.addSubview(webView)
               
            }
        }
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
