//
//  AddMonitorLocation.swift
//  CovidNearMe
//
//  Created by Arie Hendrikse on 17/2/21.
//

import SwiftUI
import MapKit
import CoreData

struct AddMonitorLocation: View {
    @State private var selectedMode = "Area"
    @State private var selectedState = "VIC"
    @State private var radius: Double = 1000
    @State var isActive: Bool = false
    @State var selectedAnnotation: KenExposure?
    //@FetchRequest(entity: Location.entity(), sortDescriptors: []) var savedLocations: FetchedResults<Location>

    
    @State var chosenDate: Date = Date()
    @State var chosenLatitude: CLLocationDegrees = 0
    @State var chosenLongitude: CLLocationDegrees = 0
    @State var allDay: Bool = true
    @State var dateFrom: Date = Date()
    @State var dateTo: Date = Date().addingTimeInterval(3600)

    
    @State var didChange: Bool = true
    @State var title: String = "Location"

    @State private var selectedLocation: [Annotatable] = []

    @ObservedObject var locationViewModel = LocationViewModel()
    @EnvironmentObject var modelData: ModelData
    

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

    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode


    var location: CLLocationCoordinate2D
    var time: Date
    let options = ["Location", "Area"]
    let dateOptions = ["Today", "Forever", "Time Range"]
    @State var selectedRange = "All Day"


    let states = ["VIC","NSW","SA","WA","QLD"]

    func saveData() {
        let loc0 = Location(context: managedObjectContext)
        print("Start saving")
        let cal = Calendar(identifier: .gregorian)
        loc0.dateStart =
            selectedRange == "Time Range"  ? dateFrom :
            selectedRange == "Today" ? cal.startOfDay(for: Date()) :
            Date(timeIntervalSince1970: 0)
        loc0.dateEnd = selectedRange == "Time Range"  ? dateTo :
            selectedRange == "Today" ? cal.startOfDay(for: Date().addingTimeInterval(86400)) :
            Date(timeIntervalSince1970: 3234246250)
        if let x = selectedLocation[0] as? MonitorLocation {
            loc0.latitude = x.locationCoordinate.latitude
            loc0.longitude = x.locationCoordinate.longitude

        }
        
        loc0.radius = radius
        loc0.title = title
        do {
            try managedObjectContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            // handle the Core Data error
        }
        
    }
    func lookUpCurrentLocation(at coord0: CLLocationCoordinate2D) {
        // Use the selected location.
        
        let location = CLLocation(latitude: coord0.latitude, longitude: coord0.longitude)
        let geocoder = CLGeocoder()
            
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(location,
                    completionHandler: { (placemarks, error) in
            if error == nil {

                let firstLocation = placemarks?[0]

                if ((firstLocation) != nil) {
                    title = getAddressName(from: firstLocation!)
                }
                
            }
            else {
                print("ERROR")
             // An error occurred during geocoding.
                
            }
        })
    }
    func getAddressName(from place: CLPlacemark) -> String {
        var final: String = ""
        let titles: [String?] = [place.subThoroughfare, place.thoroughfare,  place.subLocality, place.locality, place.administrativeArea]

        titles.forEach { (tit0) in
            if tit0 != nil {
                final += (tit0 == place.thoroughfare) || (final.count == 0) ? "" : ","
                final += final.count > 0 ? " " + tit0! : tit0!
            }
        }
        return final
    }
    
    

    var body: some View {
        Group()
        {
            Form() {
                VStack(alignment: .leading){
                    Text("Monitor Type")
                        .font(.caption)
                        .foregroundColor(.gray)
                    VStack {
                        Picker(selection: $selectedMode, label: Text("Monitor Type")) {
                            ForEach(options, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    if selectedMode == "Area" {
                        Divider()
                            .onAppear() {

                                region.center =
                                    locationViewModel.getCoordinate()
                            }
                        

                        Text("State")
                            .font(.caption)
                            .foregroundColor(.gray)
                        VStack {
                            Picker(selection: $selectedState, label: Text("State")) {
                                ForEach(states, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                    }
     
                }
                if selectedMode == "Location"{
                    Text("Location")
                        .font(.caption)
                        .foregroundColor(.gray)
                    ZStack(){
                        MapViewFindButton(locations: $selectedLocation, region: $region, isActive: $isActive, didChange: $didChange, selectedAnnotation: $selectedAnnotation)
                            .cornerRadius(10)
                            .frame( height: 300)
                            .ignoresSafeArea()
                        Image(systemName: "plus")
                            .foregroundColor(.purple)
                    }

                        
                    HStack() {
                        Spacer()
                        Button(selectedLocation.count == 0 ? "Select Location" : "Change Location")
                        {
                            withAnimation(.easeInOut) {
                                let coord0 = CLLocationCoordinate2D(latitude: region.center.latitude, longitude: region.center.longitude)
                                selectedLocation = [MonitorLocation(locationCoordinate: region.center, radius: radius)]
                                lookUpCurrentLocation(at: coord0)
                                didChange = true
                            }
                        }
                        .accentColor(Color.purple)
                            .frame(alignment: .center)
                            .scaledToFill()
                        Spacer()
                    }
                    if selectedLocation.count > 0 {
                        VStack(alignment: .leading){
                            Text("Radius - " + String(
                                radius >= 1000 ? String(Int(radius/1000)) + "km" : String(radius) + "m"
                            ))
                                .font(.caption)
                                .foregroundColor(.gray)
                            Slider(value: $radius, in: 20...10001, step: radius <= 1001 ? 10 : 1000)
                                .accentColor(.purple)
                                .onChange(of: radius) { (rad0) in
                                    if selectedLocation.count > 0 {
                                        if var sel0 = selectedLocation[0] as? MonitorLocation {
                                            sel0.radius = rad0
                                            selectedLocation = [sel0]
                                            didChange = true
                                        }
                                    }
                                    
                                }
                        }
                        VStack(alignment: .leading){
                            Text("Title")
                                .font(.caption)
                                .foregroundColor(.gray)
                            TextField("Location", text: $title )
                        }
                        VStack(alignment: .leading){
                            Text("Time range")
                                .font(.caption)
                                .foregroundColor(.gray)
                            VStack {
                                Picker(selection: $selectedRange, label: Text("")) {
                                    ForEach(dateOptions, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                        }
                        if selectedRange == "Time Range" {
                                HStack(){
                                    Text("Start: ")
                                    Spacer()
                                    DatePicker("View exposures after", selection: $dateFrom)
                                        .labelsHidden()
                                }
                                HStack(){
                                    Text("End: ")
                                    Spacer()
                                    DatePicker("View exposures before", selection: $dateTo)
                                        .labelsHidden()
                                }
                           

                        }
                        
                    }


                }
   
            }
            .animation(.easeIn)
            

        }.toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveData()
                    }.disabled(selectedLocation.count == 0)
                }
        }
        
        

    }
}
