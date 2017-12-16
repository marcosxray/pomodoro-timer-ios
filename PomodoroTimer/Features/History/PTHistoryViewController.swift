//
//  PTHistoryViewController.swift
//  PomodoroTimer
//
//  Created by retina on 13/12/2017.
//  Copyright © 2017 Marcos Borges. All rights reserved.
//

import UIKit
import RxSwift

class PTHistoryViewController: UIViewController {
    
    // MARK: - Private variables
    private let viewModel = PTHistoryViewModel()
    private var disposeBag = DisposeBag()
    
    // MARK: - IBOutlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Overridden methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.reloadData()
        setupVisuals()
        setupRx()
    }
    
    // MARK: - Private methods
    private func setupVisuals() {
        tableView.tableFooterView = UIView()
    }
    
    private func setupRx() {
        viewModel.dataSource.asObservable().subscribe(onNext: { pomodoros in
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
}

// MARK: - TableView Extensions
extension PTHistoryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.dataSource.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.value[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = self.viewModel.dataSourceKeys[section]
        
        print("\(Date()), \(title)")
        
        
        if title == Date().formattedDate() { return "TODAY" }
        if title == Date().yesterday.formattedDate() { return "YESTERDAY" }
        return self.viewModel.dataSourceKeys[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PTHistoryCell.reuseIdentifier, for: indexPath) as? PTHistoryCell else {
            return UITableViewCell()
        }
        
        let pomodoro = viewModel.dataSource.value[indexPath.section][indexPath.row]
        cell.configureLayout(pomodoro: pomodoro)
        
        return cell
    }
}

extension PTHistoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}