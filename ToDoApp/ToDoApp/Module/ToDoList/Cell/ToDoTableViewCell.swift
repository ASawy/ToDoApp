//
//  ToDoTableViewCell.swift
//  ToDoApp
//
//  Created by Sawy on 30.11.23.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {
    // MARK: Outlet
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var doneButton: UIButton!
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: Function
    func configure(with item: TaskItem) {
        titleLabel.text = "\(item.displayTaskId) - \(item.title)"
        
        let buttonImage = item.completed ? "checkmark.circle.fill" : "checkmark.circle"
        doneButton.setImage(UIImage(systemName: buttonImage), for: .normal)
    }
}
