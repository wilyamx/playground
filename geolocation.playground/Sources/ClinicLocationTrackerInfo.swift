import Foundation
import MapKit
import CoreLocation
import UIKit

public let clinics = [
    Clinic(id: "00b473bd-da59-4ff1-b77b-cf590835adaf",
           address: "Osmeña Blvd, Cebu City, 6000 Cebu"),
    Clinic(id: "0790a483-fb5b-4678-9125-d0ef7979e3b7",
           address: "7VXR+5RG, Natalio B. Bacalso Ave, Cebu City, 6000 Cebu"),
    Clinic(id: "21e66219-a834-49d3-8cd3-74013b2293fe",
           address: "A1 Ouano Ave, Mandaue City, 6014 Cebu"),
    Clinic(id: "2c4af108-db29-49db-878b-db8f080c2222",
           address: "8WW8+V2P~xxx.~M.~Cuenco~Ave~Cebu City~6000~Cebu"),
    Clinic(id: "2c4af108-db29-49db-878b-db8f080cec2d",
           address: "8WW8+V2P, Gov. M. Cuenco Ave, Cebu City, 6000 Cebu"),
    Clinic(id: "2c4af108-db29-49db-878b-db8f080c1111",
           address: "8WW8+V2P~xxx~Cebu City~6000~Cebu"),
    Clinic(id: "2c595e7e-5d26-4d82-91a6-8f60baa9605e",
           address: "41 F. Ramos St, Cebu City, 6000 Cebu")
]

public let clinics2 = [
    Clinic(id: "100",
           address: "Kompleks Hasby, Persiaran Raja~~42001~Kedah~Malaysia"),
    Clinic(id: "101",
           address: "Kompleks Hasby, Persiaran Raja~Muda Musa 42001 Majlis Perbandaran Klang Selangor~00002~Melaka~Malaysia"),
    Clinic(id: "102",
           address: "8th Floor, Wisma Genting, Jalan Sultan Ismail,~~50250~WP Kuala Lumpur~Malaysia"),
    Clinic(id: "103",
           address: "Kompleks Hasby, Persiaran Raja~~42002~Negeri Sembilan~Malaysia"),
    Clinic(id: "104",
           address: "PETALING JAYA~~46990~Selangor~Malaysia"),
    Clinic(id: "105",
           address: "Clover kingdom~Address testing~54634~Kelantan~Malaysia"),
    Clinic(id: "106",
           address: "Kompleks Hasby, Persiaran Raja~~00010~Kelantan~Malaysia"),
    Clinic(id: "107",
           address: "Clover kingdom~Address testing~76754~Kedah~Malaysia"),
    Clinic(id: "108",
           address: "Magnolia~Address testing~51341~Johor~Malaysia"),
    Clinic(id: "109",
           address: "7 Jalan SL 1/4, Bandar Sungai Long,~~43000~WP Kuala Lumpur~Malaysia")
]

public let addresses = [
    "Kompleks Hasby, Persiaran Raja~~42001~Kedah~Malaysia",
    "Kompleks Hasby, Persiaran Raja~Muda Musa 42001 Majlis Perbandaran Klang Selangor~00002~Melaka~Malaysia",
    "8th Floor, Wisma Genting, Jalan Sultan Ismail,~~50250~WP Kuala Lumpur~Malaysia",
    "Kompleks Hasby, Persiaran Raja~~42002~Negeri Sembilan~Malaysia",
    "PETALING JAYA~~46990~Selangor~Malaysia",
    "Clover kingdom~Address testing~54634~Kelantan~Malaysia",
    "Kompleks Hasby, Persiaran Raja~~00010~Kelantan~Malaysia",
    "Clover kingdom~Address testing~76754~Kedah~Malaysia",
    "Magnolia~Address testing~51341~Johor~Malaysia",
    "7 Jalan SL 1/4, Bandar Sungai Long,~~43000~WP Kuala Lumpur~Malaysia"
]

