//
//  PTHistoryViewController.swift
//  PomodoroTimer
//
//  Created by retina on 13/12/2017.
//  Copyright © 2017 Marcos Borges. All rights reserved.
//

import UIKit
import RxSwift

class PTHistoryViewController: BaseViewController {
    
    // MARK: - Private variables
    private let viewModel = PTHistoryViewModel()
    private var disposeBag = DisposeBag()
    
    // MARK: - IBOutlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Overridden methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = PTConstants.Titles.history
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerCell = tableView.dequeueReusableCell(withIdentifier: PTSectionHeaderCell.reuseIdentifier) as? PTSectionHeaderCell else {
            return UITableViewCell()
        }
        
        let title = self.viewModel.dataSourceKeys[section]
        var sectionTitle = ""
        
        switch title {
        case Date().formattedDate():
            sectionTitle = PTConstants.Titles.today
        case Date().yesterday.formattedDate():
            sectionTitle = PTConstants.Titles.yesterday
        default:
            sectionTitle = self.viewModel.dataSourceKeys[section]
        }

        headerCell.sectionTitleLabel.text = sectionTitle
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
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
