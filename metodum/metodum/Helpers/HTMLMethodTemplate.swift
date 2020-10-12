//
//  HTMLMethodTemplate.swift
//  metodum
//
//  Created by João Guilherme on 05/10/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import Foundation

func HtmlMethodTemplate(selectedMethod: Methodology) -> String {
    
    let methodObject = selectedMethod
    let language = Locale.current.languageCode
    let name = (language == "pt") ? methodObject.name_pt : methodObject.name_en
    let about = (language == "pt") ? methodObject.about_pt : methodObject.about_en
    let howToApply = (language == "pt") ? methodObject.howToApply_pt : methodObject.howToApply_en
    
    let labelAbout = (language == "pt") ? "Sobre" : "About"
    let labelHowToApply = (language == "pt") ? "Como Aplicar" : "How to Apply"
    
    return """
<!DOCTYPE html><html lang=\"pt-br\">
    <head>
        <meta charset=\"UTF-8\">
        <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
        <meta http-equiv=\"X-UA-Compatible\" content=\"ie=edge\">
        <title>Metodum</title>
    </head>
    <body>
        <p><h1>\(name)</h1></p>
        <p><h2>\(labelAbout)</h2></p>
        \(about)
        <p><h2>\(labelHowToApply)</h2></p>
        \(howToApply)
    </body>
</html>
"""

}
