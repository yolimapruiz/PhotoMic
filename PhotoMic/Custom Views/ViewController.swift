//
//  ViewController.swift
//  PhotoMic
//
//  Created by Yolima Pereira Ruiz on 16/10/24.
//

import UIKit
import PhotosUI

class ViewController: UIViewController, PHPickerViewControllerDelegate {
   
    private var model = PhotoEditorModel(image: nil)
    private var pickerButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        setupPickerButton()
    }

    private func setupPickerButton(){
        pickerButton.setTitle("Pick a photo", for: .normal)
        pickerButton.setTitleColor(UIColor.systemBlue, for: .normal)
        pickerButton.layer.borderColor = UIColor.systemBlue.cgColor
        pickerButton.layer.borderWidth = 1
        pickerButton.layer.cornerRadius = 25
        
        pickerButton.addTarget(self, action: #selector(pickPhoto), for: .touchUpInside)
        
        pickerButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pickerButton)
        
        NSLayoutConstraint.activate([
            pickerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pickerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            pickerButton.widthAnchor.constraint(equalToConstant: 120),
            pickerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    @objc private func pickPhoto(){
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let provider = results.first?.itemProvider,
        provider.canLoadObject(ofClass: UIImage.self) else { return }
        
        provider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
            DispatchQueue.main.async {
                if let uiImage = image as? UIImage {
                    self?.model.originalImage = uiImage
                    self?.model.editedImage = uiImage
                    self?.navigateToSelectedPhotoView()
                }
            }
        }
    }
    
    private func navigateToSelectedPhotoView(){
        let selectedPhotoViewController = SelectedPhotoViewController(model: model)
        
        navigationController?.pushViewController(selectedPhotoViewController, animated: true)
            
    }
}


#Preview{
    ViewController()
}

