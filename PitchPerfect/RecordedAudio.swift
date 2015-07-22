//
//  RecordedAudio.swift
//  PitchPerfect
//
//  Created by Wouter de Vos on 2015/07/20.
//  Copyright (c) 2015 Wouter. All rights reserved.
//

import Foundation

class RecordedAudio : NSObject {
    var filePathUrl : NSURL!
    var title : String!
    
    init(filePathUrl : NSURL, title : String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}