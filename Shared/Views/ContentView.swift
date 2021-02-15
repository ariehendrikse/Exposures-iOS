import SwiftUI
import MapKit
import CoreData

struct ContentView: View {
    @EnvironmentObject var modelData: ModelData

    enum Tab {
            case map
            case list
        }
    var body: some View {
        
        TabView {
            ClinicListView()
                .tabItem { Label("Test Sites", systemImage: "map") }
                .tag(Tab.map)
            AlertsHome()
                .environmentObject(modelData)
            .tabItem { Label("Exposure Sites", systemImage: "danger") }
            .tag(Tab.map)

        }


    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
