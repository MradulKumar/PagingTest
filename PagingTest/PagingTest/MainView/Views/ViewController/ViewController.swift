//
//  ViewController.swift
//  PagingTest
//
//  Created by Mradul Kumar on 02/05/24.
//

import UIKit
import SafariServices

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let reuseIdentifier = "DataCell"
    private let offset: CGFloat = 12.0
    private var itemsPerRow: CGFloat = 2
    private var prevOffsetY: Double = 0.0
    
    var output: ViewModelInput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUpUI()
        
        let viewModel = ViewModel()
        self.output = viewModel
        viewModel.output = self
        self.output?.loadData()
    }
}

extension ViewController {
    
    func setUpUI() {
        //title
        self.title = "Pages"
        
        //setting up tableView view
        tableView.dataSource = self
        tableView.delegate = self
        
        let cellXib = UINib(nibName: "DataCell", bundle: nil)
        tableView.register(cellXib, forCellReuseIdentifier: reuseIdentifier)
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.output?.getData().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! DataCell
        if let data = self.output?.getData() {
            cell.data = data[indexPath.row]
            cell.tag = indexPath.row
        }
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didTapCellAt(index: indexPath.row)
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellTemp = cell as? DataCell
        cellTemp!.updateData()
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellTemp = cell as? DataCell
        cellTemp!.reset()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentYoffset = scrollView.contentOffset.y
        if prevOffsetY > contentYoffset { return }
        prevOffsetY = contentYoffset
        let height = scrollView.frame.size.height
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom <= height + 100 {
            output?.fetchMoreData()
        }
    }
}

extension ViewController: ViewModelOutput {
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func error(_ error: ApiError) {
        let alert = UIAlertController(title: "Paging Test", message: error.displayMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
            self.navigationController?.dismiss(animated: true)
        }))
        self.navigationController?.present(alert, animated: true)
    }
    
    func showDetailsFor(data: ApiData) {
        let viewController = DetailViewController.init(nibName: "DetailViewController", bundle: nil)
        viewController.data = data
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ViewController {
    
    @objc func didTapCellAt(index: Int) {
        self.output?.showDetailsForArticle(at: index)
    }
}
