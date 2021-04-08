// 
//  ActivityViewController.swift
//
//  Created by Den Jo on 2021/04/08.
//  Copyright © nilotic. All rights reserved.
//
import UIKit
import SwiftUI

struct ActivityViewController: UIViewControllerRepresentable {

    // MARK: - Value
    // MARK: Public
    let activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {
        
    }
}
