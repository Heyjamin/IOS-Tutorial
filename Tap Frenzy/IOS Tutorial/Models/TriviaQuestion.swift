import Foundation

extension String{
    var htmlDecoded: String {
        self
            .replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&quot;", with: "\"")
            .replacingOccurrences(of: "&#39;", with: "'")
            .replacingOccurrences(of: "&lt;", with: "<")
            .replacingOccurrences(of: "&gt;", with: ">")
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
        
        enum CodingKeys: String, CodingKey {
            case question
            case correct_answer
            case incorrect_answers
            
        }
        
        var allAnswers: [String] {
            (incorrect_answers + [correct_answer]).shuffled()
        }
    }

