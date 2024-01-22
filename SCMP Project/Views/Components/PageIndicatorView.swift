//
//  PageIndicatorView.swift
//  SCMP Project
//
//  Created by Anson Wong on 22/1/2024.
//

import Foundation
import UIKit

class PageIndicatorCell: UICollectionViewCell {
    private let dotView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(dotView)
        
        NSLayoutConstraint.activate([
            dotView.centerXAnchor.constraint(equalTo: centerXAnchor),
            dotView.centerYAnchor.constraint(equalTo: centerYAnchor),
            dotView.widthAnchor.constraint(equalToConstant: 10),
            dotView.heightAnchor.constraint(equalToConstant: 10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func highlight() {
        dotView.backgroundColor = UIColor.blue
    }
    
    func unhighlight() {
        dotView.backgroundColor = UIColor.lightGray
    }
}
