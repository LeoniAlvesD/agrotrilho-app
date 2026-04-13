#ifndef AGROTRILHO_GPS_UTILS_H
#define AGROTRILHO_GPS_UTILS_H

#include <cmath>

namespace agrotrilho {

struct GpsCoordinate {
    double latitude;
    double longitude;
};

/// Calculate distance in meters between two GPS coordinates using the
/// Haversine formula.
double haversine_distance(const GpsCoordinate& a, const GpsCoordinate& b);

/// Check whether a coordinate falls inside a circular geofence.
bool is_within_geofence(const GpsCoordinate& point,
                        const GpsCoordinate& center,
                        double radius_meters);

}  // namespace agrotrilho

#endif  // AGROTRILHO_GPS_UTILS_H
