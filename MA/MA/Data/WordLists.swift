
import Foundation
import RealmSwift

class WordLists {
    struct PartsOfSpeech {
        var nouns: [String]
        var verbs: [String]
        var adjectives: [String]
        var adverbs: [String]
        var pronouns: [String]
        var prepositions: [String]
        var conjunctions: [String]
        var negativeParticles: [String]
        var articles: [String]
        var interjections: [String]
    }

    var partsOfSpeech: PartsOfSpeech

    init(nouns: [String], verbs: [String], adjectives: [String], adverbs: [String], pronouns: [String], prepositions: [String], conjunctions: [String], negativeParticles: [String], articles: [String], interjections: [String]) {
        partsOfSpeech = PartsOfSpeech(nouns: nouns, verbs: verbs, adjectives: adjectives, adverbs: adverbs, pronouns: pronouns, prepositions: prepositions, conjunctions: conjunctions, negativeParticles: negativeParticles, articles: articles, interjections: interjections)
    }

    static func getPartOfSpeech(for word: String) -> String {
        let wordLists = WordLists(nouns: [], verbs: [], adjectives: [], adverbs: [], pronouns: [], prepositions: [], conjunctions: [], negativeParticles: [], articles: [], interjections: [])

        if wordLists.partsOfSpeech.nouns.contains(word) {
            return "Существительное"
        } else if wordLists.partsOfSpeech.verbs.contains(word) {
            return "Глагол"
        } else if wordLists.partsOfSpeech.adjectives.contains(word) {
            return "Прилагательное"
        } else if wordLists.partsOfSpeech.adverbs.contains(word) {
            return "Наречие"
        } else if wordLists.partsOfSpeech.pronouns.contains(word) {
            return "Местоимение"
        } else if wordLists.partsOfSpeech.prepositions.contains(word) {
            return "Предлог"
        } else if wordLists.partsOfSpeech.conjunctions.contains(word) {
            return "Союз"
        } else if wordLists.partsOfSpeech.negativeParticles.contains(word) {
            return "Отрицательная частица"
        } else if wordLists.partsOfSpeech.articles.contains(word) {
            return "Артикль"
        } else if wordLists.partsOfSpeech.interjections.contains(word) {
            return "Междометие"
        } else {
            return "Неизвестно"
        }
    }
}
