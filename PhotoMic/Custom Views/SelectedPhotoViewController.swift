//
//  SelectedPhotoViewController.swift
//  PhotoMic
//
//  Created by Yolima Pereira Ruiz on 16/10/24.
//

import UIKit


class SelectedPhotoViewController: UIViewController {
    private let model: PhotoEditorModel
    private let imageView = UIImageView()
    private let editButton = UIButton(type: .system)
    private let trashButton = UIButton(type: .system)
    private var isExpanded = false
    private var isEditingPhoto = false
    
    private var expandedConstraints: [NSLayoutConstraint] = []
    private var normalConstraints: [NSLayoutConstraint] = []
    
    init(model: PhotoEditorModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required  init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationItem.hidesBackButton = true
        setupImageView()
        setupEditButton()
        updateImageView()
        setupTrashButton()
    }
    
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        view.addSubview(imageView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleImageSize))
        imageView.addGestureRecognizer(tapGesture)
        
        // Normal (initial) constraints
        normalConstraints = [
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 400),
            imageView.heightAnchor.constraint(equalToConstant: 400)
        ]
        
        // Expanded constraints
        expandedConstraints = [
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ]
        
        NSLayoutConstraint.activate(normalConstraints)
    }
    
    private func setupEditButton() {
        editButton.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        editButton.tintColor = .systemBlue
        editButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        editButton.layer.cornerRadius = 25
        editButton.addTarget(self, action: #selector(editPhoto), for: .touchUpInside)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(editButton)
        
        NSLayoutConstraint.activate([
            editButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editButton.widthAnchor.constraint(equalToConstant: 50),
            editButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupTrashButton() {
        trashButton.setImage(UIImage(systemName: "trash"), for: .normal)
        trashButton.tintColor = .systemBlue
        trashButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        trashButton.layer.cornerRadius = 25
        trashButton.addTarget(self, action: #selector(deletePhoto), for: .touchUpInside)
        trashButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trashButton)
        
        NSLayoutConstraint.activate([
            trashButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            trashButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            trashButton.widthAnchor.constraint(equalToConstant: 50),
            trashButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func updateImageView(){
        print("DEBUG: se actualizo la imagen")
        imageView.image = model.editedImage
    }
   
    // MARK: - Actions

    
 @objc private func toggleImageSize() {
        isExpanded.toggle()
    
        // Deactivate current constraints and activate the other set
        if isExpanded {
            NSLayoutConstraint.deactivate(normalConstraints)
            NSLayoutConstraint.activate(expandedConstraints)
        } else {
            NSLayoutConstraint.deactivate(expandedConstraints)
            NSLayoutConstraint.activate(normalConstraints)
        }
    
        // Animate the change
        UIView.animate(withDuration: 0.3) {

            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func editPhoto() {
        
        print("edit button pressed")
        // Push PhotoEditorViewController here
        let photoEditorVC = PhotoEditorViewController(model: model) // Create a new PhotoEditorViewController
        photoEditorVC.delegate = self
      
        navigationController?.pushViewController(photoEditorVC, animated: true)
    }
    
    @objc private func deletePhoto() {
        navigationController?.popViewController(animated: true)
    }
    
    
}


extension SelectedPhotoViewController: PhotoEditorDelegate {
    func didCancelEditing() {
        //navigate back without saving changes
        navigationController?.popViewController(animated: true)
        model.editedImage = imageView.image
    }
    
    func didFinishEditing(_ editedImage: UIImage?) {
        //saves changes to the model
        model.editedImage = editedImage
        updateImageView()
    }
}

#Preview {
    SelectedPhotoViewController(model: PhotoEditorModel(image: UIImage(named: "postcomida")))
}
