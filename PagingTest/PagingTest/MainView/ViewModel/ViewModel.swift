//
//  ViewModel.swift
//  PagingTest
//
//  Created by Mradul Kumar on 19/04/24.
//

import Foundation
import PromiseKit

protocol ViewModelInput: NSObject {
    func loadData()
    func fetchMoreData()
    func showDetailsForArticle(at index: Int)
    func getData() -> [ApiData]
}

protocol ViewModelOutput: NSObject {
    func reloadData()
    func error(_ error: ApiError)
    func showDetailsFor(data: ApiData)
}

class ViewModel: NSObject {
    var fetching = false
    var page = 1
    var limit = 20
    var data: [ApiData] = []
    weak var output: ViewModelOutput?
}

private extension ViewModel {
    
    func getApiData() -> Promise<[ApiData]> {
        page = 1
        return NetworkManager.shared().getApiDataFor(page: page, limit: limit)
    }
    
    func getMoreApiData() -> Promise<[ApiData]> {
        page = page + 1
        return NetworkManager.shared().getApiDataFor(page: page, limit: limit)
    }
}

extension ViewModel: ViewModelInput {

    func getData() -> [ApiData] {
        return self.data
    }
    
    func loadData() {
        guard self.fetching == false else { return }
        self.fetching = true
        
        self.getApiData()
            .done({ [weak self] data in
                guard let self = self else { return }
                self.data = data
                self.output?.reloadData()
                self.fetching = false
            })
            .catch({ [weak self] error in
                guard let self = self else { return }
                self.fetching = false
            })
    }
    
    func fetchMoreData() {
        guard fetching == false else { return }
        fetching = true
        
        self.getMoreApiData()
            .done({ [weak self] data in
                guard let self = self else { return }
                self.data.append(contentsOf: data)
                self.output?.reloadData()
                self.fetching = false
            })
            .catch({ [weak self] error in
                guard let self = self else { return }
                self.fetching = false
            })
    }
    
    func showDetailsForArticle(at index: Int) {
        let data = self.data[index]
        self.output?.showDetailsFor(data: data)
    }
}
