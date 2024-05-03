//
//  DataModel.swift
//  PagingTest
//
//  Created by Mradul Kumar on 19/04/2024.
//

import Foundation
import UIKit

class DataModel {
    private (set) var data: [ApiData]? = nil
    
    init(_ jsonData: [Dictionary<String, Any>]?) {
        if let jsonData = jsonData {
            let decoder = JSONDecoder()
            if let dataObj = try? JSONSerialization.data(withJSONObject: jsonData, options: []) {
                self.data = try? decoder.decode([ApiData].self, from: dataObj)
            }
        }
    }
}

struct ApiData: Codable {
    var userId: Int?
    var id: Int?
    var title: String?
    var body: String?
}
