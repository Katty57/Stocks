//
//  Numeric+Ext.swift
//  Stocks
//
//  Created by  User on 04.06.2022.
//

import Foundation

extension Numeric {
    var formattedWithSeparator: String { Formatter.withSeparator.string(for: self) ?? "" }
}
