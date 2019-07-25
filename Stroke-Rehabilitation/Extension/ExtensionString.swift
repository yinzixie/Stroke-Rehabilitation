//
//  ExtensionString.swift
//  SimpleJournal
//
//  Created by yinzixie on 28/4/19.
//  Copyright © 2019 UTAS. All rights reserved.
//

import Foundation

extension String {
    
    func containsVersion2(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    
}
