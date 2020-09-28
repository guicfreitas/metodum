//
//  Case.swift
//  metodum
//
//  Created by Radija Praia on 26/09/20.
//  Copyright © 2020 metodum. All rights reserved.
//

import Foundation
import UIKit

/*class Case {
    var id: Int
    var cases: String
    var caseSubtitle: String
    var caseImage: String
    var aboutTheCases: String
    var resultOfThecases: String
    
    init(id: Int, cases: String, caseSubtitle: String, caseImage: String, aboutTheCases: String, resultOfThecases: String) {
        self.id = id
        self.cases = cases
        self.caseSubtitle = caseSubtitle
        self.caseImage = caseImage
        self.aboutTheCases = aboutTheCases
        self.resultOfThecases = resultOfThecases
    }
}

extension Case {
    public static let caseList = [
        Case(id: 0,
             cases: "Insper",
             caseSubtitle: "São Paulo, Brasil",
             caseImage: "foto1",
             aboutTheCases: "O Insper é uma instituição de ensino superior brasileira que atua nas áreas de Negócios, Economia, Direito, Engenharia Mecânica, Engenharia Mecatrônica e Engenharia da Computação. É bem-conceituada, nacionalmente e internacionalmente. A metodologia ativa aplicada é baseada em problemas. A dinâmica de aprendizagem é pautada em solucionar desafios reais, identificando dilemas e potencializando a tomada de decisão em um contexto que fomenta diversidade de ideias e maior proatividade. O estudante também é estimulado a planejar sua carreira, de maneira autônoma.",
             resultOfThecases: "É a segunda escola de negócios brasileira melhor colocada no ranking de educação executiva do Financial Times, de 2017, aparecendo em 47° lugar. Muito de seus alunos obtiveram excelente resultado no Exame Nacional de Seleção 2020 da ANPEC (Associação Nacional dos Centros de Pós-graduação em Economia) - exame que seleciona candidatos para os cursos mais disputados de mestrado e doutorado em economia no Brasil."),
        Case(id: 1,
             cases: "Escola da Ponte",
             caseSubtitle: "Distrito do Porto, Portugal",
             caseImage: "foto2",
             aboutTheCases: "A Escola Básica da Ponte é instituição pública de ensino com práticas educativas que se afastam do modelo tradicional. Está organizada segundo uma lógica de projeto e de equipe, estruturando-se a partir das interações entre os seus membros. Não existem salas de aula, no sentido tradicional, mas sim espaços de trabalho, onde são disponibilizados diversos recursos, como: livros, dicionários, gramáticas, internet, vídeos, ou seja, várias fontes de conhecimento. Escola da Ponte assiste crianças entre 5 e 13 anos de idade. Em vez de um único professor, os estudantes acessam todos os orientadores educativos, que os acompanham tanto nas questões de aprendizagem acadêmicas quanto comportamentais.",
             resultOfThecases: "Além da autonomia da escola à organização curricular e pedagógica do Ministério, a Escola da Ponte influenciou a aprovação do Decreto de Lei 6/2001, de 18 de janeiro de 2001, sobre a Reorganização Curricular do Ensino Básico, que deu espaço a outros modelos de escolas públicas. Em uma atividade grupos de crianças do núcleo de iniciação Escola da Ponte decidiu investigar como funcionam os sinais de trânsito, para estudar o tema de segurança rodoviária. Depois da pesquisa inicial, saíram todos às ruas para ver “na prática” o que cada uma das placas significa. Como produto, o grupo desenvolveu e jogou um jogo da memória com os símbolos recém descobertos e como tarefa de casa, os estudantes tiveram que ajudar seus familiares e vizinhança a relembrar o significado de cada um deles."),
        Case(id: 2,
             cases: "Projeto Âncora",
             caseSubtitle: "Cotia, Brasil",
             caseImage: "foto3",
             aboutTheCases: "A Escola Projeto Âncora é internacionalmente reconhecida como inovadora, onde alunos de diferentes idades estudam juntos, desenvolvem projetos de pesquisa de acordo com seus interesses e são orientados por professores e pedagogos. Centrada no desenvolvimento da autonomia de todos os atores envolvidos na comunidade escolar, a aprendizagem se dá na relação entre crianças, jovens e professores, de forma que cada um possui uma trajetória singular, com tempos próprios para aprender e se desenvolver, baseada em projetos. Há na escola o ideal de aprender sem paredes, no convívio sincero entre todos. Não há relação hierárquica entre educador e estudante e o aprender se faz junto, na troca de experiências, ideias, gostos e sonhos.",
             resultOfThecases:  "Desde 2012, o Âncora já recebeu cerca de 13 mil visitantes nos programas de Transformação Vivencial, que organiza visitas guiadas para educadores conhecerem e se inspirarem com as práticas da escola. A crescente procura por essas visitas faz da escola referência internacional de uma nova educação. Hoje, estamos inseridos em importantes mapeamentos, como, por exemplo, o reconhecimento da escola em 2016 pelo Ministério da Educação como um dos 178 projetos de educação inovadores e criativos no Brasil. Além de outras premiações e citações em séries de TV e veículos de comunicação, cerca de 15 trabalhos de conclusão de curso e mestrados também foram realizados a luz do nosso trabalho."),
        Case(id: 3,
             cases: "CIEJA Campo Limpo",
             caseSubtitle: "Cotia, Brasil",
             caseImage: "foto4",
             aboutTheCases: "Com base nos conceitos de Paulo Freire, o Cieja Campo Limpo se dedica à educação de jovens e adultos. A instituição oferece atividades com temas sugeridos pelos educandos, projetos na comunidade e até a construção de um currículo que aborde as demandas de assuntos da região do Capão Redondo, onde ela está localizada. O currículo é construído coletiva e cotidianamente, na relação entre professor e aluno, de acordo com a urgência de assuntos surgidos em sala de aula em cada módulo. Os educadores projetam conteúdo, experiências, vivências e orientações em cada área de conhecimento. A divisão das turmas é feita em módulos e áreas do conhecimento.",
             resultOfThecases: "A escola se tornou um centro de referência para a comunidade, que vê no espaço da escola um espaço de lazer, de reflexão e até de resolução de conflitos. Os estudantes passaram a se sentir valorizados e os resultados das avaliações melhoraram exponencialmente. As famílias, especialmente dos alunos com deficiência, muito se envolveram na escola e conseguem lidar melhor com o processo de aprendizagem de seus filhos."),
        Case(id: 4,
             cases: "CMEI Hermann Gmeiner",
             caseSubtitle: "São Paulo, Brasil",
             caseImage: "foto2",
             aboutTheCases:  "O Centro Municipal de Educação Infantil (CMEI) Hermann Gmeiner é uma escola pública da cidade de Manaus (AM) que fica localizada em terreno amplo e arborizado da ONG Aldeias Infantis SOS de Manaus, junto a outras duas escolas com as quais divide alguns espaços. A escola está situada em área periférica da cidade, atendendo crianças de nove bairros da região, a maioria oriunda de famílias de baixa renda, além de outras da própria ONG. Com o apoio do Coletivo Escola Família Amazonas (CEFA), movimento da sociedade civil engajado na luta por uma educação pública de qualidade, a escola iniciou em 2016 um processo de transformação em seu projeto político-pedagógico, afastando-se do ensino tradicional. Antes, a escola usava muito pouco seus espaços amplos e bosques, e o processo de alfabetização iniciava-se muito cedo, por meio do uso de sistemas apostilados. Após muita reflexão sobre o currículo da escola, tais materiais deixaram de ser utilizados, pois percebeu-se o excessivo direcionamento das atividades para as crianças e educadores com pouca liberdade de trabalho. Hoje, as propostas pedagógicas são desenvolvidas pelos próprios educadores da escola.",
             resultOfThecases: "O (CMEI) Hermann Gmeiner é reconhecido nacionalmente com o selo Escolas Transformadoras. A menção é entregue para espaços de ensino que investem em uma abordagem diferenciada para a educação e transformação de crianças e adolescentes. A mudança no projeto político-pedagógico da escola, já renderam muitos frutos. O índice de evasão da escola, por exemplo, foi diminuindo ano a ano. Outra transformação resultante da nova proposta é o nítido aumento da disposição dos professores e funcionários, em função do fato da escola ter se tornado um ambiente mais fértil e acolhedor."),
        Case(id: 5,
             cases: "FIAP School",
             caseSubtitle: "Manaus, Brasil",
             caseImage: "foto3",
             aboutTheCases: "A FIAP School aplica uma linha de aprendizagem construcionista, baseada no Digital Learning. Trata-se da combinação de várias metodologias ativas de aprendizado – tais como Peer Instruction (Instrução de Pares), Case Based Learning, Team Learning, Problem Based Learning, Project Based Learning e Game Challenge Based Learning. Uma linha que estimula a construção do conhecimento baseada na realização de ações concretas que envolvem construção de coisas: arte, textos, objetos, protótipos, aplicativos, robôs, startups; construção interior: aprendizagem e desenvolvimento pessoal. Os conteúdos básicos do currículo escolar são ensinados por meio do Project Based Learning. Combinados a ele, os alunos recebem conteúdos de sete novas esferas de conhecimento: Art & Crafts, Creative Thinking, Life, Business, Digital Life, Tech e Maker. O objetivo é que essas esferas de conhecimento possam contribuir para o futuro dos alunos, não importa a profissão que escolherem.",
             resultOfThecases:  "As primeiras gerações que já nasceram com a internet. Aprenderam a usar a internet muito cedo. As redes sociais fazem parte do seu cotidiano e estar sempre conectado está nos seus contextos diários. Esses jovens se desenvolveram com um modelo mental diferente. As sinapses aconteceram de forma diferente em relação às gerações analógicas, nascidas antes da internet."),
        Case(id: 6,
             cases: "NEI - Fundação Romi",
             caseSubtitle: "Santa Bárbara d'Oeste, Brasil",
             caseImage: "foto4",
             aboutTheCases: "O NEI - Núcleo de Educação Integrada - Fundação Romi, divide em grupos, os alunos do Núcleo de Educação Integrada são desafiados a buscarem o conhecimento por meio de projetos propostos pelos educadores e por centro de interesse que atuam como estimuladores das atividades pedagógicas e construção do conhecimento. O aluno, de forma ativa e proativa, busca e consolida seu próprio conhecimento a partir da sua vivência prévia, da pesquisa, da partilha entre pares e com seu professor, descaracterizando desta forma, uma visão conteudista e cumulativa do conhecimento.",
             resultOfThecases:  "O NEI trabalha por meio de uma metodologia dinâmica, com a participação efetiva dos alunos no processo de construção do conhecimento. Os educadores inserem esses jovens adolescentes nos novos espaços, às novas rotinas globais, às novas regras sociais, expandido suas mentes para uma nova e moderna educação contribui para seu sucesso futuro."),
    ]
}
*/
