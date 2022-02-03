//
//  NavigationHeaderView.swift
//  DemoMessagingApp
//
//  Created by Hassan Rafique Awan on 02/02/2022.
//

import UIKit

final class NavigationHeaderView: UIView {

    var height: CGFloat {
        return 54
    }

    var menuButtonAction: (() -> Void)?

    var title: String = "" {
        didSet {
            self.navLabel.text = title
        }
    }
    
    var detail: String = "" {
        didSet {
            self.navLabelDetail.text = detail
        }
    }
    
    private lazy var labelStackView = UIStackView()
    
    private lazy var navLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.contentMode = .center
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 19)
        return label
    }()
    
    private lazy var navLabelDetail: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.contentMode = .center
        label.textColor = .white.withAlphaComponent(0.5)
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()

    private lazy var navButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFit
        button.tintColor = .white
        button.setImage(.backIcon, for: .normal)
        return button
    }()

    private lazy var imgUser: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 22
        imageView.image = .smithAvatar
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .tintColor
        setupViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        labelStackView = UIStackView(arrangedSubviews: [navLabel, navLabelDetail])
        labelStackView.axis = .vertical
        labelStackView.spacing = 0
        addSubview(labelStackView)
        
        addSubview(navButton)
        addSubview(imgUser)

        navButton.addTarget(self, action: #selector(didTapMenuButton), for: .touchUpInside)

    }
    
    private func layoutViews() {
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        navButton.translatesAutoresizingMaskIntoConstraints = false
        imgUser.translatesAutoresizingMaskIntoConstraints = false

        
        labelStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        labelStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        labelStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        navButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        navButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        navButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        navButton.centerYAnchor.constraint(equalTo: labelStackView.centerYAnchor).isActive = true
        
        imgUser.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        imgUser.widthAnchor.constraint(equalToConstant: 44).isActive = true
        imgUser.heightAnchor.constraint(equalToConstant: 44).isActive = true
        imgUser.centerYAnchor.constraint(equalTo: labelStackView.centerYAnchor).isActive = true
    }
    
    @objc private func didTapMenuButton() {
        if let action = self.menuButtonAction {
            action()
        }
    }
    

}
