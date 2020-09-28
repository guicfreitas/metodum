//
//  HTMLTemplate.swift
//  metodum
//
//  Created by Radija Praia on 27/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import Foundation


func HtmlTemplate(selectedCase: Case) -> String {
    
    let caseObject = selectedCase
    
    return """
<!DOCTYPE html><html lang=\"pt-br\">
    <head>
        <meta charset=\"UTF-8\">
        <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
        <meta http-equiv=\"X-UA-Compatible\" content=\"ie=edge\">
        <title>Metodum</title>
    </head>
    <body>
        <p><h1>\(caseObject.caseTitle)</h1></p>
        <p><h2>Sobre</h2></p>
        \(caseObject.aboutCase)
        <p><h2>Resultados</h2></p>
        \(caseObject.caseResult)
    </body>
</html>
"""

}
