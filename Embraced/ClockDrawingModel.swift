//
//  ClockDrawingModel.swift
//  Embraced
//
//  Created by Domonique Dixon on 8/3/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import Foundation

class ClockDrawingModel {
    static let shared = ClockDrawingModel()
    
    var file: String?
    var time: Int?
    
    private init() {}
    
    func printModel() -> [String: Any] {
        var rv = [String: Any]()
        
        rv["CLOCK_file"] = file
        rv["CLOCK_time"] = time

        return rv
    }
}