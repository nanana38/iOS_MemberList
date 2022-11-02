//
//  DetailViewController.swift
//  [iOS] MemberList
//
//  Created by 유현이 on 2022/11/02.
//

import UIKit
import PhotosUI

final class DetailViewController: UIViewController {

    private let detailView = DetailView()
    
    weak var delegate: MemberDelegate?
    
    var member: Member?
    
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupButtonAction()
        setupTapGestures()
    }
    
    func setupData() {
        detailView.member = member
    }
    
    func setupButtonAction() {
        detailView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    func setupTapGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchUpImageView))
        detailView.mainImageView.addGestureRecognizer(tapGesture)
        detailView.mainImageView.isUserInteractionEnabled = true
    }
    
    @objc func touchUpImageView() {
        setupImagePicker()
    }
    
    func setupImagePicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0
        configuration.filter = .any(of: [.images, .videos])
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @objc func saveButtonTapped() {
        if member == nil {
            let name = detailView.nameTextField.text ?? ""
            let age = Int(detailView.ageTextField.text ?? "")
            let phoneNumber = detailView.phoneNumberTextField.text ?? ""
            let address = detailView.addressTextField.text ?? ""

            var newMember =
            Member(name: name, age: age, phone: phoneNumber, address: address)
            
            newMember.memberImage = detailView.mainImageView.image
            
            delegate?.addNewMember(newMember)
            
//            let index = navigationController!.viewControllers.count - 2
//            let vc = navigationController?.viewControllers[index] as! ViewController
//            vc.memberListManager.makeNewMember(newMember)
//            
            
        } else {
            member!.memberImage = detailView.mainImageView.image
            let memberId = Int(detailView.memberIdTextField.text!) ?? 0
            member!.name = detailView.nameTextField.text ?? ""
            member!.age = Int(detailView.ageTextField.text ?? "") ?? 0
            member!.phone = detailView.phoneNumberTextField.text ?? ""
            member!.address = detailView.addressTextField.text ?? ""
            
            delegate?.update(index: memberId, member!)
            
//            detailView.member = member
//            let index = navigationController!.viewControllers.count - 2
//            let vc = navigationController?.viewControllers[index] as! ViewController
//            vc.memberListManager.updateMemberInfo(index: memberId, member!)
        }
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    deinit {
        print("디테일 뷰컨트롤러 해제")
    }
}

extension DetailViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    self.detailView.mainImageView.image = image as? UIImage
                }
            }
        } else {
            print("이미지 오류")
        }
    }
}
