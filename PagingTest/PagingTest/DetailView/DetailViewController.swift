//
//  DetailViewController.swift
//  PagingTest
//
//  Created by Mradul Kumar on 03/05/24.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var bodyTextView: UITextView!
    
    var data: ApiData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateData()
    }
}

private extension DetailViewController {
    
    func setupUI() {
        self.title = data?.title
    }
    
    func updateData() {
        self.idLabel.text = "Id : " + String(data?.id ?? 0)
        self.userIdLabel.text = "User Id : " + String(data?.userId ?? 0)
        self.titleTextView.text = data?.title
        self.bodyTextView.text = data?.body
    }
}
