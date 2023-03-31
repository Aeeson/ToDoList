import Foundation
import UIKit
import ToDoItemModel

final class PreviewViewController: UIViewController {
    
    // MARK: - Properties
    
    var item: ToDoItem?
    private lazy var dateMapper = DateMapper()
    
    // MARK: - Subviews
    
    private lazy var itemLabel: UILabel = {
        let itemLabel = UILabel()
        itemLabel.translatesAutoresizingMaskIntoConstraints = false
        itemLabel.text = Texts.task
        itemLabel.font = UIFont.systemFont(ofSize: 20)
        return itemLabel
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor.Editor.backSecondary
        textView.layer.cornerRadius = 16
        textView.textColor = UIColor.Editor.labelPrimary
        textView.font = UIFont.systemFont(ofSize: 17)
        return textView
    }()
    
    private lazy var propertiesView: UIView = {
        let propertiesView = UIView()
        propertiesView.translatesAutoresizingMaskIntoConstraints = false
        propertiesView.layer.cornerRadius = 16
        propertiesView.backgroundColor = UIColor.Editor.backSecondary
        return propertiesView
    }()
    
    private lazy var priorityLabel: UILabel = {
        let priorityLabel = UILabel()
        priorityLabel.translatesAutoresizingMaskIntoConstraints = false
        priorityLabel.text = Texts.priotity + ":"
        priorityLabel.font = UIFont.systemFont(ofSize: 17)
        priorityLabel.textColor = UIColor.Editor.labelPrimary
        return priorityLabel
    }()
    
    private lazy var deadlineLabel: UILabel = {
        let deadlineLabel = UILabel()
        deadlineLabel.translatesAutoresizingMaskIntoConstraints = false
        deadlineLabel.text = Texts.doUntil + ":"
        deadlineLabel.font = UIFont.systemFont(ofSize: 17)
        deadlineLabel.textColor = UIColor.Editor.labelPrimary
        return deadlineLabel
    }()
    
    private lazy var deadlineDateLabel: UILabel = {
        let deadlineDateLabel = UILabel()
        deadlineDateLabel.translatesAutoresizingMaskIntoConstraints = false
        deadlineDateLabel.font = UIFont.systemFont(ofSize: 17)
        deadlineDateLabel.textAlignment = .right
        deadlineDateLabel.textColor = UIColor.Editor.labelPrimary
        return deadlineDateLabel
    }()
    
    private lazy var priorityStatusLabel: UILabel = {
        let priorityLabel = UILabel()
        priorityLabel.translatesAutoresizingMaskIntoConstraints = false
        priorityLabel.font = UIFont.systemFont(ofSize: 17)
        priorityLabel.textColor = UIColor.Editor.labelPrimary
        priorityLabel.textAlignment = .right
        return priorityLabel
    }()
    
    private lazy var isDoneLabel: UILabel = {
        let isDoneLabel = UILabel()
        isDoneLabel.translatesAutoresizingMaskIntoConstraints = false
        isDoneLabel.text = Texts.isDone
        isDoneLabel.font = UIFont.systemFont(ofSize: 17)
        return isDoneLabel
    }()
    
