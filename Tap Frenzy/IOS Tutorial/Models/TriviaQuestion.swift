import Foundation

struct TriviaResponse: Codable {
    let results: [TriviaQuestion]
}

struct TriviaQuestion: Codable, Identifiable {
    let id = UUID()
    
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
    
    enum CodingKeys: String, CodingKey {
        case question
        case correct_answer
        case incorrect_answers
        
    }
    
    var allAnswers: [String] {
        (incorrect_answers + [correct_answer]).shuffled()
    }
}
