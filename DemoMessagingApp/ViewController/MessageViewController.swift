//
//  MessageVC.swift
//  DemoMessagingApp
//
//  Created by Hassan Rafique Awan on 02/02/2022.
//

import UIKit
import Messages

class MessageViewController: UIViewController {
    
    // MARK: - UIViews
    private lazy var navHeaderView: NavigationHeaderView = {
        let headerView = NavigationHeaderView(frame: .zero)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.menuButtonAction = { self.navigationController?.popViewController(animated: true) }
        return headerView
    }()
    
    private lazy var chatCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(TextMessageCell.self, forCellWithReuseIdentifier: TextMessageCell.identifier)
        collectionView.register(PhotoMessageCell.self, forCellWithReuseIdentifier: PhotoMessageCell.identifier)
        collectionView.register(PhotoWithTextMessageCell.self, forCellWithReuseIdentifier: PhotoWithTextMessageCell.identifier)
        collectionView.register(StickerCollectionViewCell.self, forCellWithReuseIdentifier: StickerCollectionViewCell.identifier)
        return collectionView
    }()
    
    
    // MARK: - Bottom Sheet Views
    private lazy var attachmentButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.tintColor = .tintColor
        button.setImage(.attachment, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(btnAttachmentAction(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.tintColor = .tintColor
        button.setImage(.send, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(btnSendMessageAction(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var txtMessage: UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .none
        textfield.textColor = .white
        textfield.font = .systemFont(ofSize: 16, weight: .medium)
        textfield.placeholder = "Broadcast"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private lazy var stickerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.tintColor = .white.withAlphaComponent(0.7)
        button.setImage(.keybpard, for: .normal)
        button.setImage(.sticker, for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(btnStickerAction(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var textView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 22
        
        view.addSubview(txtMessage)
        view.addSubview(stickerButton)
        NSLayoutConstraint.activate([
            txtMessage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            txtMessage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            txtMessage.topAnchor.constraint(equalTo: view.topAnchor),
            txtMessage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stickerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            stickerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stickerButton.heightAnchor.constraint(equalToConstant: 20),
            stickerButton.widthAnchor.constraint(equalTo: stickerButton.heightAnchor, multiplier: 1)
        ])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var bottomSheet: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        view.addSubview(attachmentButton)
        view.addSubview(sendButton)
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            attachmentButton.widthAnchor.constraint(equalToConstant: 28),
            attachmentButton.heightAnchor.constraint(equalToConstant: 28),
            attachmentButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            attachmentButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 18),
            
            textView.leadingAnchor.constraint(equalTo: attachmentButton.trailingAnchor, constant: 8),
            textView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
            textView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            
            sendButton.widthAnchor.constraint(equalToConstant: 32),
            sendButton.heightAnchor.constraint(equalToConstant: 32),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            sendButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16)
            
        ])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var safeAreaView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    // MARK: - Sticker CollectionView
    private lazy var stickerCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.isHidden = true
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        collectionView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(StickerCollectionViewCell.self, forCellWithReuseIdentifier: StickerCollectionViewCell.identifier)

        return collectionView
    }()
    
    
    // MARK: - Properties
    private var viewModel = MessageViewModel()
    private var isShowingSticker = false
    private var bottomSheetConstraint: NSLayoutConstraint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        viewModel.delegate = self
        viewModel.prepareMockMessages()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollToBottom()
    }
    
    // MARK: - SetupView/SubViews
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(navHeaderView)
        view.addSubview(chatCollectionView)
        view.addSubview(bottomSheet)
        view.addSubview(safeAreaView)
        view.addSubview(stickerCollectionView)
        
        layoutViews()
        
        navHeaderView.title = "Smith"
        navHeaderView.detail = "1 Subscriber"
        
        chatCollectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    private func layoutViews() {
        bottomSheetConstraint = bottomSheet.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        NSLayoutConstraint.activate([
            navHeaderView.topAnchor.constraint(equalTo: view.topAnchor),
            navHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navHeaderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: navHeaderView.height),
            
            chatCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chatCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chatCollectionView.topAnchor.constraint(equalTo: navHeaderView.bottomAnchor),
            chatCollectionView.bottomAnchor.constraint(equalTo: bottomSheet.topAnchor),
            
            bottomSheetConstraint!,
            bottomSheet.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSheet.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSheet.heightAnchor.constraint(equalToConstant: 60),
            
            safeAreaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            safeAreaView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            safeAreaView.topAnchor.constraint(equalTo: bottomSheet.bottomAnchor),
            safeAreaView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stickerCollectionView.topAnchor.constraint(equalTo: bottomSheet.bottomAnchor),
            stickerCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stickerCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stickerCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}



// MARK: - Methods/Actions
extension MessageViewController {
    
    private func scrollToBottom() {
        let lastItem = self.viewModel.messagesList.count - 1
        let indexPath = IndexPath(item: lastItem, section: 0)
        self.chatCollectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
     @objc private func keyboardWillChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
         
        let bottomSafeArea = view.safeAreaInsets.bottom
        
        if !isShowingSticker {
            bottomSheetConstraint?.constant = isKeyboardShowing ? -(keyboardFrame.height - bottomSafeArea) : 0
        }
        stickerButton.isSelected = isKeyboardShowing ? true : false
        stickerCollectionView.isHidden = !isShowingSticker
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        } completion: { completed in
            if isKeyboardShowing {
                self.scrollToBottom()
            }
        }
    }
    
    
    @objc private func btnSendMessageAction(_ sender: UIButton) {
        guard let text = txtMessage.text, !text.isEmpty else {
            self.view.endEditing(true)
            return
        }
        
        txtMessage.text = ""
        viewModel.sendTextMessage(text)
    }
    
    @objc private func btnAttachmentAction(_ sender: UIButton) {
        openPhotoLibrary()
    }
    
    @objc private func btnStickerAction(_ sender: UIButton) {
        if sender.isSelected {
            isShowingSticker = true
            self.view.endEditing(true)
            isShowingSticker = false
        } else {
            isShowingSticker = false
            txtMessage.becomeFirstResponder()
        }
    }
}


// MARK: - MessageViewModelDelegate
extension MessageViewController: MessageViewModelDelegate {
    func didAddNewMessage(_ message: Message, atIndex index: Int) {
        self.chatCollectionView.insertItems(at: [IndexPath(item: index, section: 0)])
        self.scrollToBottom()
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension MessageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == chatCollectionView {
            return viewModel.messagesList.count
        }
        
        return viewModel.stickerList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == chatCollectionView {
            let messageObj = viewModel.messagesList[indexPath.item]
            
            if messageObj.type == .photo {
                let size = PhotoMessageCell.getImageCellSize(message: messageObj)
                let height = size.height - 11
                return CGSize(width: chatCollectionView.frame.width, height: height)
            }
            else if messageObj.type == .photoWithText {
                let size = PhotoMessageCell.getImageCellSize(message: messageObj)
                let textSize = TextMessageCell.getTextCellSize(message: messageObj)
                let height = size.height + textSize.height - 90
                return CGSize(width: chatCollectionView.frame.width, height: height)
            }
            else if messageObj.type == .sticker {
                return CGSize(width: chatCollectionView.frame.width, height: 180)
            }
            else {
                let size = TextMessageCell.getTextCellSize(message: messageObj)
                return CGSize(width: chatCollectionView.frame.width, height: size.height)
            }
        }
        
        let size = chatCollectionView.frame.width/3 - 10
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == chatCollectionView {
            
            let identifier = viewModel.chatCellIdentifierForRowAtIndexPath(indexPath)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:identifier , for: indexPath)
            if var messageCell = cell as? MessageCell {
                messageCell.message = viewModel.messagesList[indexPath.row]
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StickerCollectionViewCell.identifier, for: indexPath) as! StickerCollectionViewCell
            cell.backgroundColor = .clear
            cell.gifImageView.kf.setImage(with: viewModel.stickerList[indexPath.item])
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == stickerCollectionView {
            viewModel.sendGifSticker(gifUrl: viewModel.stickerList[indexPath.item])
        }
    }

}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension MessageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openPhotoLibrary() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = .photoLibrary
        self.present(pickerController, animated: true)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        txtMessage.text = ""
        viewModel.sendPhotoMessage(image: image, withText: txtMessage.text!)
    }
}
