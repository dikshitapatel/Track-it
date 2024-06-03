import SwiftUI

struct CategoryImageView: View {
    let category: Category
    
    var body: some View {
        Image(systemName: category.systemNameIcon)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 20, height: 20)
            .padding(20)
            .foregroundColor(category.color)
            .background(category.color.opacity(0.1))
            .cornerRadius(18)
    }
}
