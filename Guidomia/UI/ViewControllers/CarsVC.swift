//
//  CarsVC.swift
//  Guidomia
//
//  Created by Abderrazak Laanaya on 21/11/2022.
//

import UIKit

class CarsVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: - Props
    private var vm = CarsVM()
    lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        return rc
    }()
    
    
    private var selectedCellIndexPath: IndexPath?
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    //MARK: - Setup UI
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
        tableView.backgroundColor = .clear
        
        // Auto resizing the height of the cell
        tableView.estimatedRowHeight = Constants.selectedCellHeight
        tableView.rowHeight = UITableView.automaticDimension
        
        let nibHeader = UINib(nibName: CarHeaderView.nibName, bundle: nil)
        let nibCell = UINib(nibName: CarViewCell.nibName, bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: CarViewCell.identifier)
        tableView.register(nibHeader, forHeaderFooterViewReuseIdentifier: CarHeaderView.headerID)
        
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        // By default, the first item should be expanded.
        selectedCellIndexPath = IndexPath.init(row: 0, section: 0)
        tableView.selectRow(at: selectedCellIndexPath, animated: true, scrollPosition: .bottom)
        
    }
    
    @IBAction func reloadData() {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
}

extension CarsVC: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Callback & Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.carsItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CarViewCell = tableView.dequeueReusableCell(withIdentifier: CarViewCell.identifier, for: indexPath) as! CarViewCell
        let item = vm.carsItems?[indexPath.row]
        cell.car = item
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.headerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CarHeaderView.headerID)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedCellIndexPath == indexPath {
            return Constants.selectedCellHeight
        }
        return Constants.unselectedCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedCellIndexPath != nil, selectedCellIndexPath == indexPath {
            selectedCellIndexPath = nil
        } else {
            selectedCellIndexPath = indexPath
        }

        if selectedCellIndexPath != nil {
            // This ensures, that the cell is fully visible once expanded
            tableView.scrollToRow(at: indexPath, at: .none, animated: true)
        }
        /*
         we call this method with an animation block
         for much smoother effect when a cell is selected,
         The same can be achieved using `beginUpdates()` and `endUpdates()`
         but apple suggests that we should use `performBatchUpdates` instead of them,
         */
        UIView.animate(withDuration: 0.3) {
            self.tableView.performBatchUpdates(nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        /*
         hide the detailView when another cell is selected,
         we can achieve that easily with
         */
        if let cell = self.tableView.cellForRow(at: indexPath) as? CarViewCell {
            cell.hideDetailView()
        }
    }
}
