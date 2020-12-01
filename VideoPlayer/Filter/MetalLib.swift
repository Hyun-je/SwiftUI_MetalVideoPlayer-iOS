//
//  MetalLib.swift
//  VideoPlayer
//
//  Created by JaehyeonPark on 2020/11/28.
//

import Foundation



class MetalLib {
    
    private static var url = Bundle.main.url(forResource: "default", withExtension: "metallib")!
    
    static var data = try! Data(contentsOf: url)
    
}
