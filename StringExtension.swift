//
//  StringExtension.swift
//  
//
//  Created by Domonique Dixon on 12/20/16.
//
//

import Foundation

extension String {
    
    func localized(lang:String) -> String {
        
        let path = NSBundle.mainBundle().pathForResource(lang, ofType: "lproj")
        
        let bundle = NSBundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
        
    }
    
}
