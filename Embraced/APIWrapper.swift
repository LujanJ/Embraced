//
//  APIWrapper.swift
//  Embraced
//
//  Created by Domonique Dixon on 11/13/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import Foundation
import Stormpath


public class APIWrapper {
    class func post(id: String, test: String, data: Any) {
        var notesEndpoint = NSURL()
        
        if id == "" && test == "" {
            notesEndpoint = NSURL(string: Stormpath.sharedSession.configuration.APIURL.absoluteString + "/participant")!
        } else if id != "" && test == "" {
            notesEndpoint = NSURL(string: Stormpath.sharedSession.configuration.APIURL.absoluteString + "/participant/" + id)!
        } else if id != "" && test != "" {
            notesEndpoint = NSURL(string: Stormpath.sharedSession.configuration.APIURL.absoluteString + "/participant/" + id + "/" + test)!
        }
        
        let request = NSMutableURLRequest(url: notesEndpoint as URL)
        
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: data, options: [])
        request.setValue("application/json" , forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest)
        
        task.resume()
    }
}
