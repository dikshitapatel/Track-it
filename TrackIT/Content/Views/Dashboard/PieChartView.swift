import SwiftUI

public struct PieChartView: View {
    var data: [(value: Double, color: Color)]
    var style: ChartStyles
    var formSize: CGSize
    var dropShadow: Bool
    
    init(data: [(value: Double, color: Color)], style: ChartStyles = Styles.pieChartStyleOne, form: CGSize? = ChartForm.medium, dropShadow: Bool? = true) {
        self.data = data
        self.style = style
        self.formSize = form ?? ChartForm.medium
        self.dropShadow = dropShadow ?? true
    }
    
    public var body: some View {
        PieChartData(data: data, backgroundColor: style.backgroundColor, accentColor: style.accentColor)
            .foregroundColor(style.accentColor)
            .padding(12)
            .offset(y: -10)
            .frame(width: formSize.width, height: formSize.height)
    }
}

struct Styles {
    static let pieChartStyleOne = ChartStyles(
        backgroundColor: Color.white,
        accentColor: Color(hexString: "#F4732C"),
        secondGradientColor: Color(hexString: "#E42331"),
        textColor: Color.black,
        legendTextColor: Color.gray,
        dropShadowColor: Color.gray)
}

