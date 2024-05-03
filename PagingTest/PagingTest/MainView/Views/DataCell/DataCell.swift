//
//  DataCell.swift
//  PagingTest
//
//  Created by Mradul Kumar on 03/05/24.
//

import UIKit

class DataCell: UITableViewCell {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    var data: ApiData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.reset()
        self.setUpUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.reset()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpUI() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 4.0
    }
    
    func updateData() {
        self.idLabel.text = String(data?.id ?? 0)
        self.userIdLabel.text = String(data?.userId ?? 0)
        self.titleLabel.text = data?.title
        self.bodyLabel.text = data?.body
    }
    
    func reset() {
        self.idLabel.text = nil
        self.userIdLabel.text = nil
        self.titleLabel.text = nil
        self.bodyLabel.text = nil
    }
}
