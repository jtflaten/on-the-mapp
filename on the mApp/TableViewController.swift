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
    
    var students: [StudentLocation] = []

    @IBOutlet var tableView: UITableView!
  //  @IBOutlet weak var studentTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
     
    }
    override func viewWillAppear(_ animated: Bool) {
        // Do any additional setup after loading the view, typically from a nib.
        super.viewWillAppear(animated)
        self.students = StudentLocation.studentLocationArray
            self.tableView.reloadData()
        
    }
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let studentsNumber = self.students.count
        print(studentsNumber)
        return studentsNumber
        
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let student = students[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell")!
        print("i got down here")
        
        cell.textLabel?.text = (student.firstName! + student.lastName!)
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = self.students[(indexPath as NSIndexPath).row]
        print(student.link!)
    }
}

