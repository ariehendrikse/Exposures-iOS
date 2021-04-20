//
//  AlertsHome.swift
//  CovidNearMe
//
//  Created by Arie Hendrikse on 21/1/21.
//

import SwiftUI
import MapKit

struct AlertsHome: View {
    @State private var showingAlert = false
    @State var stateName: String = "VIC"
    var components = DateComponents()

    @State var dateFrom: Date = Date(timeIntervalSince1970: Date().addingTimeInterval(-1209600).timeIntervalSince1970 - Date().addingTimeInterval(-1209600).timeIntervalSince1970.truncatingRemainder(dividingBy: 86400))
    
    @State var dateTo: Date = Date()

    @EnvironmentObject var modelData: ModelData
    @ObservedObject var locationViewModel = LocationViewModel()
    @State var locations: [Annotatable] = []
    @State var groupedLocations: [Dictionary<String, [KenExposure]>.Keys.Element] = []
    
    @State var isActive: Bool = false
    @State var selectedAnnotation: KenExposure?
    @State var didChange: Bool = false

    
    var governmentWebsites = [
        "VIC": "https://www.dhhs.vic.gov.au/case-locations-and-outbreaks-covid-19",
        "NSW": "https://www.health.nsw.gov.au/Infectious/covid-19/Pages/case-locations-and-alerts.aspx",
        "WA":"https://www.healthywa.wa.gov.au/Articles/A_E/Coronavirus/Locations-visited-by-confirmed-cases",
        "SA":"https://www.sahealth.sa.gov.au/wps/wcm/connect/public+content/sa+health+internet/conditions/infectious+diseases/covid-19/testing+and+tracing/contact+tracing",
        "QLD": "https://www.qld.gov.au/health/conditions/health-alerts/coronavirus-covid-19/current-status/contact-tracing"
    ]
    
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
    @State var route: MKPolyline?

    
    func pickedLocations(at locs: [KenExposure]) -> [KenExposure] {
        return locs.sorted(by: { (exp0, exp1) -> Bool in
            KenExposure.closestToUser(between: exp0, and: exp1, from: locationViewModel.getCoordinate())
            })
            .filter({ (exp0) -> Bool in
                let d = DateFormatter()
                d.dateFormat = "yyyy-MM-dd"
                print("c")
                let correctState: Bool = exp0.locationState == stateName
                let correctDate: Bool = exp0.exposures.contains { (alert) -> Bool in
                    return dateTo >= alert.date &&  alert.date >= dateFrom
                }
                return (
                    correctState &&
                    correctDate
                )
            })
    }

    func setLocations() {
        locations = pickedLocations(at: modelData.exposures)
        didChange = true
        
        

    }


    var body: some View {
        NavigationView {
            List {
                AusStatePicker(selection: $stateName)
                    .onChange(of: stateName) { (exp0) in
                        setLocations()
                    }
                HStack(){
                    Text("From")
                    DatePicker("View exposures after", selection: $dateFrom,displayedComponents: .date)
                        .labelsHidden()
                        .onChange(of: dateFrom) { (date) in
                            setLocations()
                        }
                    Text("to")

                    DatePicker("View exposures before", selection: $dateTo, displayedComponents: .date)
                        .onChange(of: dateTo) { (date) in
                            setLocations()
                        }
                        .labelsHidden()
                }


                

    //                KenExposureMapContainer(locations: $locations, region: $region)
                Group {

                    MapViewFindButton(locations: $locations, region: $region, isActive: $isActive, didChange: $didChange, selectedAnnotation: $selectedAnnotation)
                        .onChange(of: modelData.exposures) { (locations) in
                            setLocations()
                        }
                    NavigationLink(destination: BindedExposureDetail(exposure: $selectedAnnotation), isActive: self.$isActive) {
                        EmptyView().opacity(0)
                    }
                }
                    
                //need to finish view style
                HStack() {
                    Circle()
                        .foregroundColor(Color.white.opacity(0))
                        .overlay( Image(systemName: "exclamationmark.octagon.fill")
                                    .resizable()
                                    .foregroundColor(Color.red)
                                    .scaledToFit()
                        )
                        .frame(width: 30, height: 30)
                        .padding()

                    Link( "The data here is manually collated by volunteers. There may be errors. Always check official sources.", destination: URL(string: governmentWebsites[stateName]!)!)
                        .lineLimit(6)
                        .padding()
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                        .padding()

                                        
                }
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)

                HStack() {

                        Circle()
                            .foregroundColor(Color.white.opacity(0))
                            .overlay( Image(systemName: "globe")
                                        .resizable()
                                        .foregroundColor(Color.blue)
                                        .scaledToFit()
                            )
                            .frame(width: 30, height: 30)
                            .padding()
                    Link( "View government data for " + stateName, destination: URL(string: governmentWebsites[stateName]!)!)
                        .lineLimit(6)

                        .padding()
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                        .padding()
                                        
                }
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)



//                ForEach(groupedLocations, id: \.self) { key in
//                    let items = pickedLocations(at: modelData.alerts[key]!)
//                    if items.count > 0 {
//                        AlertRow(alertName: key, items: items)
//                    }
//                }
            }
            .navigationTitle("Exposures")
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
                            LoadingDots(color: Color.blue)
                        }
                    }
                }

            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            setLocations()
        }
    }
        
}
