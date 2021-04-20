import SwiftUI

struct AlertItem: View {
    var exposure: KenExposure
    let d = DateFormatter()

    func dateString() -> String {
        var dates: String = ""
        let d = DateFormatter()
        let d0 = DateFormatter()

        d.dateFormat = "yyyy-MM-dd"
        d0.dateStyle = .short
        var i = 0
        
        exposure.exposures.forEach { (alert0) in
            if let day = d.date(from: alert0.exposureDate!)  {
                dates += d0.string(from: day) + (i == exposure.exposures.count - 1 ?  "." : ", ")
            }
            i+=1
        }

        return dates
    }

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

            HStack(){
                Text(verbatim: "Dates: " + dateString())
                    .foregroundColor(.primary)
                    .colorInvert()
                    .font(.subheadline)
                    .lineLimit(3)
                    .padding(.bottom)
            }
        }
        .frame(width: 200, height: 150)
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
