//
//  ImageStore.swift
//  LootLogger
//
//  Created by Gang Wen on 2021-02-14.
//

import UIKit

class ImageStore {
    
    // MARK: - Internal variables
    let _cache = NSCache<NSString, UIImage>()
    
    // MARK: - Attributes
    func setImage(_ image: UIImage, forKey key: String) {
        self._cache.setObject(image, forKey: key as NSString)
        
        // create full URL for Image
        let url = imageURL(forKey: key)
        
        // Turn image into jpeg data
        if let data = image.jpegData(compressionQuality: 0.5) {
            // write it to full URL
            try? data.write(to: url)
        }
    }
    
    // MARK: -
    func image(forKey key: String) -> UIImage? {
//        return self._cache.object(forKey: key as NSString)
        
        if let existingImage = self._cache.object(forKey: key as NSString) {
            return existingImage
        }
        
        let url = imageURL(forKey: key)
        guard let imageFromDisk = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        
        self._cache.setObject(imageFromDisk, forKey: key as NSString)
        return imageFromDisk
    }
    
    func deleteImage(forKey key: String) {
        self._cache.removeObject(forKey: key as NSString)
        
        let url = imageURL(forKey: key)
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Error removing the image from disk: \(error)")
        }
    }
    
    func imageURL(forKey key: String) -> URL {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        
        return documentDirectory.appendingPathComponent(key)
    }
}
