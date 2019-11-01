//
//  ViewController.swift
//  FlyMe
//
//  Created by Dalibor Kozak on 09/10/2019.
//  Copyright © 2019 Dalibor Kozak. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var tableData = [CellType]()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        loadData()
    }
    
    @objc func refresh() {
        loadData()
        refreshControl.endRefreshing()
    }
    
    //MARK: TableView DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = tableData[indexPath.row]
        
        switch cellData {
        case .image(let (trip, img)):
            if let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as? ImageViewCell {
                cell.configureView((trip, img))
                return cell
            }
            
        case .info(let trip):
            if let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as? InfoViewCell {
                cell.configureView(trip)
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    //MARK: TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let nextRowIndex = index + 1
        let cell = tableData[index]
        
        //check if info cell is already displayed
        var canAppend: Bool {
            if tableData.count >= nextRowIndex {
                if tableData.indices.contains(nextRowIndex) {
                    let nextCell = tableData[nextRowIndex]
                    return nextCell != cell
                }
                return true
            }
            return false
        }
        
        func addCell(atIndex: Int) {
            tableView.beginUpdates()
            tableData.insert(CellType.info(cell.cellData()), at: atIndex)
            let newIndexPath = IndexPath(row: atIndex, section: indexPath.section)
            tableView.insertRows(at: [newIndexPath], with: .bottom)
            tableView.endUpdates()
            tableView.scrollToRow(at: newIndexPath, at: .middle, animated: true)
        }
        
        func removeCell(atIndex: Int) {
            tableView.beginUpdates()
            tableData.remove(at: atIndex)
            let newIndexPath = IndexPath(row: atIndex, section: indexPath.section)
            tableView.deleteRows(at: [newIndexPath], with: .top)
            tableView.endUpdates()
        }
        
        switch cell {
        case .image(_):
            if canAppend {
                addCell(atIndex: nextRowIndex)
            } else {
                if tableData.count > nextRowIndex {
                    removeCell(atIndex: nextRowIndex)
                }
            }
        case .info(_):
            removeCell(atIndex: index)
        }
    }
    
    //MARK: Notification
    
    func notifyUser() {
        DispatchQueue.main.async {
            let actionA = UIAlertAction.init(title: "Try again", style: .default){ alert in self.loadData() }
            let actionB = UIAlertAction.init(title: "OK", style: .cancel){ alert in self.activityIndicator.stopAnimating() }
            let alert = UIAlertController.init(title: "Error occured", message: "Plesae try later", preferredStyle: .alert)
            alert.addAction(actionA)
            alert.addAction(actionB)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: DataSection
    
    func loadData() {
        activityIndicator.startAnimating()
        DataProvider.shared.requestLiveData { flights, error  in
            if error == nil,  let flights = flights {
                self.selectDataForDisplay(flights)
            } else {
                self.notifyUser()
            }
        }
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
    func selectDataForDisplay(_ flights: Flights?) {
        tableData.removeAll()
        
        func checkAndAppend(_ value: CellType) {
            if value.cellData().availability?.seats != nil {
                tableData.append(value)
            }
        }
        
        func selectTrip(_ element: [Trip], _ sortedUp: Bool) {
            if sortedUp {
                guard let a = element.first else { return }
                let b = CellType.image((a,nil))
                if tableData.contains(where: { $0 == b }) {
                    selectTrip(Array(element.dropFirst()), true)
                } else {
                    checkAndAppend(b)
                }
                
            } else {
                guard let a = element.last else { return }
                let b = CellType.image((a, nil))
                if tableData.contains(where: { $0 == b }) {
                    selectTrip(Array(element.dropLast()), true)
                } else {
                    checkAndAppend(b)
                }
            }
        }
        
        guard let flights = flights else { return }
        
        //remove trips with 0 seats availability
        let selection = flights.data.filter { $0.availability?.seats != nil ? true : false }
        
        //Sorting by
        let byPopularity = selection.sorted { $0.popularity > $1.popularity }
        let byPrice = selection.sorted { $0.price < $1.price }
        let byDistance = selection.sorted { $0.distance > $1.distance }
        let byQuality = selection.sorted { $0.quality > $1.quality }
        
        selectTrip(byPopularity, true)
        selectTrip(byPopularity, false)
        selectTrip(byPrice, true)
        selectTrip(byDistance, false)
        selectTrip(byQuality, true)
        
        loadImages()
        reloadTable()
    }
    
    func loadImages() {
        for (i, d) in tableData.enumerated() {
            DataProvider.shared.requestBackgroundImageFor( iataCode: d.cellData().mapIdto) { (image) in
                self.tableData[i] = CellType.image((d.cellData(), image))
                self.reloadTable()
            }
        }
    }
}

