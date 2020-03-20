//
//  NetService+IPAddress.swift
//  ThermoConfigurator
//
//  Created by Thomas Bonk on 20.03.20.
//  Copyright © 2020 Thomas Bonk. All rights reserved.
//

import Foundation

extension NetService {
    var ipAddress: String? {
        var ipAddress: String? = nil

        if let data = self.addresses?.first {
            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))

            data.withUnsafeBytes { (pointer: UnsafeRawBufferPointer) -> Void in
                let sockaddrPtr = pointer.bindMemory(to: sockaddr.self)
                guard let unsafePtr = sockaddrPtr.baseAddress else { return }
                guard getnameinfo(unsafePtr, socklen_t(data.count), &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 else {
                    return
                }
            }

            ipAddress = String(cString:hostname)
        }

        return ipAddress
    }
}
