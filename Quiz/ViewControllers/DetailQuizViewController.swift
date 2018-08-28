//
//  DetailQuizViewController.swift
//  Quiz
//
//  Created by andrei zeniukevich on 19/08/2018.
//  Copyright © 2018 andrei zeniukevich. All rights reserved.
//

import UIKit
import RealmSwift

class DetailQuizViewController: UIViewController {
    
    var passedUUID = 0
    var quiz = Quiz()
    let realm = try! Realm()
    var currentQuestion: Question?
    var questions: Results<Question>?
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var questionImageView: UIImageView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var answersButtonsCollection: [UIButton]!
    
    @IBAction func answerButtonWillTap(_ sender: UIButton) {
        
        if let answer = currentQuestion?.answers[sender.tag] {
            switch answer.isCorrect {
            case 1:
                sender.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                
                try! realm.write {
                    quiz.result = quiz.result + quiz.procentSuccessForOneQuestion
                }
                
            case 0:
                sender.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            default: return
            }
        }
    }
    
    @IBAction func answerButtonTapped(_ sender: UIButton) {
        
        clearButtonsBackgroundColor()
        
        if quiz.currentQuestionNumber < questions!.count - 1 {
            
            try! realm.write {
                quiz.currentQuestionNumber = quiz.currentQuestionNumber + 1
            }
            
            currentQuestion = questions![quiz.currentQuestionNumber]
            setValueForLabels()
            
        } else if quiz.currentQuestionNumber == questions!.count - 1 {
            
            performSegue(withIdentifier: "resultSegue", sender: self)
        }
    }
    
    func fetchQuestionsForQuizID(id: Int) {
        
        Question.quizID = id

        APIManager.getItemsForType(type: Question.self, success: {
            
            self.currentQuestion = self.questions?[self.quiz.currentQuestionNumber]
            self.setProcentSuccessForCurrentQuiz()
            self.setValueForLabels()
            
        }) { (error) in
            print("title: \(error), message: \(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        questions = realm.objects(Question.self).filter("id == \(quiz.id)")
        fetchQuestionsForQuizID(id: quiz.id)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        
    }

    func setValueForLabels() {

        questionLabel.text = currentQuestion!.text
        progressView.setProgress((Float(quiz.currentQuestionNumber) + 1.0) / Float(questions!.count), animated: true)

        for button in answersButtonsCollection {
            
            if button.tag < currentQuestion!.answers.count {
                button.setTitle(currentQuestion!.answers[button.tag].text, for: .normal)
            } else {
                button.isHidden = true
            }
        }
    }
    
    func clearButtonsBackgroundColor() {
        for button in answersButtonsCollection {
            button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3041648327)
        }
    }
    
    func setProcentSuccessForCurrentQuiz() {
        
        let procent = Double(100 / questions!.count)
        try! realm.write {
            quiz.procentSuccessForOneQuestion = procent
        } 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resultSegue" {
            let rvc = segue.destination as! ResultViewController
            rvc.quiz = quiz
        }
    }
}

