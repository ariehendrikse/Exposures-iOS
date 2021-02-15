import SwiftUI

struct AlertItem: View {
    var exposure: KenExposure

    var body: some View {
        VStack(alignment: .leading) {
            Text(exposure.locationName)
                .font(.title)
                .lineLimit(3)
                .foregroundColor(.primary)
                .colorInvert()
                .frame(alignment: .leading)
            Text(exposure.locationSuburb)
                .foregroundColor(.primary)
                .colorInvert()
                .font(.subheadline)
                .lineLimit(3)
                .padding(.bottom)
        }
        .frame(width: 300, height: 150)
        .cornerRadius(20)
        .background(Color.primary)
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(exposure.color, lineWidth: 5))

    }
    
    

}

struct CategoryItem_Previews: PreviewProvider {
    static var previews: some View {
        AlertItem(exposure: ModelData().exposures[1])
    }
}
