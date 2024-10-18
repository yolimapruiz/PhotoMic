//
//  PhotoEditorModel.swift
//  PhotoMic
//
//  Created by Yolima Pereira Ruiz on 18/10/24.
//

import UIKit

class PhotoEditorModel {
    var originalImage: UIImage?
    var editedImage: UIImage?
    
    init(image: UIImage?) {
        self.originalImage = image
        self.editedImage = image
    }
}
