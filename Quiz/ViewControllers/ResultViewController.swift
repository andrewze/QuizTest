//
//  ResultViewController.swift
//  Quiz
//
//  Created by andrei zeniukevich on 20/08/2018.
//  Copyright © 2018 andrei zeniukevich. All rights reserved.
//

import UIKit
import RealmSwift

class ResultViewController: UIViewController {
    
    let realm = try! Realm()
 
    @IBOutlet weak var resultLabel: UILabel!
    
    var quiz = Quiz()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func retryQuizTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        resetQuiz()
    }
    
    @IBAction func goToQuizzessListTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
        resetQuiz()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = quiz.result.toString() + "%"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func resetQuiz() {
        try! realm.write {
            self.quiz.lastScore.value = Int(self.quiz.result)
            self.quiz.result = 0.0
            self.quiz.currentQuestionNumber = 0
        }
    }

}
