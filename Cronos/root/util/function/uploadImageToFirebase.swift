//
//  uploadImageToFirebase.swift
//  Sales
//
//  Created by José Ruiz on 28/7/24.
//

import FirebaseStorage
import Foundation

func uploadImageToFirebase(for path: String, with data: Data, completion: @escaping (ImageInfo) -> Void) {
    let reference = Storage.storage().reference(withPath: path)
    reference.putData(data, metadata: nil) { metadata, error in
        if let error {
            print(error.localizedDescription)
            return
        }
        reference.downloadURL { url, error in
            if let error {
                print(error.localizedDescription)
                return
            }
            guard let downloadURL = url else {
                print("URL is nil")
                return
            }
            let pathInfo = reference.fullPath
            let urlInfo = downloadURL.absoluteString
            let imageInfo = ImageInfo(path: pathInfo, url: urlInfo, belongs: true)
            completion(imageInfo)
        }
    }
}

func uploadImageToFirebaseWithProcessHandler(for path: String, with data: Data, progressHandler: @escaping (Double) -> Void, completion: @escaping (ImageInfo?) -> Void) {
    let reference = Storage.storage().reference(withPath: path)
    let uploadTask = reference.putData(data, metadata: nil)

    // Observe the upload progress
    uploadTask.observe(.progress) { snapshot in
        let percentComplete = Double(snapshot.progress?.completedUnitCount ?? 0) / Double(snapshot.progress?.totalUnitCount ?? 1)
        progressHandler(percentComplete)
    }

    // Observe the upload completion
    uploadTask.observe(.success) { snapshot in
        reference.downloadURL { url, error in
            if let error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            guard let downloadURL = url else {
                print("URL is nil")
                completion(nil)
                return
            }
            let pathInfo = reference.fullPath
            let urlInfo = downloadURL.absoluteString
            let imageInfo = ImageInfo(path: pathInfo, url: urlInfo, belongs: true)
            completion(imageInfo)
        }
    }

    uploadTask.observe(.failure) { snapshot in
        if let error = snapshot.error {
            print(error.localizedDescription)
            completion(nil)
        }
    }
}
