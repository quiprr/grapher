//
//  MainViewController.swift
//  Grapher
//
//  Created by Amy While on 28/10/2020.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var shownKeys = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getData()
        self.setup()
        // Do any additional setup after loading the view.
    }
        
    private func setup() {
        //Make it transparent
        self.tableView.backgroundColor = .none
        //Removes cells that don't exist
        self.tableView.tableFooterView = UIView()
        //Disable the scroll indicators
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.showsHorizontalScrollIndicator = false
        //Register the cell from nib
        self.tableView.register(UINib(nibName: "TextWithCoverCell", bundle: nil), forCellReuseIdentifier: "Grapher.TextCell")
        //Set the delegate/source
        self.tableView.delegate = self
        self.tableView.dataSource = self
        //Bouncy Boi
        self.tableView.alwaysBounceVertical = false
        
        let rightItem = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(refreshButton))
        let leftItem = UIBarButtonItem(title: "Purge", style: .plain, target: self, action: #selector(purgeButton))
        self.navigationItem.rightBarButtonItem = rightItem
        self.navigationItem.leftBarButtonItem = leftItem
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshButton), name: .FuckyWucky, object: nil)
    }
    
    private func getData() {
        DataParser.shared.getEntriesFromLog()
        self.shownKeys = [String]()
        
        for key in DataParser.shared.data.keys {
            self.shownKeys.append(key)
        }
    }
    
    @objc func refreshButton() {
        self.getData()
        self.tableView.reloadData()
    }
    
    @objc func purgeButton() {
        let alert = UIAlertController(title: "Purge Data", message: "Are you sure you want to purge all data?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            DataParser.shared.purge(true)
            self.refreshButton()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "Grapher.ShowDetail" {
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    let controller = segue.destination as! DataViewController
                    let data = DataParser.shared.data[self.shownKeys[indexPath.row]]
                    controller.data = data
                    controller.navTitle = self.shownKeys[indexPath.row]
                }
            }
        }
}

extension MainViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Make it invisible when you press it
        if indexPath.row == self.shownKeys.count {
            self.performSegue(withIdentifier: "Grapher.ShowCredits", sender: nil)
        } else {
            self.performSegue(withIdentifier: "Grapher.ShowDetail", sender: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MainViewController : UITableViewDataSource {

    //This is just meant to be
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shownKeys.count + 1
    }
    
    //This is what handles all the images and text etc, using the class mainScreenTableCells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Grapher.TextCell", for: indexPath) as! TextWithCoverCell
        if indexPath.row == self.shownKeys.count {
            cell.label.text = "Credits"
            return cell
        } else {
            cell.label.text = self.shownKeys[indexPath.row]
            return cell
        }
    }
}


extension NSNotification.Name {
    static let FuckyWucky = Notification.Name("FuckyWucky")
}
