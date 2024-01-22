//
//  ImageLoader.swift
//  SCMP Project
//
//  Created by Anson Wong on 21/1/2024.
//

import UIKit

struct ImageLoader {
    
    static func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
        task.resume()
        return task
    }
    
}
