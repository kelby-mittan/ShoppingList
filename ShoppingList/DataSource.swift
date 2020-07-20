//
//  DataSource.swift
//  ShoppingList
//
//  Created by Kelby Mittan on 7/15/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit


// conforms to UITableViewDataSource

protocol DeleteItemDelegate {
    func deleteItem(item: Item)
}

class DataSource: UITableViewDiffableDataSource<Category, Item> {
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if Category.allCases[section] == .education {
            return "" + Category.allCases[section].rawValue
        } else {
            return Category.allCases[section].rawValue
        }
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            print("Hey Now")
            
            // 1.
            var snapshot = self.snapshot()
            
            // 2.
            if let item = itemIdentifier(for: indexPath) {
                // 3.
                snapshot.deleteItems([item])
                
                // 4.
                apply(snapshot, animatingDifferences: true)
            }
        }
    }
    
    // 1. reordering steps
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // 2. reordering steps
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        // get the source item
        
        guard let sourceItem = itemIdentifier(for: sourceIndexPath) else { return }
        
        // SCENARIO 1: attempting to move to self
        guard sourceIndexPath != destinationIndexPath else {
            return
        }
        
        // get destination item
        let destinationItem = itemIdentifier(for: destinationIndexPath)
        
        // get the current snapshot
        var snapshot = self.snapshot()
        
        // handle scenario 2 & 3
        
        if let destinationItem = destinationItem {
            
            if let sourceIndex = snapshot.indexOfItem(sourceItem), let destinationIndex = snapshot.indexOfItem(destinationItem) {
                
                let isAfter = destinationIndex > sourceIndex && snapshot.sectionIdentifier(containingItem: sourceItem) == snapshot.sectionIdentifier(containingItem: destinationItem)
                
                // first delete the source item
                snapshot.deleteItems([sourceItem])
                
                // scenario 2
                if isAfter {
                    snapshot.insertItems([sourceItem], afterItem: destinationItem)
                }
                
                // scenario 3
                else {
                    snapshot.insertItems([sourceItem], beforeItem: destinationItem)
                }
                
            }
        }
        
        // handle scenario 4
        // no indexpath at destination section
        
        else {
            // get the section for the destination index path
            let destinationSectionIdentifier = snapshot.sectionIdentifiers[destinationIndexPath.section]
            
            // delete the source item before reinserting it
            snapshot.deleteItems([sourceItem])
            
            // append the source item at the new section
            snapshot.appendItems([sourceItem], toSection: destinationSectionIdentifier)
            
        }
        apply(snapshot, animatingDifferences: false)
    }
}
