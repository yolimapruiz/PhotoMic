//
//  PhotoEditorDelegate.swift
//  PhotoMic
//
//  Created by Yolima Pereira Ruiz on 17/10/24.
//

import UIKit

protocol PhotoEditorDelegate: AnyObject {
    func didCancelEditing()
    func didFinishEditing(_ editedImage: UIImage?)
}
