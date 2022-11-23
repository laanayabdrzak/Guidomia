//
//  CarsVC.swift
//  Guidomia
//
//  Created by Abderrazak Laanaya on 21/11/2022.
//

import UIKit
import CoreData

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
    var isFiltering: Bool = false
    var filteredCars = [CarCodeable]() {
        didSet {
            selectedCellIndexPath = nil
            tableView.reloadData()
        }
    }
    
    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Car.self))
        // TODO: If we wanna sort with rating
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "rating", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DatabaseHelper.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        updateTableContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /**
         By default, the first item should be expanded.
         */
        if !isFiltering {
            selectedCellIndexPath = IndexPath.init(row: 0, section: 0)
            tableView.selectRow(at: selectedCellIndexPath, animated: true, scrollPosition: .bottom)
        }
    }
    
    //MARK: - Setup UI
    private func configureView() {
        
        // Navigation Bar
        UIHelper().setCustomNavigationTitle(title: Constants.appName.uppercased(), navItem: navigationItem)
        UIHelper().setNavigationBar(tintColor: .white, navController: navigationController, navItem: self.navigationItem)
        
        // UITableView
        tableView.separatorStyle = .none
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
        tableView.backgroundColor = .clear
        
        // Auto resizing the height of the cell
        tableView.estimatedRowHeight = Constants.selectedCellHeight
        tableView.rowHeight = UITableView.automaticDimension
        
        // HeaderViewSection
        let nibHeader = UINib(nibName: CarHeaderView.nibName, bundle: nil)
        tableView.register(nibHeader, forHeaderFooterViewReuseIdentifier: CarHeaderView.headerID)
        
        // TableViewCell
        let nibCell = UINib(nibName: CarViewCell.nibName, bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: CarViewCell.identifier)
        
        // Refresh Control
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
    }
    
    private func updateTableContent() {
        
        do {
            try self.fetchedhResultController.performFetch()
            print("COUNT FETCHED FIRST: \(String(describing: self.fetchedhResultController.sections?[0].numberOfObjects))")
        } catch let error  {
            print("ERROR: \(error)")
        }
        vm.saveInCoreDataWith(array: vm.carsItems!)
    }
    
    @IBAction func reloadData() {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
}

//MARK: - DataSource & Delegates
extension CarsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredCars.count : (vm.carsItems?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CarViewCell = tableView.dequeueReusableCell(withIdentifier: CarViewCell.identifier, for: indexPath) as! CarViewCell
        let itemCar = isFiltering ? filteredCars[indexPath.row] : vm.carsItems?[indexPath.row]
        cell.car = itemCar
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
        (header as? CarHeaderView)?.delegate = self
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
        /**
         we call this method with an animation block
         for much smoother effect when a cell is selected,
         The same can be achieved using `beginUpdates()` and `endUpdates()`
         but apple suggests that we should use `performBatchUpdates` instead of them
         */
        UIView.animate(withDuration: 0.3) {
            self.tableView.performBatchUpdates(nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        /**
         hide the detailView when another cell is selected,
         we can achieve that easily with
         */
        if let cell = self.tableView.cellForRow(at: indexPath) as? CarViewCell {
            cell.hideDetailView()
        }
    }
}

//MARK: - Callback & Delegates for UITextField
extension CarsVC: CarHeaderDelegate {
    
    func didSearchFor(make: String) {
        if let data = vm.carsItems, make.count > 0 {
            isFiltering = true
            filteredCars = data.filter({(dataString: CarCodeable) -> Bool in
                return (dataString.make.range(of: make, options: .caseInsensitive) != nil)
            })
            
        } else {
            isFiltering = false
            filteredCars = vm.carsItems!
        }
    }
    
    func didSearchFor(model: String) {
        if let data = vm.carsItems, model.count > 0 {
            isFiltering = true
            filteredCars = data.filter({(dataString: CarCodeable) -> Bool in
                return (dataString.model.range(of: model, options: .caseInsensitive) != nil)
            })
        } else {
            isFiltering = false
            filteredCars = vm.carsItems!
        }
    }
}

extension CarsVC: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
}
