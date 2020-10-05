//
//  ExportPdf.swift
//  metodum
//
//  Created by Radija Praia on 27/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import Foundation
import UIKit

let render = UIPrintPageRenderer()
var pathPdf: URL?

func createPrintFormatter(selectedCase: Case){
    
    let html = HtmlTemplate(selectedCase: selectedCase)
    let fmt = UIMarkupTextPrintFormatter(markupText: html)
    assignPrintFormatter(format: fmt)
}

func createPrintMethodFormatter(selectedMethod: Methodology){
    
    let html = HtmlMethodTemplate(selectedMethod: selectedMethod)
    let fmt = UIMarkupTextPrintFormatter(markupText: html)
    assignPrintFormatter(format: fmt)
}

public func getPathOfPdf() -> URL {
    
    return pathPdf!
    
}

func assignPrintFormatter(format: UIMarkupTextPrintFormatter){
    
    render.addPrintFormatter(format, startingAtPageAt: 0)
    assignRects()
    
}

func assignRects(){
    
    let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dpi
    render.setValue(page, forKey: "paperRect")
    render.setValue(page, forKey: "printableRect")
    createPdfContextAndDraw()
    
}

func createPdfContextAndDraw(){
    
    let pdfData = NSMutableData()
    UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)
    
    for i in 0..<render.numberOfPages{
        UIGraphicsBeginPDFPage()
        render.drawPage(at: i, in: UIGraphicsGetPDFContextBounds())
        
    }
    
    UIGraphicsEndPDFContext()
    savePdfFile(data: pdfData)
    
}

func savePdfFile(data: NSMutableData){
    
    guard let outputURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("cases-to-share").appendingPathExtension("pdf")
    else{
        fatalError("Destination URL not created")
        }
    data.write(to: outputURL, atomically: true)
    pathPdf = outputURL
    print("open \(outputURL.path)")    
}

