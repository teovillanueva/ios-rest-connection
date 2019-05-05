//
//  ViewController.swift
//  users
//
//  Created by Diego Villanueva on 5/5/19.
//  Copyright © 2019 Teodoro Villanueva. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    public struct User {
        var id: Int
        var name: String
        var email: String
        var phone: String
        var website: String
        init(_ dictionary: [String: Any]) {
            self.id = dictionary["id"] as? Int ?? 0
            self.name = dictionary["name"] as? String ?? ""
            self.email = dictionary["email"] as? String ?? ""
            self.phone = dictionary["phone"] as? String ?? ""
            self.website = dictionary["website"] as? String ?? ""
        }
    }
    
    private var users = [User]()
    
    override func viewDidLoad() {
        getUsers()
        
        super.viewDidLoad()
        // Navigation setup
        title = "Usuarios"
        self.navigationController?.navigationBar.prefersLargeTitles = true;
        
        // Table view
        view.backgroundColor = .white;
        
        while users.count < 1 {
            
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let user = users[indexPath.row]
        
        cell.textLabel?.text = user.name
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.textLabel?.text = "hola"
        let user = users[indexPath.row]
        let alert = UIAlertController(title: user.name, message: user.email, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "dismiss", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func getUsers(){
        
        let urlRequest = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/users")!)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            
            guard error == nil else {
                print("There was an error making a request to /users")
                return
            }
            
            guard let responseData = data else {
                print("Did not receive any data")
                return
            }
            do {

                let json = try? JSONSerialization.jsonObject(with: responseData, options: []) as! [Any]
                guard let jsonArray = json as? [[String: Any]] else {
                    return
                }
                
                for dic in jsonArray {
                    self.users.append(User(dic))
                }
            }
        }
        task.resume()
    }
}
