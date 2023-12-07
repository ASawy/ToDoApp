//
//  ToDoTableViewCell.swift
//  ToDoApp
//
//  Created by Sawy on 30.11.23.
//

import UIKit
import Combine

class ToDoTableViewCell: UITableViewCell {
    // MARK: Outlet
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var doneButton: UIButton!
    
    // MARK: Properties
    private var viewModel: ToDoTableCellViewModel?
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Function
    func configure(with viewModel: ToDoTableCellViewModel) {
        self.viewModel = viewModel
        bindViewModel()
        
        viewModel.configureCell()
    }
    
    // MARK: User action
    @IBAction private func done(_ sender: Any) {
        viewModel?.doneButtonTapped()
    }
}

private extension ToDoTableViewCell {
    func bindViewModel() {
        viewModel?.$title
            .compactMap { $0 }
            .assign(to: \.text, on: titleLabel)
            .store(in: &cancellables)
        
        viewModel?.$buttonImageName
            .sink { [weak self] imageName in
                guard let self = self else { return }
                let image = UIImage(systemName: imageName)
                self.doneButton.setImage(image, for: .normal)
            }
            .store(in: &cancellables)
    }
}
