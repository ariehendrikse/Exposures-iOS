//
//  ModelData.swift
//  Landmarks
//
//  Created by Arie Hendrikse on 21/1/21.
//

import Foundation
import Combine
import MapKit

final class ModelData: ObservableObject {
    @Published var exposures: [KenExposure] = []
    
    // Send HTTP Request

    @Published var clinics: [Clinic] = []
    @Published var locations = [MKPointAnnotation]()
    @Published var lastRefresh: Date?
    var refreshSuccessful: Bool?


    var stateLoadedCount: Int = 0
    var exposuresLoaded: Bool = false
    var clinicsLoaded: Bool = false
    
    func load(refresh: Bool) {
        if !self.exposuresLoaded || refresh {
            loadExposures()
            self.exposuresLoaded = true
        }
        if !self.clinicsLoaded || refresh {
            //loadClinicsVic()
            self.clinicsLoaded = true
        }
    }

    func loadExposures() {
        self.stateLoadedCount = 0
        self.refreshSuccessful = nil
        loadVICExposures()
        loadNSWExposures()
        loadWAExposures()
        loadQLDExposures()
    }
    
    func checkCount() {
        self.stateLoadedCount += 1
        if self.stateLoadedCount == 4 {
            self.refreshSuccessful = true
        }
    }
    func loadWAExposures() {
        print("LOADING KENS EXPOSURES")
        let url = URL(string: "https://covid19nearme.com.au/data/locations.WA.latest.json?source=henluva")!

            
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            print("Mimetype: " + (response?.mimeType)!)
            // Check if Error took place
            if let error = error {
                print("Error took place \(error.localizedDescription)")
                return
            }
            // Read HTTP Response Status code
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    self.refreshSuccessful = false
                }

