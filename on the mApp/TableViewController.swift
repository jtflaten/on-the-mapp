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
        
        //create the NavBar
//        parent!.navigationItem.rightBarButtonItems = [
//            UIBarButtonItem(image: #imageLiteral(resourceName: "icon_addpin"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(pushToPostInfo)),
//            UIBarButtonItem(image: #imageLiteral(resourceName: "icon_refresh"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(refreshData))
//        ]
//        parent!.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(logout))
    }
    override func viewWillAppear(_ animated: Bool) {
        // Do any additional setup after loading the view, typically from a nib.
        super.viewWillAppear(animated)
        print("tableViewBefore\(self.students.count)")
        print("arrayBefore\(StudentLocation.studentLocationArray.count)")
        self.students = StudentLocation.studentLocationArray
        self.tableView.reloadData()
        print("tableViewAfter\(self.students.count)")
        print("arrayAfter\(StudentLocation.studentLocationArray.count)")
        print("your name is \(StudentLocation.userInfo.firstName!)\(StudentLocation.userInfo.lastName!)")
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
        let student = self.students[(indexPath as NSIndexPath).row]
        if let url = URL(string: student.link!) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                print("couldnt open that")
            }
            
        }
        print(student.link!)
    }
    
//    func pushToPostInfo()   {
//        let postViewController = storyboard!.instantiateViewController(withIdentifier: "PostInfoViewController") as! PostInfoViewController
//        present(postViewController, animated: true, completion: nil)
//    }
//    func refreshData () {
//        viewWillAppear(false)
//    }
//    func logout() {
//        UdacityClient.sharedInstance().logoutFromUdacity()
//       // dismiss(animated: true, completion: nil)
//    }
}

