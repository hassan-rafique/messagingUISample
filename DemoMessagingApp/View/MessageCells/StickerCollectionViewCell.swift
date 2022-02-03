//
//  StickerCollectionViewCell.swift
//  DemoMessagingApp
//
//  Created by Hassan Rafique Awan on 03/02/2022.
//

import UIKit
import Kingfisher

class StickerCollectionViewCell: UICollectionViewCell, MessageCell {
    
    // MARK: - Static Properties
    static let identifier = "StickerCollectionViewCell"

    // MARK: - UIViews
    lazy var gifImageView: AnimatedImageView = {
        let imageView = AnimatedImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
   
    // MARK: - Properties
    var message: Message {
        didSet {
            gifImageView.kf.setImage(with: message.gifUrl)
            updateUI()
        }
    }
    private var leadingConstraint: NSLayoutConstraint?
    private var trailingConstraint: NSLayoutConstraint?
    
    
    // MARK: - Initialize View
    override init(frame: CGRect) {
        message = Message(content: "", type: .sticker, sender: User(id: 0, name: ""))
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gifImageView.image = nil
        leadingConstraint?.isActive = false
        trailingConstraint?.isActive = false
    }
    
    private func setupView() {
        contentView.addSubview(gifImageView)
        layoutViews()
    }
    
    private func layoutViews() {
        leadingConstraint = gifImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        trailingConstraint = gifImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        NSLayoutConstraint.activate([
            gifImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            gifImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            gifImageView.widthAnchor.constraint(equalTo: gifImageView.heightAnchor, multiplier: 1)
        ])
    }
    
    private func updateUI() {
        if message.sender.id == 1 {
            trailingConstraint?.isActive = true
            leadingConstraint?.isActive = false
        } else {
            trailingConstraint?.isActive = false
            leadingConstraint?.isActive = true
        }
    }
}
