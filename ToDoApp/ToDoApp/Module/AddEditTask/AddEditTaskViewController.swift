//
//  AddEditTaskViewController.swift
//  ToDoApp
//
//  Created by Sawy on 06.12.23.
//

import UIKit
import Combine

class AddEditTaskViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet private weak var titleTextField: UITextField!
    
    // MARK: Properties
    private let viewModel: AddEditTaskViewModel
    private var cancellables: Set<AnyCancellable> = []
    private lazy var saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
    
    // MARK: Init
    init(viewModel: AddEditTaskViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: "AddEditTaskViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        bindViewModel()
    }
}

private extension AddEditTaskViewController {
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func saveButtonTapped() {
        viewModel.saveButtonTapped()
    }
    
    func bindViewModel() {
        let textFieldPublisher = NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: titleTextField)
            .compactMap { ($0.object as? UITextField)?.text }
        
        textFieldPublisher
            .assign(to: \.title, on: viewModel)
            .store(in: &cancellables)
        
        viewModel.$title
            .compactMap { $0 }
            .assign(to: \.text, on: titleTextField)
            .store(in: &cancellables)
        
        viewModel.$isButtonEnabled
            .assign(to: \.isEnabled, on: saveButton)
            .store(in: &cancellables)
    }
}
