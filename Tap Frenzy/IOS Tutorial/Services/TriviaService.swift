//
//  TriviaService.swift
//  IOS Tutorial
//
//  Created by G P M A Nuwan Jeewantha on 2026-07-01.
//

import Foundation

struct TriviaService {
    private let endpoint = "https://opentdb.com/api.php?amount=10&type=multiple"
    
    func fetchQuestions() async throws -> [TriviaQuestion] {
        
        guard let url = URL(string: endpoint) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from:url)
        
        let response = try JSONDecoder().decode(
            TriviaResponse.self,
            from: data
        )
        return response.results
    }
}
