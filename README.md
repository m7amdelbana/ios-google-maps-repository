# ios-google-maps-repository
GoogleMapsRepository: Handle finding the distance and time between source and destination points

    /// Get distance between source and destination from Google Maps API
    ///
    /// - Parameters:
    ///   - source: The start CLLocationCoordinate2D
    ///   - destination: The end CLLocationCoordinate2D
    ///   - completion: GMRResult<String, String>
    ///
    
    static func getDistance(from source: CLLocationCoordinate2D,
                            to destination: CLLocationCoordinate2D,
                            _ completion: @escaping (GMRResult<String, String>) -> ())


    /// Get time between source and destination from Google Maps API
    ///
    /// - Parameters:
    ///   - source: The start CLLocationCoordinate2D
    ///   - destination: The end CLLocationCoordinate2D
    ///   - completion: GMRResult<String, String>
    ///
    
    static func getTime(from source: CLLocationCoordinate2D,
                        to destination: CLLocationCoordinate2D,
                        _ completion: @escaping (GMRResult<String, String>) -> ())
