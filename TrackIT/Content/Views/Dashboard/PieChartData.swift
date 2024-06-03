//
//  PieChartData.swift
//  TrackIT
//
//  Created by Raj Shah on 5/2/24.
//

import SwiftUI

public struct PieChartData: View {
    var data: [(value: Double, color: Color)]
    var backgroundColor: Color
    var accentColor: Color
    
    var slices: [PieSliceData] {
        var tempSlices: [PieSliceData] = []
        var lastEndDeg: Double = 0
        let totalValue = data.map { $0.value }.reduce(0, +)
        
        for slice in data {
            let normalizedValue = slice.value / totalValue
            let startDeg = lastEndDeg
            let endDeg = lastEndDeg + (normalizedValue * 360)
            lastEndDeg = endDeg
            tempSlices.append(PieSliceData (startDeg: startDeg, endDeg: endDeg, value: slice.value, normalizedValue: normalizedValue, color: slice.color))
        }
        return tempSlices
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(Array(slices.enumerated()), id: \.offset) { index, slice in
                    PieChartCell(rect: geometry.frame(in: .local), startDeg: slice.startDeg, endDeg: slice.endDeg, index: index, backgroundColor: backgroundColor, accentColor: slice.color)
                }
            }
        }
    }
}

struct PieChartCell: View {
    @State private var show: Bool = false
    var rect: CGRect
    var startDeg: Double
    var endDeg: Double
    var index: Int
    var backgroundColor: Color
    var accentColor: Color
    
    var radius: CGFloat {
        return min(rect.width, rect.height) / 2
    }
    
    var path: Path {
        var path = Path()
        path.addArc(center: rect.mid, radius: radius, startAngle: Angle(degrees: startDeg), endAngle: Angle(degrees: endDeg), clockwise: false)
        path.addLine(to: rect.mid)
        path.closeSubpath()
        return path
    }
    
    var body: some View {
        path
            .fill()
            .foregroundColor(accentColor)
            .overlay(path.stroke(backgroundColor, lineWidth: 2))
            .scaleEffect(show ? 1 : 0)
            .animation(Animation.spring().delay(Double(index) * 0.04))
            .onAppear() {
                self.show = true
            }
    }
}
