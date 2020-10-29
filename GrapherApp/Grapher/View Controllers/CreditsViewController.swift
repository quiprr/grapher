//
//  CreditsViewController.swift
//  Grapher
//
//  Created by Charlie While on 29/10/2020.
//

import UIKit

struct Credit {
    let creditNames: String!
    let reason: String!
    let socialLinks: String!
}

class CreditsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return credits.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let infoCell = tableView.dequeueReusableCell(withIdentifier: "Grapher.TextCell", for: indexPath) as! TextWithCoverCell
        infoCell.label.text = "\(credits[indexPath.row].creditNames!) : \(credits[indexPath.row].reason!)"
        return infoCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.open(URL(string: credits[indexPath.row].socialLinks)!)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    private let credits = [
        Credit(creditNames: "Charlie While", reason: "App Developer", socialLinks: "https://twitter.com/elihweilrahc13"),
        Credit(creditNames: "quiprr", reason: "Tweak Developer", socialLinks: "https://twitter.com/quiprr"),
        Credit(creditNames: "Charts", reason: "Graph Library", socialLinks: "https://github.com/danielgindi/Charts")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Credits"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.layer.cornerRadius = 10
        self.tableView.isScrollEnabled = false
        self.tableView.tableFooterView = UIView()
        
        self.tableView.register(UINib(nibName: "TextWithCoverCell", bundle: nil), forCellReuseIdentifier: "Grapher.TextCell")

    }
    
}
