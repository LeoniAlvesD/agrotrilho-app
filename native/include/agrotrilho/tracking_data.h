#ifndef AGROTRILHO_TRACKING_DATA_H
#define AGROTRILHO_TRACKING_DATA_H

#include "animal_data.h"
#include "gps_utils.h"
#include <vector>
#include <cstdint>

namespace agrotrilho {

struct TrackingRecord {
    uint32_t animal_id;
    GpsCoordinate position;
    uint64_t timestamp;
};

class TrackingHistory {
public:
    void add_record(const TrackingRecord& record);
    std::vector<TrackingRecord> get_records(uint32_t animal_id) const;
    double total_distance(uint32_t animal_id) const;

private:
    std::vector<TrackingRecord> records_;
};

}  // namespace agrotrilho

#endif  // AGROTRILHO_TRACKING_DATA_H
