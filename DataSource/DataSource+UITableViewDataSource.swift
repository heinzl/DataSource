//
//  DataSource+UITableView.swift
//  DataSource
//
//  Created by Matthias Buchetics on 21/02/2017.
//  Copyright © 2017 aaa - all about apps GmbH. All rights reserved.
//

import UIKit
import Diff

extension DataSource: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return visibleSections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleSections[section].visibleRows.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellDescriptor = self.cellDescriptor(at: indexPath)
       
        if let closure = cellDescriptor.configureClosure ?? configure {
            let row = self.visibleRow(at: indexPath)
            let cell = tableView.dequeueReusableCell(withIdentifier: cellDescriptor.cellIdentifier, for: indexPath)
            
            closure(row, cell, indexPath)
            
            return cell
        } else if let fallbackDataSource = fallbackDataSource {
            return fallbackDataSource.tableView(tableView, cellForRowAt: indexPath)
        } else {
            fatalError("[DataSource] no configure closure and no fallback UITableViewDataSource set")
        }
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let index = section
        let section = visibleSections[index]
        
        switch section.headerClosure?(section, index) {
        case .title(let title)?:
            return title
        default:
            return nil
        }
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let index = section
        let section = visibleSections[index]
        
        switch section.footerClosure?(section, index) {
        case .title(let title)?:
            return title
        default:
            return nil
        }

    }
}
