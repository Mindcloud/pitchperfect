//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Jeff Boschee on 1/22/16.
//  Copyright © 2016 Mindcloud. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(recorderUrl: NSURL) {
        self.title = recorderUrl.lastPathComponent
        self.filePathUrl = recorderUrl
    }
}