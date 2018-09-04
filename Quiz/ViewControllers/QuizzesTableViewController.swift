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
    var currentImage: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    // MARK: - Saving and getting an image
    
    func saveImage(image: UIImage, withName: String) -> Bool {
        guard let data = UIImageJPEGRepresentation(image, 1) ?? UIImagePNGRepresentation(image) else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent(withName)!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        guard let quiz = quizzes?[indexPath.row] else { return 0 }
        
        let quizId = String(quiz.id)
        
        if let image = self.getSavedImage(named: quizId) {
            return image.size.height
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let number = quizzes?.count else { return 0 }
        return number
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizzesCell", for: indexPath) as! QuizzesTableViewCell
        
        // Getting quiz model for cell
        
        guard let quiz = quizzes?[indexPath.row] else {
            return cell
        }
        
        let quizId = String(quiz.id)
        let quizImageURL = quiz.mainPhoto!.url
        
        // Set image for the quiz
        
        var image = UIImage()
        let cellSize = CGSize(width: tableView.bounds.width, height: tableView.bounds.height)
        
        DispatchQueue.global().async {
            if let imageFromDisk = self.getSavedImage(named: quizId) {
                image = imageFromDisk
            } else {
                
                let url = URL(string: quizImageURL)
                let data = try? Data(contentsOf: url!)
                image = UIImage(data: data!)!.resizeTo(targetSize: cellSize)
                
                DispatchQueue.main.async {
                    tableView.beginUpdates()
                    tableView.endUpdates()
                }
                
                let success = self.saveImage(image: image, withName: quizId)
                print("save success: \(success)")
            }
            
            DispatchQueue.main.async {
                cell.quizImageView.image = image
            }
        }
        
        // Set labels from quiz model
        
        cell.quizTitleLabel.text = quiz.title
        
        if quiz.lastScore.value != nil {
            cell.lastScoreLabel.text = "Ostatni wynik: " + quiz.lastScore.value!.description + "%"
        } else {
            cell.lastScoreLabel.text = ""
        }
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

