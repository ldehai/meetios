//
//  WordAnnotation.swift
//  MeetSwift
//
//  Created by andy on 9/11/16.
//  Copyright © 2016 AventLabs. All rights reserved.
//

import Foundation
import MapKit
import SwiftyJSON

class WordAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate = CLLocationCoordinate2D()
    var word:Word? = Word()
}
