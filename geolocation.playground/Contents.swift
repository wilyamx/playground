import Foundation

let store = ClinicLocationTrackerStore()
Task {
    await store.newClinicsToTrack(clinics: clinics2)
    try await store.getGeocodeLocations()
    await store.logsForTrackData()
    await store.calculateRanges(riderCoordinate: riderLocation)
    await store.logsForTrackData()
}
