//
//  TriviaQuestion.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import Foundation

struct TriviaQuestion: Codable {
    let type: String
    let difficulty: String
    let category: String
    let question: String
    let correctAnswer: String // Updated key name
    let incorrectAnswers: [String]
    
    enum CodingKeys: String, CodingKey {
        case type, difficulty, category, question
        case correctAnswer = "correct_answer" 
        case incorrectAnswers = "incorrect_answers"
    }
}

struct TriviaResponse: Codable {
//    let responseCode: Int
    let results: [TriviaQuestion]
}


