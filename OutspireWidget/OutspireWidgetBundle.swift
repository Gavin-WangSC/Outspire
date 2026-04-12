//
//  OutspireWidgetBundle.swift
//  OutspireWidget
//
//  Created by Alan Ye on 4/12/26.
//

import WidgetKit
import SwiftUI

@main
struct OutspireWidgetBundle: WidgetBundle {
    var body: some Widget {
        OutspireWidget()
        OutspireWidgetControl()
        OutspireWidgetLiveActivity()
    }
}
