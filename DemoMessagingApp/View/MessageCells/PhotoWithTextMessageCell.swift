//
//  PhotoWithTextMessageCell.swift
//  DemoMessagingApp
//
//  Created by Hassan Rafique Awan on 02/02/2022.
//

import UIKit

class PhotoWithTextMessageCell: UICollectionViewCell, MessageCell {
    // MARK: - Static Properties
    static let identifier = "PhotoWithTextMessageCell"
    static let grayBubbleImage = UIImage(named: "bubble_gray")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    static let blueBubbleImage = UIImage(named: "bubble_blue")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    
    
    // MARK: - UIViews
    private lazy var photoImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 15
        imgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
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
        imageView.image = PhotoWithTextMessageCell.blueBubbleImage
        imageView.tintColor = UIColor(white: 0.90, alpha: 1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.addSubview(bubbleImageView)
        view.addSubview(photoImgView)
        view.addSubview(messageLabel)
        view.addSubview(timeLabel)
        
        photoLeading = photoImgView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        photoTrailing = photoImgView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        
        let messageLeading = messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8)
        let messageTrailing = messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        
        let timeLeading = timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8)
        let timeTrailing = timeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        
        leadingConstraintOfSubViews.append(timeLeading)
        leadingConstraintOfSubViews.append(messageLeading)

        trailingConstraintOfSubViews.append(timeTrailing)
        trailingConstraintOfSubViews.append(messageTrailing)

        NSLayoutConstraint.activate([
            photoLeading!,
            photoTrailing!,
            photoImgView.topAnchor.constraint(equalTo: view.topAnchor),
            
            messageLeading,
            messageTrailing,
            messageLabel.topAnchor.constraint(equalTo: photoImgView.bottomAnchor, constant: 3),
            messageLabel.bottomAnchor.constraint(equalTo: timeLabel.topAnchor, constant: -3),
            
            timeTrailing,
            timeLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15),
            timeLeading,
            timeLabel.heightAnchor.constraint(equalToConstant: 10),

        ])
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // MARK: - Properties
    var message: Message {
        didSet {
            self.photoImgView.image = message.image
            self.messageLabel.text = message.content
            self.timeLabel.text = message.messageTime.toTimeString()
            self.updateUIView()
        }
    }
    
    private var mainViewLeadingConstraint: NSLayoutConstraint?
    private var mainViewTrailingConstraint: NSLayoutConstraint?
    private var mainViewWidthConstraint: NSLayoutConstraint?
    private var photoTrailing: NSLayoutConstraint?
    private var photoLeading: NSLayoutConstraint?
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
        mainViewWidthConstraint = mainView.widthAnchor.constraint(equalToConstant: 310)
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainViewLeadingConstraint!,
            mainViewTrailingConstraint!,
            mainViewWidthConstraint!
        ])
    }
    
    private func updateUIView() {
        let size = PhotoMessageCell.getImageCellSize(message: message)
        if message.sender.id == 1 {
            bubbleImageView.image = PhotoWithTextMessageCell.blueBubbleImage
            bubbleImageView.tintColor = .tintColor.withAlphaComponent(0.7)
            
            messageLabel.textColor = .white
            timeLabel.textColor = .white.withAlphaComponent(0.5)
            
            mainViewTrailingConstraint?.isActive = true
            mainViewLeadingConstraint?.isActive = false
            mainViewWidthConstraint?.constant = size.width
            
            photoLeading?.constant = 3
            photoTrailing?.constant = -9
            for constraint in trailingConstraintOfSubViews {
                constraint.constant = -15
            }
        } else {
            bubbleImageView.image = PhotoWithTextMessageCell.grayBubbleImage
            bubbleImageView.tintColor = .init(white: 0.9, alpha: 1)
            
            messageLabel.textColor = .black
            timeLabel.textColor = .black.withAlphaComponent(0.5)
            
            mainViewTrailingConstraint?.isActive = false
            mainViewLeadingConstraint?.isActive = true
            mainViewWidthConstraint?.constant = size.width
            
            photoLeading?.constant = 8
            photoTrailing?.constant = -3
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
