//
//  EditUserVC.swift
//  Agewise
//
//  Created by 최대성 on 9/1/24.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI

final class EditUserVC: BaseVC, PHPickerViewControllerDelegate {
    
    
    private let editUserView = EditUserView()
    
    private let editUserVM = EditUserVM()
    
    private let disposeBag = DisposeBag()
    private var selectedImageViews: UIImageView?
    private let selectedImage = BehaviorRelay<Data?>(value: nil)
    
    override func loadView() {
        view = editUserView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        
        let input = EditUserVM.Input(photoPickTap:  editUserView.photoPicker.rx.tap, nick: editUserView.nicknameTextField.rx.text.orEmpty, profile: selectedImage, editTap: editUserView.editButton.rx.tap)
        
        
        let output = editUserVM.transform(input: input)
        
        
        output.photoPickTap
            .bind(with: self) { owner, _ in
                owner.openGallery()
            }
            .disposed(by: disposeBag)
    }
    
    private func openGallery() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        selectedImageViews = editUserView.imageView
        
        for (index, result) in results.enumerated() {
            guard index < 1 else { break }
            
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
                if let image = object as? UIImage,
                   let imageData = image.pngData(){
                    DispatchQueue.main.async {
                        self?.selectedImageViews?.image = image
                        self?.selectedImage.accept(imageData)
                    }
                }
            }
        }
    }
}
