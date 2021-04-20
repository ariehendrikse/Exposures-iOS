import SwiftUI
import MapKit
import CoreData

struct ContentView: View {
    @EnvironmentObject var modelData: ModelData
    @Environment(\.managedObjectContext) var managedObjectContext
    enum Tab {
            case map
            case list
            case monitor
            case house
        }
    var body: some View {
        
        
        TabView {
//            ClinicListView()
//                .tabItem { Label("Test Sites", systemImage: "map") }
//                .tag(Tab.map)
            Home()
                .environment(\.managedObjectContext, managedObjectContext)
                .environmentObject(modelData)
                .tabItem { Label("Home", systemImage: "house") }
                .tag(Tab.house)
                .onAppear() {
                    modelData.load(refresh: false)
                }
            AlertsHome()
                .environmentObject(modelData)
                .tabItem { Label("Exposure Sites", systemImage: "exclamationmark.circle") }
                .tag(Tab.map)

            MonitorHome()
                .environment(\.managedObjectContext, managedObjectContext)
                .environmentObject(modelData)
                .tabItem { Label("Monitor", systemImage: "binoculars") }
                .tag(Tab.monitor)
        }
            


    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
