//
//  Proxy.swift
//  debugdrawer
//
//  Created by Elias Bagley on 11/21/14.
//  Copyright (c) 2014 Rocketmade. All rights reserved.
//

import Foundation

class Proxy {
    // creates a NSURLSessionConfiguration object from a string in the form host:port
    class func createSessionConfiguration(_ hostAndPort: String) -> URLSessionConfiguration {
        let hostAndPortArr = hostAndPort.components(separatedBy: ":")

        if hostAndPortArr.count != 2 {
            return URLSessionConfiguration.default
        }

        let host = hostAndPortArr[0]
        let port = Int(hostAndPortArr[1])

        if port != nil {
            return createSessionConfigurationFromHost(host, port: port!)
        }

        return URLSessionConfiguration.default
    }

    // creates a NSURLSessionConfiguration object from a host and port
    class func createSessionConfigurationFromHost(_ host: String, port: Int) -> URLSessionConfiguration  {
        let dict = [
            kCFNetworkProxiesHTTPEnable as NSString : true,
            kCFStreamPropertyHTTPProxyPort : port,
            kCFStreamPropertyHTTPProxyHost : host as NSString

        ] as [NSString : Any]

        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.connectionProxyDictionary = dict

        return sessionConfiguration
    }
}
