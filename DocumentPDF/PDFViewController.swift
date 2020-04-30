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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.backgroundColor = #colorLiteral(red: 0.926155746, green: 0.9410773516, blue: 0.9455420375, alpha: 1)
        
        self.view.backgroundColor = #colorLiteral(red: 0.926155746, green: 0.9410773516, blue: 0.9455420375, alpha: 1)
        
         presentAlert()
        
        // Do any additional setup after loading the view.
    }
    
    func presentAlert () {
        let alert = UIAlertController(title: "File Name", message: "Choose A Name For Your File", preferredStyle: .actionSheet)
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
        if self.resultImage != nil {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let pdfFileName = self.pdfFileName
            let pdfURL = documentDirectory?.appendingPathComponent(pdfFileName)
            let pdf = PDFDocument(data: (resultImage?.jpegData(compressionQuality: 1))!)
            pdf?.write(to: pdfURL!)
            self.webView.load(URLRequest(url: pdfURL!))
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