                return
            }
            guard let mime = response?.mimeType, mime == "application/json" || mime == "application/octet-stream" else {
                print("Wrong MIME type!")
                
                DispatchQueue.main.async {
                    self.refreshSuccessful = false
                }
                return
            }
            
            // Convert HTTP Response Data to a simple String
            do {
                let decoder = JSONDecoder()
                //var dataString = String(data: data!, encoding: .utf8)
                let kenResponse = try decoder.decode(KenLocation.self, from: data!)
                DispatchQueue.main.async {
                    self.exposures.removeAll { (exp0) -> Bool in
                        exp0.locationState == "WA"
                    }
                    self.exposures.append(contentsOf: kenResponse.locations)
                    self.checkCount()
                }
            } catch {
                print("Couldn't get url:\n\(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.refreshSuccessful = false
                }
                return
            }
        }
        )
        task.resume()
    }
    func loadQLDExposures() {
        print("LOADING KENS EXPOSURES")
        let url = URL(string: "https://covid19nearme.com.au/data/locations.QLD.latest.json?source=henluva")!

        let session = URLSession.shared
            
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            
            print("Mimetype: " + (response?.mimeType)!)
            // Check if Error took place
            if let error = error {
                print("Error took place \(error.localizedDescription)")
                return
            }
            // Read HTTP Response Status code
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    self.refreshSuccessful = false
                }

                return
            }
            guard let mime = response?.mimeType, mime == "application/json" || mime == "application/octet-stream" else {
                print("Wrong MIME type!")
                DispatchQueue.main.async {
                    self.refreshSuccessful = false
                }

                return
            }
            
            // Convert HTTP Response Data to a simple String
            do {
                let decoder = JSONDecoder()
                //var dataString = String(data: data!, encoding: .utf8)
                let kenResponse = try decoder.decode(KenLocation.self, from: data!)
                DispatchQueue.main.async {
                    self.exposures.removeAll { (exp0) -> Bool in
                        exp0.locationState == "QLD"
                    }
                    self.exposures.append(contentsOf: kenResponse.locations)
                    self.checkCount()
                }
                
            } catch {
                DispatchQueue.main.async {
                    self.refreshSuccessful = false
                }

                print("Couldn't get url:\n\(error.localizedDescription)")
                return
            }
        }
        )
        task.resume()
    }
    func loadNSWExposures() {
        print("LOADING KENS EXPOSURES")
        let url = URL(string: "https://covid19nearme.com.au/data/locations.NSW.latest.json?source=henluva")!

        let session = URLSession.shared
            
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            
            print("Mimetype: " + (response?.mimeType)!)
            // Check if Error took place
            if let error = error {
                print("Error took place \(error.localizedDescription)")
                return
            }
            // Read HTTP Response Status code
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return
            }
            guard let mime = response?.mimeType, mime == "application/json" || mime == "application/octet-stream" else {
                print("Wrong MIME type!")
                return
            }
            
            // Convert HTTP Response Data to a simple String
            do {
                let decoder = JSONDecoder()
                //var dataString = String(data: data!, encoding: .utf8)
                let kenResponse = try decoder.decode(KenLocation.self, from: data!)
                DispatchQueue.main.async {
                    self.exposures.removeAll { (exp0) -> Bool in
                        exp0.locationState == "NSW"
                    }
                    self.exposures.append(contentsOf: kenResponse.locations)
                    self.checkCount()
                }
                
            } catch {
                print("ERROR:\n\(error)")
                print("Couldn't get url:\n\(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.refreshSuccessful = false
                }
                return
            }
        }
        )
        task.resume()
    }
    func loadVICExposures() {
        print("LOADING KENS EXPOSURES")
        let url = URL(string: "https://covid19nearme.com.au/data/locations.VIC.latest.json?source=henluva")!

        let session = URLSession.shared
            
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            
            print("Mimetype: " + (response?.mimeType)!)
            // Check if Error took place
            if let error = error {
                print("Error took place \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.refreshSuccessful = false
                }
                return
            }
            // Read HTTP Response Status code
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    self.refreshSuccessful = false
                }
                return
            }
            guard let mime = response?.mimeType, mime == "application/json" || mime == "application/octet-stream" else {
                print("Wrong MIME type!")
                DispatchQueue.main.async {
                    self.refreshSuccessful = false
                }
                return
            }
            
            // Convert HTTP Response Data to a simple String
            do {
                let decoder = JSONDecoder()
                //var dataString = String(data: data!, encoding: .utf8)
                let kenResponse = try decoder.decode(KenLocation.self, from: data!)
                DispatchQueue.main.async {
                    self.exposures.removeAll { (exp0) -> Bool in
                        exp0.locationState == "VIC"
                    }
                    self.exposures.append(contentsOf: kenResponse.locations)
                    self.checkCount()
                }
                
            } catch {
                print("Couldn't get url:\n\(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.refreshSuccessful = false
                }
                return
            }
        }
        )
        task.resume()
    }
    func loadClinicsVic() {
        let url = URL(string: "https://www.ariehendrikse.com/covid/clinics/all?source=henluva")!

        let session = URLSession.shared
            
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error.localizedDescription)")
                return
            }
            // Read HTTP Response Status code
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return
            }
            guard let mime = response?.mimeType, mime == "application/json" || mime == "application/octet-stream" else {
                print("Wrong MIME type!")
                return
            }
            
            // Convert HTTP Response Data to a simple String
            do {
                let decoder = JSONDecoder()
                self.clinics = try decoder.decode([Clinic].self, from: data!)
                self.clinicsLoaded = true

            } catch {
                print("Couldn't ger url:\n\(error)")
            }
        }
        )
        task.resume()
    }
    func loadExposuresVic() {
        let url = URL(string: "https://www.ariehendrikse.com/covid/exposures/nsw?source=henluva")!

        let session = URLSession.shared
            
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                DispatchQueue.main.async {
                    self.refreshSuccessful = false
                }
                return
            }
            // Read HTTP Response Status code
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    self.refreshSuccessful = false
                }
                return
            }
            guard let mime = response?.mimeType, mime == "application/json" || mime == "application/octet-stream" else {
                print("Wrong MIME type!")
                return
            }
            
            // Convert HTTP Response Data to a simple String
            do {
                let decoder = JSONDecoder()
                self.exposures = try decoder.decode([KenExposure].self, from: data!)
                self.exposuresLoaded = true

            } catch {
                print("Couldn't ger url:\n\(error)")
                DispatchQueue.main.async {
                    self.refreshSuccessful = false
                }
                return
            }
        }
        )
        task.resume()
    }
    
}
