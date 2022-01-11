//
//  LocalStoragePort.swift
//  TestSLG
//
//  Created by Timothée Bilodeau on 06/01/2022.
//

import Foundation

protocol LocalStoragePort {
    func load()
    func save()
}
