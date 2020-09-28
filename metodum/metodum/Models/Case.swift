//
//  Case.swift
//  metodum
//
//  Created by Gonzalo Ivan Santos Portales on 25/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import Foundation

class Case {
    var caseTitle: String
    var caseSubtitle: String
    var caseImage: String
    var aboutCase: String
    var caseResult: String
    
    init(caseTitle: String, caseSubtitle: String, caseImage: String, aboutCase: String, caseResult: String) {
        self.caseTitle = caseTitle
        self.caseSubtitle = caseSubtitle
        self.caseImage = caseImage
        self.aboutCase = aboutCase
        self.caseResult = caseResult
    }
    
    static func fromJson(json: [String:Any]) -> Case {
        return Case(
            caseTitle: json["caseTitle"] as! String,
            caseSubtitle: json["caseSubtitle"] as! String,
            caseImage: json["caseImage"] as! String,
            aboutCase: json["aboutCase"] as! String,
            caseResult: json["caseResult"] as! String
        )
    }
    
    func toJson() -> [String:Any] {
        return [
            "caseTitle": self.caseTitle,
            "caseSubtitle": self.caseSubtitle,
            "caseImage": self.caseImage,
            "aboutCase": self.aboutCase,
            "caseResult": self.caseResult,
        ]
    }
}

extension Case {
    public static let caseList = [
        Case(
            caseTitle: "FIAP School",
            caseSubtitle: "Manaus, Brasil",
            caseImage: "foto3",
            aboutCase: "A FIAP School aplica uma linha de aprendizagem construcionista, baseada no Digital Learning. Trata-se da combinação de várias metodologias ativas de aprendizado – tais como Peer Instruction (Instrução de Pares), Case Based Learning, Team Learning, Problem Based Learning, Project Based Learning e Game Challenge Based Learning. Uma linha que estimula a construção do conhecimento baseada na realização de ações concretas que envolvem construção de coisas: arte, textos, objetos, protótipos, aplicativos, robôs, startups; construção interior: aprendizagem e desenvolvimento pessoal. Os conteúdos básicos do currículo escolar são ensinados por meio do Project Based Learning. Combinados a ele, os alunos recebem conteúdos de sete novas esferas de conhecimento: Art & Crafts, Creative Thinking, Life, Business, Digital Life, Tech e Maker. O objetivo é que essas esferas de conhecimento possam contribuir para o futuro dos alunos, não importa a profissão que escolherem.",
            caseResult:  "As primeiras gerações que já nasceram com a internet. Aprenderam a usar a internet muito cedo. As redes sociais fazem parte do seu cotidiano e estar sempre conectado está nos seus contextos diários. Esses jovens se desenvolveram com um modelo mental diferente. As sinapses aconteceram de forma diferente em relação às gerações analógicas, nascidas antes da internet."),
        Case(
            caseTitle: "NEI - Fundação Romi",
            caseSubtitle: "Santa Bárbara d'Oeste, Brasil",
            caseImage: "foto4",
            aboutCase: "O NEI - Núcleo de Educação Integrada - Fundação Romi, divide em grupos, os alunos do Núcleo de Educação Integrada são desafiados a buscarem o conhecimento por meio de projetos propostos pelos educadores e por centro de interesse que atuam como estimuladores das atividades pedagógicas e construção do conhecimento. O aluno, de forma ativa e proativa, busca e consolida seu próprio conhecimento a partir da sua vivência prévia, da pesquisa, da partilha entre pares e com seu professor, descaracterizando desta forma, uma visão conteudista e cumulativa do conhecimento.",
            caseResult:  "O NEI trabalha por meio de uma metodologia dinâmica, com a participação efetiva dos alunos no processo de construção do conhecimento. Os educadores inserem esses jovens adolescentes nos novos espaços, às novas rotinas globais, às novas regras sociais, expandido suas mentes para uma nova e moderna educação contribui para seu sucesso futuro."),
    ]
}
