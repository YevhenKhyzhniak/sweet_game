//
//  LogicAdjust.swift
//
//
//  Created by Yevhen Khyzhniak on 30.10.2023.
//

import Foundation

class LogicAdjust {
    
    static private (set) var trackerToken: String?    // The token of the tracker to which the device is currently attributed.
    static private (set) var trackerName: String?    // The name of the tracker to which the device is currently attributed.
    static private (set) var network: String?    // The name of the network to which the device is currently attributed.
    static private (set) var campaign: String?    // The name of the campaign to which the device is currently attributed.
    static private (set) var adgroup: String?    // The name of the adgroup to which the device is currently attributed.
    static private (set) var creative: String?    // The name of the creative to which the device is currently attributed.
    static private (set) var clickLabel: String?    // The click label that the install is tagged with.
    static private (set) var adid: String?    // The unique Adjust ID assigned to the device.
    static private (set) var costType: String?    // The campaign pricing model (e.g. cpi).
    static private (set) var costAmount: Int?   // The cost of the install.
    static private (set) var costCurrency: String?    // The code of the currency associated with the cost. This should be a three character string that follows the ISO 4217 standard
    static private (set) var adgroups: String?
    
    static func receive(_ raw: [String: Any]) {
        
    }
    
}
