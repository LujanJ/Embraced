//
//  ClockDrawingModel.swift
//  Embraced
//
//  Created by Domonique Dixon on 8/3/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import Foundation

class ClockDrawingModel: TestModelProtocol {
<<<<<<< HEAD
=======
    
>>>>>>> master
    static let shared = ClockDrawingModel()
    
    var file: String?
    var time: Int?
    
    private init() {}
    
<<<<<<< HEAD
    func getModel() -> [String: Any] {
=======
    func getModel() -> [String : Any] {
>>>>>>> master
        var rv = [String: Any]()
        
        rv["CLOCK_file"] = file
        rv["CLOCK_time"] = time

        return rv
    }
    
    func reset() {
        file = ""
        time = 0
    }
}
