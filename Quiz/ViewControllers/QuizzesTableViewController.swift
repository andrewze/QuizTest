//
//  QuizzesTableViewController.swift
//  Quiz
//
//  Created by andrei zeniukevich on 15/08/2018.
//  Copyright © 2018 andrei zeniukevich. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper
import AlamofireImage

class QuizzesTableViewController: UITableViewController {
    
    let realm = try! Realm()
    var quizzes: Results<Quiz>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = tableView.rowHeight
        
        quizzes = realm.objects(Quiz.self)
        fetchQuizzes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        tableView.reloadData()
    }
    
    func fetchQuizzes(){
        APIManager.getItemsForType(type: Quiz.self, success: {
            
            self.tableView.reloadData()
        }) { (error) in
            print("title: \(error), message: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let number = quizzes?.count else {
            return 0
        }
        return number
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizzesCell", for: indexPath) as! QuizzesTableViewCell
        
        guard let quiz = quizzes?[indexPath.row] else {
            return cell
        }
        
        cell.quizTitleLabel.text = quiz.title
        
        if quiz.lastScore.value != nil {
            cell.lastScoreLabel.text = "Ostatni wynik: " + quiz.lastScore.value!.description + "%"
        } else {
            cell.lastScoreLabel.text = ""
        }

//        guard
//            let width = quiz.mainPhoto?.width,
//            let height = quiz.mainPhoto?.height
//            else { return cell }
//
//        print("width = \(width), height = \(height)")
//
//        let ratio = CGFloat(width / height)
//        
//        cell.imageView?.frame.size.height = (cell.imageView?.frame.size.width)! / ratio
        
//        cell.imageView?.af_setImage(withURL: URL(string: quiz.mainPhoto!.url)!,
//                                    placeholderImage: nil,
//                                    filter: nil,
//                                    imageTransition: .crossDissolve(0.2),
//                                    runImageTransitionIfCached: true,
//                                    completion: nil)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "detailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let dvc = segue.destination as! DetailQuizViewController
                dvc.quiz = quizzes![indexPath.row]
            }
        }
    }
}
