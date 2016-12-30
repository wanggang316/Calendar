//
//  ViewController.swift
//  Calendar
//
//  Created by wanggang on 15/11/2016.
//  Copyright © 2016 GUM. All rights reserved.
//

import UIKit

enum TableRow: String {
    case showView = "view"
    case singleSelectionGeneral = "general"
    case rangeSelectionSimple = "simple"
    case rangeSelectionComplex = "complex"
}

struct TableSection {
    let title: String
    let cells: [TableRow]
}

class ViewController: UITableViewController {
    
    let tableData = [TableSection(title: "Show", cells: [TableRow.showView]),
                    TableSection(title: "Single Selection", cells: [TableRow.singleSelectionGeneral]),
                    TableSection(title: "Range Selection", cells: [TableRow.rangeSelectionSimple, TableRow.rangeSelectionComplex])]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Calendar"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let cellData = tableData[indexPath.section].cells[indexPath.row]
        cell.textLabel?.text = cellData.rawValue
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableData[section].title
    }
}

extension ViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cellData = tableData[indexPath.section].cells[indexPath.row]
        
        switch cellData {
        case .showView:
            break
        case .singleSelectionGeneral:
            let controller = SingleSelectionViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        case .rangeSelectionSimple:
            break
        case .rangeSelectionComplex:
            break
        }
    }
}

