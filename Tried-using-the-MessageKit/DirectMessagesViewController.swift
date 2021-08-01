//
//  MessagesViewController.swift
//  Tried-using-the-MessageKit
//
//  Created by bookpro on 2021/08/01.
//  Copyright © 2021 routeflags. All rights reserved.
//

import UIKit
import Photos
import MessageKit
import InputBarAccessoryView
import Fakery

class DirectMessagesViewController: MessagesViewController {
	
	var user: User
	var messages: [Message] = []
	let faker = Faker()

	init(user: User) {
		self.user = user
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		var users = (0..<4).map { _ in User.init(name: faker.name.name() ) }
		users.append(self.user)
		self.messages = (0..<20).map { _ in Message.init(user: users[Int.random(in: 0..<5)],
														 content: faker.car.brand()) }
		messageViewConfigure()
		messagesCollectionView.reloadData()
		messagesCollectionView.scrollToLastItem()
	}
	
	func messageViewConfigure() {
		messagesCollectionView.messagesDataSource = self
		messagesCollectionView.messagesLayoutDelegate = self
		messagesCollectionView.messagesDisplayDelegate = self
		messagesCollectionView.messageCellDelegate = self
		messageInputBar.delegate = self

		scrollsToLastItemOnKeyboardBeginsEditing = true
		maintainPositionOnKeyboardFrameChanged = true
	}
	
	// MARK: - Action
	@objc private func cameraButtonTouched(sender: UIBarButtonItem) {
		let picker = UIImagePickerController()
		picker.delegate = self
		picker.sourceType = .photoLibrary
		present(picker, animated: true, completion: nil)
	}
	
	func createCameraInputBarItem() -> InputBarButtonItem {
		let cameraItem = InputBarButtonItem(type: .system)
		cameraItem.image = #imageLiteral(resourceName: "panel_ico_1_ready.png").withRenderingMode(.alwaysTemplate)
		cameraItem.addTarget(
			self,
			action: #selector(cameraButtonTouched(sender:)),
			for: .primaryActionTriggered
		)
		cameraItem.setSize(CGSize(width: 60, height: 30), animated: false)
		cameraItem.tintColor = .systemRed
		return cameraItem
	}
	
	func displayRetrievalError(title: String, message: String) {
//		presenter.showAleart(title: title, message: message)
	}
}

// MARK: - MessagesDataSource
extension DirectMessagesViewController: MessagesDataSource {
	func currentSender() -> SenderType {
		return Sender(id: self.user.uid.uuidString,
					  displayName: self.user.name)
	}
	
	func isMine(message: MessageType) -> Bool {
		return isFromCurrentSender(message: message)
	}
	
	func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
		return messages.count
	}
	
	func messageForItem(at indexPath: IndexPath,
						in messagesCollectionView: MessagesCollectionView) -> MessageType {
		return messages[indexPath.section]
	}
	
	func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
		if indexPath.section % 3 == 0 {
			return NSAttributedString(
				string: MessageKitDateFormatter.shared.string(from: message.sentDate),
				attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
							 NSAttributedString.Key.foregroundColor: UIColor.darkGray]
			)
		}
		return nil
	}
	
	func messageTopLabelAttributedText(for message: MessageType,
									   at indexPath: IndexPath) -> NSAttributedString? {
		let name = message.sender.displayName
		return NSAttributedString(string: name,
								  attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
	}
	
	func messageBottomLabelAttributedText(for message: MessageType,
										  at indexPath: IndexPath) -> NSAttributedString? {
		let dateString = DateFormatter().string(from: message.sentDate)
		return NSAttributedString(string: dateString,
								  attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
	}
}

// MARK: - MessagesDisplayDelegate
extension DirectMessagesViewController: MessagesDisplayDelegate {
	func textColor(for message: MessageType,
				   at indexPath: IndexPath,
				   in messagesCollectionView: MessagesCollectionView) -> UIColor {
		return isFromCurrentSender(message: message) ? .white : .darkText
	}
	
	func backgroundColor(for message: MessageType,
						 at indexPath: IndexPath,
						 in messagesCollectionView: MessagesCollectionView) -> UIColor {
		return isFromCurrentSender(message: message) ?
			UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1) :
			UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
	}
	
	func messageStyle(for message: MessageType,
					  at indexPath: IndexPath,
					  in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
		let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
		return .bubbleTail(corner, .curved)
	}
	
	func configureAvatarView(_ avatarView: AvatarView,
							 for message: MessageType,
							 at indexPath: IndexPath,
							 in messagesCollectionView: MessagesCollectionView) {
		let avatar = Avatar(initials: String(message.sender.displayName.first!))
		avatarView.set(avatar: avatar)
	}
}

// MARK: - MessagesLayoutDelegate
extension DirectMessagesViewController: MessagesLayoutDelegate {
	func cellTopLabelHeight(for message: MessageType,
							at indexPath: IndexPath,
							in messagesCollectionView: MessagesCollectionView) -> CGFloat {
		if indexPath.section % 3 == 0 { return 10 }
		return 0
	}
	
	func messageTopLabelHeight(for message: MessageType,
							   at indexPath: IndexPath,
							   in messagesCollectionView: MessagesCollectionView) -> CGFloat {
		return 16
	}
	
	func messageBottomLabelHeight(for message: MessageType,
								  at indexPath: IndexPath,
								  in messagesCollectionView: MessagesCollectionView) -> CGFloat {
		return 16
	}
}

// MARK: - MessageCellDelegate
extension DirectMessagesViewController: MessageCellDelegate {
	func didTapMessage(in cell: MessageCollectionViewCell) {
		print("Message tapped")
	}
}

//// MARK: - InputBarAccessoryViewDelegate
extension DirectMessagesViewController: InputBarAccessoryViewDelegate {
	internal func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
		print("inputBar")
		for component in inputBar.inputTextView.components {
			if let image = component as? UIImage {
				let imageMessage = Message.init(user: self.user,
												image: image)
				messages.append(imageMessage)
				messagesCollectionView.insertSections([messages.count - 1])
				
			} else if let text = component as? String {
				let attributedText = NSAttributedString(string: text,
														attributes: [.font: UIFont.systemFont(ofSize: 15),
																	 .foregroundColor: UIColor.white])
				let message = Message.init(user: self.user,
										   content: attributedText.string)
				messages.append(message)
				messagesCollectionView.insertSections([messages.count - 1])
			}
		}
		inputBar.inputTextView.text = String()
		messagesCollectionView.scrollToLastItem()
	}
}

// MARK: - UIImagePickerControllerDelegate
// todo
extension DirectMessagesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController,
							   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		picker.dismiss(animated: true, completion: nil)
		if let asset = info[.phAsset] as? PHAsset {
			let size = CGSize(width: 500, height: 500)
			PHImageManager.default().requestImage(for: asset,
												  targetSize: size,
												  contentMode: .aspectFit,
												  options: nil) { result, _ in
													guard let image = result else {
														return
													}
//													self.presenter.sendPhoto(image: image)
			}
		} else if let image = info[.originalImage] as? UIImage {
//			presenter.sendPhoto(image: image)
		}
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true, completion: nil)
	}
}


