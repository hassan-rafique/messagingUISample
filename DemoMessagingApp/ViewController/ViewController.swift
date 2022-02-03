//
//  ViewController.swift
//  DemoMessagingApp
//
//  Created by Hassan Rafique Awan on 02/02/2022.
//

import UIKit

class ViewController: UIViewController {

    private lazy var imgLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .logo
        return imageView
    }()
    
    private lazy var startButton: UIButton = {
        var configuration = UIButton.Configuration.gray()
        configuration.cornerStyle = .capsule
        configuration.baseBackgroundColor = .tintColor
        configuration.baseForegroundColor = .white
        configuration.buttonSize = .large
        configuration.title = "Start Chat"
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.addTarget(self, action: #selector(btnStartAction(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var horixontalStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    
    private var messagesList: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    private func setupView() {
        
        horixontalStack = UIStackView(arrangedSubviews: [imgLogo, startButton])
        horixontalStack.axis = .vertical
        horixontalStack.spacing = view.frame.height * 0.4
        view.addSubview(horixontalStack)
        
        self.layoutViews()
    }
    
    private func layoutViews() {
        imgLogo.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false
        horixontalStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            horixontalStack.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8),
            horixontalStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            horixontalStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
}

// MARK: - Functionality Methods
extension ViewController {
    @objc func btnStartAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(MessageViewController(), animated: true)
    }
}
