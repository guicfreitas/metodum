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
    let language = Locale.current.languageCode
    let title = (language == "pt") ? caseObject.title_pt : caseObject.title_en
    let about = (language == "pt") ? caseObject.about_pt : caseObject.about_en
    let result = (language == "pt") ? caseObject.result_pt : caseObject.result_en
    
    let labelAbout = (language == "pt") ? "Sobre" : "About"
    let labelResults = (language == "pt") ? "Resultados" : "Results"
    return """
<!DOCTYPE html><html lang=\"pt-br\">
    <head>
        <meta charset=\"UTF-8\">
        <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
        <meta http-equiv=\"X-UA-Compatible\" content=\"ie=edge\">
        <title>Metodum</title>
    </head>
    <body topmargin=95 leftmargin=54 rightmargin=54 bottommargin=95>
        <p><h1>\(title)</h1></p>
        <p><h2>\(labelAbout)</h2></p>
        \(about)
        <p><h2>\(labelResults)</h2></p>
        \(result)
    </body>
</html>
"""

}
