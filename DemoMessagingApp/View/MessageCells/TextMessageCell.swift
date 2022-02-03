//
//  TextMessageCell.swift
//  DemoMessagingApp
//
//  Created by Hassan Rafique Awan on 02/02/2022.
//

import UIKit

class TextMessageCell: UICollectionViewCell, MessageCell {
    
    // MARK: - Static Properties & Methods
    
    static let identifier = "TextMessageCell"
    static let grayBubbleImage = UIImage(named: "bubble_gray")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    static let blueBubbleImage = UIImage(named: "bubble_blue")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    
    static func getTextCellSize(message: Message) -> CGRect {
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        var estimatedFrame = NSString(string: message.content).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], context: nil)
        estimatedFrame.size.height += 65
        
        let nameSize = NSString(string: message.sender.name).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)], context: nil)
        
        let maxValue = max(estimatedFrame.width, nameSize.width)
        estimatedFrame.size.width = maxValue + 40
        
        return estimatedFrame
    }

    
    
    // MARK: - UIViews
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .tintColor
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .right
        return label
    }()
    
    private lazy var bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = TextMessageCell.blueBubbleImage
        imageView.tintColor = UIColor(white: 0.90, alpha: 1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.addSubview(bubbleImageView)
        view.addSubview(userNameLabel)
        view.addSubview(messageLabel)
        view.addSubview(timeLabel)
        
        let usernameLeading = userNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8)
        let usernameTrailing = userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        
        let messageLeading = messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8)
        let messageTrailing = messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        
        let timeLeading = timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8)
        let timeTrailing = timeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        
        leadingConstraintOfSubViews.append(usernameLeading)
        leadingConstraintOfSubViews.append(messageLeading)
        leadingConstraintOfSubViews.append(timeLeading)
        
        trailingConstraintOfSubViews.append(usernameTrailing)
        trailingConstraintOfSubViews.append(messageTrailing)
        trailingConstraintOfSubViews.append(timeTrailing)

        NSLayoutConstraint.activate([
            usernameLeading,
            usernameTrailing,
            userNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            userNameLabel.heightAnchor.constraint(equalToConstant: 16),
            
            messageLeading,
            messageTrailing,
            messageLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 3),
            messageLabel.bottomAnchor.constraint(equalTo: timeLabel.topAnchor, constant: -3),
            
            timeTrailing,
            timeLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15),
            timeLeading,
            timeLabel.heightAnchor.constraint(equalToConstant: 10),

        ])
        
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // MARK: - Properties
    var message: Message {
        didSet {
            self.messageLabel.text = message.content
            self.userNameLabel.text = message.sender.name
            self.timeLabel.text = message.messageTime.toTimeString()
            self.updateUIView()
        }
    }
    private var mainViewLeadingConstraint: NSLayoutConstraint?
    private var mainViewTrailingConstraint: NSLayoutConstraint?
    private var mainViewWidthConstraint: NSLayoutConstraint?
    private var leadingConstraintOfSubViews: [NSLayoutConstraint] = []
    private var trailingConstraintOfSubViews: [NSLayoutConstraint] = []
    
    
    // MARK: - Initialize View
    override init(frame: CGRect) {
        message = Message(content: "", type: .none, sender: User(id: 0, name: ""))
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainViewLeadingConstraint?.isActive = false
        mainViewTrailingConstraint?.isActive = false
    }
    
    
    private func setupView() {
        contentView.addSubview(mainView)
        
        layoutViews()
        addConstraintsWithVisualStrings(format: "H:|[v0]|", views: bubbleImageView)
        addConstraintsWithVisualStrings(format: "V:|[v0]|", views: bubbleImageView)
        
    }
    
    private func layoutViews() {
        mainViewLeadingConstraint = mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
        mainViewTrailingConstraint = mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        mainViewWidthConstraint = mainView.widthAnchor.constraint(equalToConstant: 100)
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainViewLeadingConstraint!,
            mainViewTrailingConstraint!,
            mainViewWidthConstraint!
        ])
    }
    
    private func updateUIView() {
        let maxWidth = UIScreen.main.bounds.width * 0.7
        let size = TextMessageCell.getTextCellSize(message: message)
        if message.sender.id == 1 {
            bubbleImageView.image = TextMessageCell.blueBubbleImage
            bubbleImageView.tintColor = .tintColor.withAlphaComponent(0.7)
            
            messageLabel.textColor = .white
            timeLabel.textColor = .white.withAlphaComponent(0.5)
            
            mainViewTrailingConstraint?.isActive = true
            mainViewLeadingConstraint?.isActive = false
            mainViewWidthConstraint?.constant = size.width > maxWidth ? maxWidth : size.width
            
            for constraint in trailingConstraintOfSubViews {
                constraint.constant = -15
            }
        } else {
            bubbleImageView.image = TextMessageCell.grayBubbleImage
            bubbleImageView.tintColor = .init(white: 0.9, alpha: 1)
            
            messageLabel.textColor = .black
            timeLabel.textColor = .black.withAlphaComponent(0.5)
            
          
            mainViewTrailingConstraint?.isActive = false
            mainViewLeadingConstraint?.isActive = true
            mainViewWidthConstraint?.constant = size.width > maxWidth ? maxWidth : size.width
            
            for constraint in leadingConstraintOfSubViews {
                constraint.constant = 15
            }
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
}