public let riderLocation = CLLocationCoordinate2D(
    latitude: 10.329872605690607,
    longitude: 123.90646536308947
)

public struct Clinic: Codable {
    var id: String
    var address: String
}

public struct ClinicLocationTrackerInfo: Codable, Identifiable {
    public var id = UUID()
    //
    let clinicID: String
    let address: String
    //
    var rangeInKm: Double = 0
    var longitude: Double = 0
    var latitude: Double = 0
}

public class ClinicLocationTrackerStore {
    
    var locationTrackers: [ClinicLocationTrackerInfo] = []

    public init() {
        
    }
    
    public func newClinicsToTrack(clinics: [Clinic]) async {
        print("**********************")
        for clinic in clinics {
            let address = self.validatedClinicAddress(address: clinic.address)
            let trackerInfo = ClinicLocationTrackerInfo(clinicID: clinic.id,
                                                        address: address)
            locationTrackers.append(trackerInfo)
            print("[CLINIC-TRACK] \(trackerInfo.clinicID)")
        }
    }
    
    public func getGeocodeLocations() async throws {
        print("**********************")
        let geoCoder = CLGeocoder()
        for index in 0..<locationTrackers.count {
            let clinic = locationTrackers[index]
            
            do {
                if let placemark = try await geoCoder.geocodeAddressString(clinic.address).first,
                   let coordinate = placemark.location?.coordinate {
                    
                    locationTrackers[index].longitude = coordinate.longitude
                    locationTrackers[index].latitude = coordinate.latitude
                    
                    print("[Geocoder] Map location for clinic: \(clinic.clinicID), long: \(coordinate.longitude), lat: \(coordinate.latitude)")
                    
                }
                else {
                    print("[Geocoder] INVALID geocode! for clinic: \(clinic.clinicID), Address: \(clinic.address)")
                }
            }
            catch(let error) {
                print("[Geocoder] Invalid geocode! for clinic: \(clinic.clinicID), Address: \(clinic.address)")
            }
        }
    }
    
    public func calculateRanges(riderCoordinate: CLLocationCoordinate2D) async {
        print("**********************")
        for index in 0..<locationTrackers.count {
            let clinic = locationTrackers[index]
            
            if clinic.longitude > 0 && clinic.latitude > 0 {
                let clinicLocation = CLLocation(
                    latitude: clinic.latitude,
                    longitude: clinic.longitude
                )
                let riderLocation = CLLocation(
                    latitude: riderCoordinate.latitude,
                    longitude: riderCoordinate.longitude
                )
                
                let distanceInMeters = clinicLocation.distance(from: riderLocation)
                let distanceInKilometers = Double(distanceInMeters / 1000.0)
                
                locationTrackers[index].rangeInKm = distanceInKilometers.rounded(toPlaces: 2)
                
                print("[Distance] Address: \(clinic.clinicID), Range: \(distanceInKilometers)!")
            }
        }
    }
    
    public func logsForTrackData() async {
        print("**********************")
        for clinic in self.locationTrackers {
            if clinic.longitude > 0 && clinic.latitude > 0 {
                print("[Details] ClinicID: \(clinic.clinicID), Long: \(clinic.longitude), Lat: \(clinic.latitude), Range(KM): \(clinic.rangeInKm)")
            }
        }
    }
    
    public func validatedClinicAddress(address: String, ignore: Bool = false) -> String {
        if ignore {
            return address
        }
        
        let delimeter = "~"
        let validDelimeter = address.replacingOccurrences(
            of: "\(delimeter)\(delimeter)",
            with: delimeter
        )
        let addresses = validDelimeter.components(separatedBy: delimeter)
        
        let addresses2 = addresses.map({ $0.trimmingCharacters(in: .whitespaces) })
        let addresses3 = addresses2.map({ $0.trimmingCharacters(in: .punctuationCharacters) })
        
        let formattedAddress = addresses3.joined(separator: ", ")
        
        // We get the first element address
        if let newAddress = addresses3.first {
            return newAddress
        }
        return address
    }
}
