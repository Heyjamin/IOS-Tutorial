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
        var result = replaceNumericEntities(in: self, pattern: "&#x([0-9A-Fa-f]+);") { code in
            Unicode.Scalar(code).map(Character.init)
        }

        result = replaceNumericEntities(in: result, pattern: "&#(\\d+);") { code in
            Unicode.Scalar(code).map(Character.init)
        }

        for (entity, character) in Self.htmlNamedEntities {
            result = result.replacingOccurrences(of: entity, with: character)
        }

        return result
    }

    private static let htmlNamedEntities: [(String, String)] = [
        ("&amp;", "&"),
        ("&quot;", "\""),
        ("&apos;", "'"),
        ("&#039;", "'"),
        ("&#39;", "'"),
        ("&lt;", "<"),
        ("&gt;", ">"),
        ("&nbsp;", " "),
        ("&rsquo;", "'"),
        ("&lsquo;", "'"),
        ("&rdquo;", "\""),
        ("&ldquo;", "\""),
        ("&hellip;", "…"),
        ("&mdash;", "—"),
        ("&ndash;", "–"),
        ("&eacute;", "é"),
        ("&Eacute;", "É"),
        ("&egrave;", "è"),
        ("&Egrave;", "È"),
        ("&ecirc;", "ê"),
        ("&Ecirc;", "Ê"),
        ("&euml;", "ë"),
        ("&Euml;", "Ë"),
        ("&aacute;", "á"),
        ("&Aacute;", "Á"),
        ("&agrave;", "à"),
        ("&Agrave;", "À"),
        ("&acirc;", "â"),
        ("&Acirc;", "Â"),
        ("&auml;", "ä"),
        ("&Auml;", "Ä"),
        ("&aring;", "å"),
        ("&Aring;", "Å"),
        ("&iacute;", "í"),
        ("&Iacute;", "Í"),
        ("&igrave;", "ì"),
        ("&Igrave;", "Ì"),
        ("&icirc;", "î"),
        ("&Icirc;", "Î"),
        ("&iuml;", "ï"),
        ("&Iuml;", "Ï"),
        ("&oacute;", "ó"),
        ("&Oacute;", "Ó"),
        ("&ograve;", "ò"),
        ("&Ograve;", "Ò"),
        ("&ocirc;", "ô"),
        ("&Ocirc;", "Ô"),
        ("&ouml;", "ö"),
        ("&Ouml;", "Ö"),
        ("&oslash;", "ø"),
        ("&Oslash;", "Ø"),
        ("&uacute;", "ú"),
        ("&Uacute;", "Ú"),
        ("&ugrave;", "ù"),
        ("&Ugrave;", "Ù"),
        ("&ucirc;", "û"),
        ("&Ucirc;", "Û"),
        ("&uuml;", "ü"),
        ("&Uuml;", "Ü"),
        ("&ntilde;", "ñ"),
        ("&Ntilde;", "Ñ"),
        ("&ccedil;", "ç"),
        ("&Ccedil;", "Ç"),
        ("&yacute;", "ý"),
        ("&Yacute;", "Ý"),
        ("&szlig;", "ß"),
        ("&eth;", "ð"),
        ("&ETH;", "Ð"),
        ("&thorn;", "þ"),
        ("&THORN;", "Þ"),
        ("&pi;", "π"),
        ("&deg;", "°"),
        ("&copy;", "©"),
        ("&reg;", "®"),
        ("&trade;", "™"),
        ("&cent;", "¢"),
        ("&pound;", "£"),
        ("&euro;", "€"),
        ("&yen;", "¥"),
        ("&iquest;", "¿"),
        ("&iexcl;", "¡"),
        ("&bull;", "•"),
        ("&middot;", "·"),
    ]

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
        let rawCategory = try container.decodeIfPresent(String.self, forKey: .category) ?? "General Knowledge"

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
        category: String = "General Knowledge",
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
        guard let first = trimmed.first else { return "💡 Check the answer choices carefully" }
        let letters = trimmed.filter { $0.isLetter || $0.isNumber }.count
        return "💡 Starts with \"\(String(first).uppercased())\" · \(letters) characters"
    }

    /// Keeps the correct answer and one wrong option from the shuffled list.
    func fiftyFiftyAnswers(from answers: [String]) -> [String] {
        let keptWrong = answers.first { $0 != correct_answer }
        return answers.filter { $0 == correct_answer || $0 == keptWrong }
    }

    func hintText(kind: QuizHintKind) -> String {
        switch kind {
        case .category:
            return "💡 Category: \(categoryLabel)"
        case .startsWith:
            return startsWithHint
        case .fiftyFifty:
            return "💡 50/50 — two wrong answers removed"
        }
    }
}

enum QuizHintKind: Int, CaseIterable {
    case category
    case startsWith
    case fiftyFifty
}
