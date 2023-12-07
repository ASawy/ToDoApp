//
//  ToDoListViewController.swift
//  ToDoApp
//
//  Created by Sawy on 30.11.23.
//

import UIKit
import Combine

class ToDoListViewController: UIViewController {
    // MARK: Properties
    private lazy var toDoListTableView = UITableView()
    private let toDoCellIdentifier = "ToDoTableViewCell"
    private var cancellables: Set<AnyCancellable> = []
    private let viewModel: ToDoListViewModel
    
    // MARK: Init
    init(viewModel: ToDoListViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTableView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.loadToDoList()
    }
}

// MARK: - private extension
private extension ToDoListViewController {
    func setupNavigationBar() {
        let addButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addButtonTapped() {
        viewModel.addButtonTapped()
    }
    
    func setupTableView() {
        view.addSubview(toDoListTableView)
        toDoListTableView.frame = view.bounds
        toDoListTableView.separatorStyle = .none
        
        toDoListTableView.delegate = self
        toDoListTableView.dataSource = self
        
        toDoListTableView.register(UINib(nibName: toDoCellIdentifier, bundle: nil),
                                   forCellReuseIdentifier: toDoCellIdentifier)
    }
    
    func bindViewModel() {
        viewModel.$tasks
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.toDoListTableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

// MARK: - UITableViewDataSource
extension ToDoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: toDoCellIdentifier, for: indexPath) as? ToDoTableViewCell else {
            return UITableViewCell()
        }
        
        let cellViewModel = viewModel.createToDoTableCellViewModel(with: indexPath.row)
        cell.configure(with: cellViewModel)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ToDoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.taskDidSelect(at: indexPath.row)
    }
}
