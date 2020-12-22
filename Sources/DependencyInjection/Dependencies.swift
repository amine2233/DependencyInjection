//
//  File.swift
//  
//
//  Created by Amine Bensalah on 22/12/2020.
//

import Foundation

//public class Dependencies<T: DependencyServiceType> {
//    @_functionBuilder struct DependencyBuilder<T: DependencyServiceType> {
//        static func buildBlock(_ dependency: T) -> T { dependency }
//        static func buildBlock(_ dependencies: T...) -> [T] { dependencies }
//    }
//    
//    let core: DependencyCore
//    
//    init(core: DependencyCore) {
//        self.core = core
//    }
//    
//    convenience init(core: DependencyCore, @DependencyBuilder<T> _ dependencies:  () -> [T]) {
//        self.init(core: core)
//        dependencies().forEach { _ = core.register($0.self as! T.Type) }
//    }
//}
