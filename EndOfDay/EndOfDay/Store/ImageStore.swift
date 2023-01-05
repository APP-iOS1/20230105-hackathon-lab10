//
//  ImageStore.swift
//  EndOfDay
//
//  Created by 조석진 on 2022/12/14.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore

class ImageStore: ObservableObject{
    
    @Published var images: [UIImage] = []
    
    func uploadPhoto(_ selectedImage: UIImage?) -> String {
        guard selectedImage != nil else{
            return ""
        }
        let storageRef = Storage.storage().reference()
        let imageData = selectedImage!.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else{
            return ""
        }
        let uuid = UUID().uuidString
        let path = "images/\(uuid).jpg"
        let fileRef = storageRef.child(path)
        _ = fileRef.putData(imageData!, metadata: nil)
        
        return uuid
    }
}
