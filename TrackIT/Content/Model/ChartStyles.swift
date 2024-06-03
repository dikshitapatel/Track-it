//
//  ChartStyles.swift
//  TrackIT
//
//  Created by Raj Shah on 5/2/24.
//

import SwiftUI
class ChartStyles {
    var backgroundColor: Color
    var accentColor: Color
    var secondGradientColor: Color
    var textColor: Color
    var legendTextColor: Color
    var dropShadowColor: Color
    
    init(backgroundColor: Color, accentColor: Color, secondGradientColor: Color, textColor: Color, legendTextColor: Color, dropShadowColor: Color){
        self.backgroundColor = backgroundColor
        self.accentColor = accentColor
        self.secondGradientColor = secondGradientColor
        self.textColor = textColor
        self.legendTextColor = legendTextColor
        self.dropShadowColor = dropShadowColor
    }
}


