//
//  FilterConstructor.swift
//  VideoPlayer
//
//  Created by JaehyeonPark on 2020/11/28.
//

import CoreImage

class FilterConstructor<T: CIFilter> : CIFilterConstructor {
    
    func filter(withName name: String) -> CIFilter? {
        return T()
    }
}
