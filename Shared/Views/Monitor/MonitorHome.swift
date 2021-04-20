//
//  MonitorHome.swift
//  CovidNearMe (iOS)
//
//  Created by Arie Hendrikse on 17/2/21.
//

import SwiftUI
import MapKit
import CoreData

struct MonitorHome: View {
    
    @EnvironmentObject var modelData: ModelData
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var locationViewModel = LocationViewModel()
    @State var locations: [Annotatable] = []
    @FetchRequest(entity: Location.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Location.dateStart, ascending: false)]) var savedLocations: FetchedResults<Location>
    
    
    @State var isActive: Bool = false
    @State var selectedAnnotation: KenExposure?
    @State var didChange: Bool = false
    @State var dateFrom: Date = Date(timeIntervalSince1970: 1615852800)
    @State var dateTo: Date = Date()
    
    var df = DateFormatter()
    var tf = DateFormatter()
    
    var previousDate: Date?




    @State var region = MKCoordinateRegion(
        
             center: CLLocationCoordinate2D(
                 latitude: -25.2744,
                 longitude: 133.7751
             ),
             span: MKCoordinateSpan(
                 latitudeDelta: 40,
                 longitudeDelta: 40
             )
         )
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let language = savedLocations[index]
            print("Deleting " + language.title!)
            managedObjectContext.delete(language)
        }
        
        locations = savedLocations.map({ (loc0) -> MonitorLocation in
            MonitorLocation(fromStorage: loc0)
        })
        didChange = true
    }
    var body: some View {
        

        NavigationView() {
            VStack() {
                
            //this is for listing the current monitor places.
            MapViewFindButton(locations: $locations, region: $region, isActive: $isActive, didChange: $didChange, selectedAnnotation: $selectedAnnotation)
                .onAppear {
                    locations = savedLocations
                        .map({ (loc0) -> MonitorLocation in
                        MonitorLocation(fromStorage: loc0)
                        })
                        .filter({ (exp0) -> Bool in
                            let q: MonitorLocation = exp0 as! MonitorLocation
                            let d = DateFormatter()
                            d.dateFormat = "yyyy-MM-dd"
                            print("c")
                            let correctDate: Bool = dateTo >= q.dateFrom! &&  q.dateTo! >= dateFrom
                            return (
                                correctDate
                            )
                        })
                    print(locations.count)
                    didChange = true
                }
            List() {
                ForEach(savedLocations, id: \.self) { loc0 in
                    let i = savedLocations.firstIndex(of: loc0)
                    //let loc0 = savedLocations[i]
                    if loc0.dateStart! < Date(timeIntervalSince1970: 1) {
                        Text("Forever").font(.title).bold().padding(i != 0 ? .top : .trailing)
                    }
                    if i == 0 || df.string(from: loc0.dateStart!) != df.string(from: savedLocations[i!-1].dateStart!) {
                        Text(df.string(from: loc0.dateStart!)).font(.title).bold().padding(i != 0 ? .top : .trailing)
                    }

                    NavigationLink(
                        destination: MonitorDetail(location: loc0),
                        label: {

                            HStack(){
                                Text(String(loc0.title!))
                                    .scaledToFit()
                                Spacer()
                                Text(String(tf.string(from: loc0.dateStart!)))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .scaledToFill()
                            }
                            
                        })
                        .ignoresSafeArea(.all)
                }
                .onDelete(perform: delete)
            }
            .onAppear(perform: {
                df.dateFormat = "dd/MM"
                tf.timeStyle = .short
            })


            .navigationTitle("Monitor")
            .toolbar(content: {
                ToolbarItemGroup(placement: .primaryAction) {
                    HStack {
                        Text("")
                        NavigationLink(destination: AddMonitorLocation(location: region.center, time: Date())
                                        .environment(\.managedObjectContext, managedObjectContext)
                        ) {
                            Image(systemName: "plus")
                                .font(.title)
                        }
                    }
                }
            })
            }

        }
        .navigationViewStyle(StackNavigationViewStyle())

        
        
    }
}
