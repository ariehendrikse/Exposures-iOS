//
//  Home.swift
//  CovidNearMe
//
//  Created by Arie Hendrikse on 14/3/21.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var modelData: ModelData
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var locationViewModel = LocationViewModel()
    @State var locations: [Annotatable] = []
    @FetchRequest(entity: Location.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Location.dateStart, ascending: false)]) var savedLocations: FetchedResults<Location>
    
    @State var  showMonitorLocs = false
    @State var  showTestLocs = false
    @State var  showIsolateLocs = false
    
    func monitorExposureUnion() -> [KenExposure] {
        modelData.exposures.filter { (kenExp0) -> Bool in
            savedLocations.contains(where: { (loc0) -> Bool in
                let mon0 = MonitorLocation(fromStorage: loc0)
                return kenExp0.sameLocation(as: mon0) &&
                kenExp0.exposures.contains { (alert0) -> Bool in
                    alert0.overlaps(with: mon0)
                }
            })
        }
    }
    var body: some View {
        NavigationView() {
            List() {
                let x = monitorExposureUnion()
                
                
                CardView(alignment: .center , color:  modelData.refreshSuccessful == nil  ? Color.purple : x.count == 0 ? Color.green : Color.purple) {
                    HStack() {
                        if modelData.refreshSuccessful == nil {Spacer()}

                        VStack(alignment: modelData.refreshSuccessful == nil ? .center : .leading) {
                            Text("Alerts in Monitor Zones")
                                .font(.title)

                            if modelData.refreshSuccessful == nil  {
                                LoadingDots(color: Color.white)
                            }
                            else if x.count > 0 {

                                HStack() {


                                    let monitorLocs = x.filter { (exp0) -> Bool in
                                        exp0.color == Color.blue
                                    }
                                    let testLocs = x.filter { (exp0) -> Bool in
                                        exp0.color == Color.yellow
                                    }
                                    let isolateLocs = x.filter { (exp0) -> Bool in
                                        exp0.color == Color.red
                                    }
                                    let otherLocs = x.filter { (exp0) -> Bool in
                                        exp0.color == Color.yellow &&
                                        exp0.color == Color.red &&
                                        exp0.color == Color.blue
                                    }
                                    VStack(spacing: 10) {
                                        CardView(alignment: .leading, color: Color.red) {
                                            HStack() {
                                                VStack(alignment: .leading){
                                                    Text("Get tested and isolate for 14 days.")
                                                        .font(.title2)
                                                        .lineLimit(3)
                                                }
                                                Spacer()
                                                VStack() {
                                                    AlertNumberCircle(number: isolateLocs.count, color: .black)
                                                    Text("New").foregroundColor(.orange).font(.caption)
                                                }
                                            }
                                        }
                                        CardView(alignment: .leading, color: Color.yellow) {
                                            VStack() {
                                                HStack() {
                                                    VStack(alignment: .leading){
                                                        Text("Get tested and isolate until negative.")
                                                            .font(.title2)
                                                            .lineLimit(3)
                                                    }
                                                    Spacer()
                                                    VStack() {
                                                        AlertNumberCircle(number: testLocs.count, color: .black)
                                                        Text("New").foregroundColor(.orange).font(.caption)
                                                    }
                                                }
                                                if showTestLocs {
                                                        ForEach(testLocs) { x in
                                                            Text(x.locationName)
                                                        }
                                                }
                                            }
                                        
                                        }.onTapGesture {
                                            showTestLocs.toggle()
                                        }
                                        CardView(alignment: .leading, color: Color.blue) {
                                            VStack() {
                                                HStack() {
                                                    VStack(alignment: .leading){
                                                        Text("Test and isolate if symptons occur.")
                                                            .font(.title2)
                                                            .lineLimit(5)
                                                    }
                                                    Spacer()
                                                    
                                                    VStack() {
                                                        AlertNumberCircle(number: monitorLocs.count, color: .black)
                                                        Text("New").foregroundColor(.orange).font(.caption)
                                                    }
                                                }.onTapGesture {
                                                        showMonitorLocs.toggle()
                                                }
                                                if showMonitorLocs {
                                                    AlertRow(items: monitorLocs)                                                }
                                            }
                                        }
                                    
                                    }

                                }
                            }
                            else {
                                Text(modelData.refreshSuccessful != nil ? "No new alerts." : "")
                            }

                        }
                        Spacer()
                    }
                }.scaleEffect()
                
                CardView(alignment: .leading, color: .gray) {
                    let sorted = modelData.exposures.sorted(by: { (exp0, exp1) -> Bool in
                        KenExposure.closestToUser(between: exp0, and: exp1, from: locationViewModel.getCoordinate())
                        })
                    let x = sorted.filter({ (exp0) -> Bool in
                        return exp0.exposures.filter { (alert0) -> Bool in
                            let d = DateFormatter()
                            let upperBound = String.Index(encodedOffset: 19)
                            let s = alert0.createdAt.substring(to: upperBound)
                            d.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                            let created = d.date(from: s) ?? Date()
                            return created > Date().addingTimeInterval(-86400)
                        }.count>0
                    })
                    let x1 = sorted.filter({ (exp0) -> Bool in
                        return exp0.exposures.filter { (alert0) -> Bool in
                            let d = DateFormatter()
                            let upperBound = String.Index(encodedOffset: 19)
                            let s = alert0.createdAt.substring(to: upperBound)
                            d.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                            let created = d.date(from: s) ?? Date()
                            return created > Date().addingTimeInterval(-604800)
                        }.count>0
                    })
                    VStack(alignment:.leading) {
                        Text("New")
                            .font(.title)
                        
                        HStack() {
                            Text("Last 24 hours")
                            Spacer()
                            AlertNumberCircle(number: x.count, color: .black)
                        }
                        if x.count > 0 {
                            AlertRow(items: x)

                        }
                        HStack() {
                            Text("Last 7 days")
                            Spacer()
                            AlertNumberCircle(number: x1.count, color: .black)
                        }
                        if x1.count > 0 {
                            AlertRow(items: x1)
                        }
                        
                    }


                }
            }
            
            .navigationTitle("Home")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Refresh") {
                        modelData.load(refresh: true)
                    }
                }
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    if let msg = modelData.refreshSuccessful
                    {
                        HStack() {
                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundColor(msg ? .green : .red)
                            Text(msg ? "Loaded" : "Error")
                        }
                    }
                    else {
                        HStack() {
                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundColor(.yellow)
                            Text("Loading")
                        }
                    }
                }

            }

        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
