//
//  StringUtils.swift
//  StringUtils
//
//  Created by MICHAEL ABERNETHY on 6/5/14.
//
//

extension String
{
    
        func contains(find: String) -> Bool{
            return self.rangeOfString(find) != nil
        }
}