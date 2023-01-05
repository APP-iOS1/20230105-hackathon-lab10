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
    
    func retrievePhotos(_ record: Record){
        self.images = []
        let db = Firestore.firestore()
        db.collection("Records").getDocuments { snapshot, error in
            if error == nil && snapshot != nil {
                var paths = [String]()
                for doc in snapshot!.documents {
                    paths.append(doc["photos"] as! String)
                }
                for path in paths {
                    if path == record.photoID {
                        let storageRef = Storage.storage().reference()
                        let fileRef = storageRef.child("images/\(path).jpg")
                        fileRef.getData(maxSize: 5*1024*1024) { data, error in
                            if error == nil && data != nil {
                                if let image = UIImage(data: data!) {
                                    DispatchQueue.main.async{
                                        self.images.append(image)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
