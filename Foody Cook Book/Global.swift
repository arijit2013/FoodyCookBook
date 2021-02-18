//
//  Global.swift
//  Parama Fashion
//
//  Created by Arijit Das on 11/02/21.
//

import UIKit
import JTMaterialSpinner

class Global: NSObject {
    private override init() {
        // Customize the line width
        spinnerView.circleLayer.lineWidth = 4.0
        
        // Change the color of the line
        spinnerView.circleLayer.strokeColor = UIColor.darkGray.cgColor
        
        // Change the duration of the animation
        spinnerView.animationDuration = 2.5
    }
    static let sharedInstance = Global()
    public var spinnerView = JTMaterialSpinner()
    public var mealDetailsArr: [[String : Any]] = []
    public var searchDetailsArr: [[String : Any]] = []
    public var storeDetailsArr: [[String : Any]] = []
    
    func startLoading() {
        if (spinnerView.isAnimating) {
            spinnerView.endRefreshing()
        }
        spinnerView.beginRefreshing()
    }
    
    func stopLoading() {
        if (spinnerView.isAnimating) {
            spinnerView.endRefreshing()
        }
    }
}
