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
    
    return """
<!DOCTYPE html><html lang=\"pt-br\">
    <head>
        <meta charset=\"UTF-8\">
        <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
        <meta http-equiv=\"X-UA-Compatible\" content=\"ie=edge\">
        <title>Metodum</title>
    </head>
    <body>
        <p><h1>\(methodObject.name)</h1></p>
        <p><h2>Sobre</h2></p>
        \(methodObject.description)
        <p><h2>Como Aplicar</h2></p>
        \(methodObject.description)
    </body>
</html>
"""

}
