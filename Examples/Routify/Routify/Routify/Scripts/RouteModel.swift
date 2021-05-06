//
//  routeModel.swift
//  Routify
//
//  Created by iosdev on 3.5.2021.
//

import Foundation
import SwiftUI
import Firebase

struct Route {
    let uploader: String?
    let title: String?
    let description: String?
    let distance: Int?
    let coordinates: [GeoPoint]?
}
