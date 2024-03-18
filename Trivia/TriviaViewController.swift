//
//  ViewController.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import UIKit

class TriviaQuestionService{
    private let apiUrl = "https://opentdb.com/api.php?amount=10&category=9&difficulty=easy&type=multiple"
    
    func fetchTriviaQuestions(completion: @escaping ([TriviaQuestion]?, Error?) -> Void) {
        guard let url = URL(string: apiUrl) else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedQuestions = try decoder.decode([TriviaQuestion].self, from: data)
                completion(decodedQuestions, nil)
            } catch {
                completion(nil, error)
            }
        }
        
        task.resume()
    }
    
    
    
    class TriviaViewController: UIViewController {
        
        @IBOutlet weak var currentQuestionNumberLabel: UILabel!
        @IBOutlet weak var questionContainerView: UIView!
        @IBOutlet weak var questionLabel: UILabel!
        @IBOutlet weak var categoryLabel: UILabel!
        @IBOutlet weak var answerButton0: UIButton!
        @IBOutlet weak var answerButton1: UIButton!
        @IBOutlet weak var answerButton2: UIButton!
        @IBOutlet weak var answerButton3: UIButton!
        
        private var questions = [TriviaQuestion]()
        private var currQuestionIndex = 0
        private var numCorrectQuestions = 0
        
        
        private let triviaService = TriviaQuestionService()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            addGradient()
            questionContainerView.layer.cornerRadius = 8.0
            
 
            fetchTriviaQuestions()
        }
        
        
        private func fetchTriviaQuestions() {
            triviaService.fetchTriviaQuestions { [weak self] (questions, error) in
                guard let self = self else { return }
                
                
                if let questions = questions {
                    DispatchQueue.main.async {
                        self.questions = questions
                        self.updateQuestion(withQuestionIndex: self.currQuestionIndex)
                    }
                } else if let error = error {
                    print("Error fetching trivia questions: \(error)")
                    
                }
            }
        }
        
        private func updateQuestion(withQuestionIndex questionIndex: Int) {
            currentQuestionNumberLabel.text = "Question: \(questionIndex + 1)/\(questions.count)"
            let question = questions[questionIndex]
            questionLabel.text = question.question
            categoryLabel.text = question.category
            let answers = ([question.correctAnswer] + question.incorrectAnswers).shuffled()
            if answers.count > 0 {
                answerButton0.setTitle(answers[0], for: .normal)
            }
            if answers.count > 1 {
                answerButton1.setTitle(answers[1], for: .normal)
                answerButton1.isHidden = false
            }
            if answers.count > 2 {
                answerButton2.setTitle(answers[2], for: .normal)
                answerButton2.isHidden = false
            }
            if answers.count > 3 {
                answerButton3.setTitle(answers[3], for: .normal)
                answerButton3.isHidden = false
            }
        }
        
        private func updateToNextQuestion(answer: String) {
            if isCorrectAnswer(answer) {
                numCorrectQuestions += 1
            }
            currQuestionIndex += 1
            guard currQuestionIndex < questions.count else {
                showFinalScore()
                return
            }
            updateQuestion(withQuestionIndex: currQuestionIndex)
        }
        
        private func isCorrectAnswer(_ answer: String) -> Bool {
            return answer == questions[currQuestionIndex].correctAnswer
        }
        
        private func showFinalScore() {
            let alertController = UIAlertController(title: "Game over!",
                                                    message: "Final score: \(numCorrectQuestions)/\(questions.count)",
                                                    preferredStyle: .alert)
            let resetAction = UIAlertAction(title: "Restart", style: .default) { [unowned self] _ in
                currQuestionIndex = 0
                numCorrectQuestions = 0
                updateQuestion(withQuestionIndex: currQuestionIndex)
            }
            alertController.addAction(resetAction)
            present(alertController, animated: true, completion: nil)
        }
        
        private func addGradient() {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = view.bounds
            gradientLayer.colors = [UIColor(red: 0.54, green: 0.88, blue: 0.99, alpha: 1.00).cgColor,
                                    UIColor(red: 0.51, green: 0.81, blue: 0.97, alpha: 1.00).cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
            view.layer.insertSublayer(gradientLayer, at: 0)
        }
        
        @IBAction func didTapAnswerButton0(_ sender: UIButton) {
            updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
        }
        
        @IBAction func didTapAnswerButton1(_ sender: UIButton) {
            updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
        }
        
        @IBAction func didTapAnswerButton2(_ sender: UIButton) {
            updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
        }
        
        @IBAction func didTapAnswerButton3(_ sender: UIButton) {
            updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
        }
    }
}