    private lazy var statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.font = UIFont.systemFont(ofSize: 17)
        statusLabel.textAlignment = .right
        return statusLabel
    }()
    
    private lazy var firstLineView: UIView = {
        let firstLineView = UIView()
        firstLineView.translatesAutoresizingMaskIntoConstraints = false
        firstLineView.backgroundColor = UIColor.Editor.supportSeparator
        return firstLineView
    }()
    
    private lazy var secondLineView: UIView = {
        let secondLineView = UIView()
        secondLineView.translatesAutoresizingMaskIntoConstraints = false
        secondLineView.backgroundColor = UIColor.Editor.supportSeparator
        return secondLineView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setConstraints()
        
        if let item = item {
            textView.text = item.text
            switch item.priority {
            case .important:
                priorityStatusLabel.text = Texts.important
                priorityStatusLabel.textColor = UIColor.Editor.red
            case .regular:
                priorityStatusLabel.text = Texts.regular
            case .unimportant:
                priorityStatusLabel.text = Texts.unimportant
                priorityStatusLabel.textColor = UIColor.Editor.labelTertiary
            }
            if let ddl = item.deadline {
                deadlineDateLabel.text = dateMapper.defaultFormat(from: ddl)
            } else {
                deadlineDateLabel.text = "-"
            }
            if item.isDone {
                statusLabel.text = "Да"
            } else {
                statusLabel.text = "Нет"
            }
        }
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        itemLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        itemLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        itemLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        textView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        textView.topAnchor.constraint(equalTo: itemLabel.bottomAnchor, constant: 16).isActive = true
        textView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        textView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -259).isActive = true
        
        propertiesView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        propertiesView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        propertiesView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        propertiesView.heightAnchor.constraint(equalToConstant: 171).isActive = true
        
        priorityLabel.leftAnchor.constraint(equalTo: propertiesView.leftAnchor, constant: 16).isActive = true
        priorityLabel.topAnchor.constraint(equalTo: propertiesView.topAnchor, constant: 17).isActive = true
        priorityLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        priorityLabel.widthAnchor.constraint(equalToConstant: 85).isActive = true
        
        deadlineLabel.leftAnchor.constraint(equalTo: propertiesView.leftAnchor, constant: 16).isActive = true
        deadlineLabel.topAnchor.constraint(equalTo: propertiesView.topAnchor, constant: 73.5).isActive = true
        deadlineLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        deadlineLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        priorityStatusLabel.topAnchor.constraint(equalTo: propertiesView.topAnchor, constant: 17).isActive = true
        priorityStatusLabel.rightAnchor.constraint(equalTo: propertiesView.rightAnchor, constant: -16).isActive = true
        priorityStatusLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        priorityStatusLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        deadlineDateLabel.leftAnchor.constraint(equalTo: propertiesView.leftAnchor, constant: 116).isActive = true
        deadlineDateLabel.topAnchor.constraint(equalTo: propertiesView.topAnchor, constant: 73.5).isActive = true
        deadlineDateLabel.rightAnchor.constraint(equalTo: propertiesView.rightAnchor, constant: -16).isActive = true
        deadlineDateLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        isDoneLabel.leftAnchor.constraint(equalTo: propertiesView.leftAnchor, constant: 16).isActive = true
        isDoneLabel.bottomAnchor.constraint(equalTo: propertiesView.bottomAnchor, constant: -17).isActive = true
        isDoneLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        isDoneLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        statusLabel.rightAnchor.constraint(equalTo: propertiesView.rightAnchor, constant: -16).isActive = true
        statusLabel.bottomAnchor.constraint(equalTo: propertiesView.bottomAnchor, constant: -17).isActive = true
        statusLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        statusLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        firstLineView.leftAnchor.constraint(equalTo: propertiesView.leftAnchor, constant: 16).isActive = true
        firstLineView.bottomAnchor.constraint(equalTo: propertiesView.topAnchor, constant: 56).isActive = true
        firstLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        firstLineView.widthAnchor.constraint(equalTo: propertiesView.widthAnchor, constant: -32).isActive = true
        
        secondLineView.leftAnchor.constraint(equalTo: propertiesView.leftAnchor, constant: 16).isActive = true
        secondLineView.topAnchor.constraint(equalTo: firstLineView.bottomAnchor, constant: 58).isActive = true
        secondLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        secondLineView.widthAnchor.constraint(equalTo: propertiesView.widthAnchor, constant: -32).isActive = true
    }
    
    private func setLayout() {
        view.backgroundColor = UIColor.Editor.backPrimary
        view.addSubview(itemLabel)
        view.addSubview(textView)
        view.addSubview(propertiesView)
        propertiesView.addSubview(priorityLabel)
        propertiesView.addSubview(deadlineLabel)
        propertiesView.addSubview(priorityStatusLabel)
        propertiesView.addSubview(deadlineDateLabel)
        propertiesView.addSubview(firstLineView)
        propertiesView.addSubview(secondLineView)
        propertiesView.addSubview(isDoneLabel)
        propertiesView.addSubview(statusLabel)
    }
}
