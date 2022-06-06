//
//  NSObject+Ext.swift
//  Stocks
//
//  Created by  User on 05.06.2022.
//

import Foundation

extension NSObject {
    static var typeName: String {
        String(describing: self)
    }
}
