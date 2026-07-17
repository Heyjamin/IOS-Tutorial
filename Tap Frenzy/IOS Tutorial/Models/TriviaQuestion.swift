//
//  TriviaQuestion.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-06-15.
//

import Foundation

extension String {
    /// Decodes HTML entities from Open Trivia DB (`&quot;`, `&#039;`, `&eacute;`, `&amp;quot;`, etc.)
    var htmlDecoded: String {
        guard contains("&") else { return self }

        var result = self
        for _ in 0..<6 {
            let next = result.decodingHTMLEntitiesSinglePass()
            if next == result { break }
            result = next
        }
        return result
    }

    private func decodingHTMLEntitiesSinglePass() -> String {
        var result = replaceNumericEntities(in: self, pattern: Const.selfPattern) { code in
            Unicode.Scalar(code).map(Character.init)
        }

        result = replaceNumericEntities(in: result, pattern: Const.resultPattern) { code in
            Unicode.Scalar(code).map(Character.init)
        }

        for (entity, character) in Const.htmlNamedEntities {
            result = result.replacingOccurrences(of: entity, with: character)
        }

        return result
    }

    private func replaceNumericEntities(
        in text: String,
        pattern: String,
        character: (UInt32) -> Character?
    ) -> String {
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return text }

        var result = text
        let nsRange = NSRange(text.startIndex..., in: text)
        let matches = regex.matches(in: text, range: nsRange).reversed()

        for match in matches {
            guard match.numberOfRanges > 1,
                  let entityRange = Range(match.range, in: text),
                  let codeRange = Range(match.range(at: 1), in: text),
                  let code = UInt32(text[codeRange]),
                  let decoded = character(code)
            else { continue }

            result.replaceSubrange(entityRange, with: String(decoded))
        }

        return result
    }
}

struct TriviaResponse: Codable {
    let results: [TriviaQuestion]
}

struct TriviaQuestion: Codable, Identifiable {
    let id = UUID()

    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
    let category: String
    /// Shuffled once when the question is decoded — order stays fixed while answering.
    let displayAnswers: [String]

    enum CodingKeys: String, CodingKey {
        case question
        case correct_answer
        case incorrect_answers
        case category
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawQuestion = try container.decode(String.self, forKey: .question)
        let rawCorrect = try container.decode(String.self, forKey: .correct_answer)
        let rawIncorrect = try container.decode([String].self, forKey: .incorrect_answers)
        let rawCategory = try container.decodeIfPresent(String.self, forKey: .category) ?? Const.txtGeneralKonwledge

        question = rawQuestion.htmlDecoded
        correct_answer = rawCorrect.htmlDecoded
        incorrect_answers = rawIncorrect.map { $0.htmlDecoded }
        category = rawCategory.htmlDecoded
        displayAnswers = (incorrect_answers + [correct_answer]).shuffled()
    }

    init(
        question: String,
        correct_answer: String,
        incorrect_answers: [String],
        category: String = Const.txtGeneralKonwledge,
        displayAnswers: [String]? = nil
    ) {
        self.question = question.htmlDecoded
        self.correct_answer = correct_answer.htmlDecoded
        self.incorrect_answers = incorrect_answers.map { $0.htmlDecoded }
        self.category = category.htmlDecoded
        self.displayAnswers = displayAnswers ?? (self.incorrect_answers + [self.correct_answer]).shuffled()
    }

    var categoryLabel: String {
        category.replacingOccurrences(of: "_", with: " ")
    }

    var startsWithHint: String {
        let trimmed = correct_answer.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let first = trimmed.first else { return Const.txtQRInstructions}
        let letters = trimmed.filter { $0.isLetter || $0.isNumber }.count
        return Const.txtStartsWith + " \"\(String(first).uppercased())\" · \(letters)" + Const.txtCharactors
    }

    /// Keeps the correct answer and one wrong option from the shuffled list.
    func fiftyFiftyAnswers(from answers: [String]) -> [String] {
        let keptWrong = answers.first { $0 != correct_answer }
        return answers.filter { $0 == correct_answer || $0 == keptWrong }
    }

    func hintText(kind: QuizHintKind) -> String {
        switch kind {
        case .category:
            return Const.txtCategory + " \(categoryLabel)"
        case .startsWith:
            return startsWithHint
        case .fiftyFifty:
            return Const.txtFifyFifty
        }
    }
}

enum QuizHintKind: Int, CaseIterable {
    case category
    case startsWith
    case fiftyFifty
}
