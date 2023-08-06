//
//  Assertions.swift
//  ComboPetProject
//
//  Created by Andrew K on 8/6/23.
//

import Foundation

func assertMainThread() {
    assert(Thread.isMainThread == true, "main thread check")
}

func assertBgThread() {
    assert(Thread.isMainThread != true, "bg thread check")
}
