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
    var alerts: [String: [KenExposure]] {
            Dictionary(
                grouping: exposures,
                by: { $0.worstExposure.alertDescription }
        )
    }
    func loadExposures() {
        let url = URL(string: "https://covid19nearme.com.au/data/locations.VIC.latest.json")!

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
                self.exposures = kenResponse.locations
            } catch {
                fatalError("Couldn't get url:\n\(error.localizedDescription)")
            }
        }
        )
        task.resume()
    }
    func loadClinicsVic() {
        let url = URL(string: "https://www.ariehendrikse.com/covid/clinics/all")!

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
                fatalError("Couldn't ger url:\n\(error)")
            }
        }
        )
        task.resume()
    }
    func loadExposuresVic() {
        let url = URL(string: "https://www.ariehendrikse.com/covid/exposures/nsw")!

        let session = URLSession.shared
            
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
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
                self.exposures = try decoder.decode([KenExposure].self, from: data!)
                self.exposuresLoaded = true

            } catch {
                fatalError("Couldn't ger url:\n\(error)")
            }
        }
        )
        task.resume()
    }
}
