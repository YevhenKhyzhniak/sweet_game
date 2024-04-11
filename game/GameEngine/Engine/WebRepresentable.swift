//
//  File.swift
//  Test
//
//  Created by Andrii Pyvovarov on 30.10.2023.
//

import SwiftUI

struct WebRepresentable: UIViewControllerRepresentable {
    
    let request: URLRequest
    var onReceiveURL: (URL) -> Void
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = WebVC()
        controller.request = request
        controller.onReceiveURL = { url in
            self.onReceiveURL(url)
        }
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}