//
//  deleteImageFromFirebase.swift
//  Sales
//
//  Created by José Ruiz on 20/6/24.
//

import FirebaseStorage

func deleteImageFromFirebase(for path: String, completion: @escaping () -> Void) {
    let reference = Storage.storage().reference(withPath: path)
    reference.delete { error in
        if let error = error {
            print("Error deleting image: \(error.localizedDescription)")
        }
        completion()
    }
}
