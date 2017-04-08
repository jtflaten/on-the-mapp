//
//  TableViewController.swift
//  on the mApp
//
//  Created by Jake Flaten on 3/20/17.
//  Copyright © 2017 Break List. All rights reserved.
//
import Foundation
import UIKit

class TableViewController: UIViewController {
    


    @IBOutlet var tableView: UITableView!
  //  @IBOutlet weak var studentTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Do any additional setup after loading the view, typically from a nib.
        super.viewWillAppear(animated)


        self.tableView.reloadData()

    }
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let studentsNumber = StudentLocation.studentLocationArray.count
        return studentsNumber
        
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let student = StudentLocation.studentLocationArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell")!
        
        if let firstName = student.firstName, let secondName = student.lastName {
            let studentName = firstName + " " + secondName
            cell.textLabel?.text = studentName
        } else {
            let studentName = "couldn't find student name"
            cell.textLabel?.text = studentName
        }
     
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = StudentLocation.studentLocationArray[(indexPath as NSIndexPath).row]
        if let url = URL(string: student.link!) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                print("couldnt open that")
            }
            
        }
       
    }
    
}

