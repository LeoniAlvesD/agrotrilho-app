#include "agrotrilho/gps_utils.h"

namespace agrotrilho {

static constexpr double kEarthRadiusMeters = 6371000.0;
static constexpr double kPi = M_PI;

static double to_radians(double degrees) {
    return degrees * kPi / 180.0;
}

double haversine_distance(const GpsCoordinate& a, const GpsCoordinate& b) {
    double d_lat = to_radians(b.latitude - a.latitude);
    double d_lon = to_radians(b.longitude - a.longitude);

    double lat1 = to_radians(a.latitude);
    double lat2 = to_radians(b.latitude);

    double h = std::sin(d_lat / 2.0) * std::sin(d_lat / 2.0) +
               std::cos(lat1) * std::cos(lat2) *
               std::sin(d_lon / 2.0) * std::sin(d_lon / 2.0);

    double c = 2.0 * std::atan2(std::sqrt(h), std::sqrt(1.0 - h));
    return kEarthRadiusMeters * c;
}

bool is_within_geofence(const GpsCoordinate& point,
                        const GpsCoordinate& center,
                        double radius_meters) {
    return haversine_distance(point, center) <= radius_meters;
}

}  // namespace agrotrilho
