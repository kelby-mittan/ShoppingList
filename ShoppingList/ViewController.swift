//
//  ViewController.swift
//  ShoppingList
//
//  Created by Kelby Mittan on 7/15/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit

class ItemFeedController: UIViewController {

    private var tableView: UITableView!
    private var dataSource: DataSource!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configDataSource()
        configNavBar()
    }
    
    private func configNavBar() {
        navigationItem.title = "Shopping List"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditState))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddVC))
    }


    private func configureTableView() {
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.backgroundColor = .systemGroupedBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
    
    private func configDataSource() {
        dataSource = DataSource(tableView: tableView, cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "\(item.name)"
            return cell
        })
        
        dataSource.defaultRowAnimation = .fade
        
        // setup initial animation
        var snapshot = NSDiffableDataSourceSnapshot<Category, Item>()
        
        // populate snapshot with sections and items for each section
        
        for category in Category.allCases {
            // filter the testData items for that particular category's items
            
            let items = Item.testData().filter {$0.category == category}
            snapshot.appendSections([category])
            snapshot.appendItems(items)
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    @objc private func toggleEditState() {
        
    }
    
    @objc private func presentAddVC() {
        // 1. create a add item vc swift file
        // 2. create add item vc storyboard
        // 3. add 2 text fields, one for item and one for price
        // 4. add picker view for category
        // 5. user is able to add item and submit to items
        // 6. use communication paradigm to get item from add item vc to table view
        // examples: delegation, notification center, KVO, unwind segue, callback, combine
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let addItemVC = storyboard?.instantiateViewController(identifier: "addItemController") as? AddItemController else {
            fatalError()
        }
        addItemVC.delegate = self
        navigationController?.pushViewController(addItemVC, animated: true)
        
    }
    
    
}

extension ItemFeedController: AddItemDelegate {
    func didAddItem(item: Item) {
        var snapshot = dataSource.snapshot()
        
        dataSource.defaultRowAnimation = .fade
        snapshot.appendItems([item], toSection: item.category)
        dataSource.apply(snapshot,animatingDifferences: true)
    }
    
}
