#include "agrotrilho/tracking_data.h"
#include <algorithm>

namespace agrotrilho {

void TrackingHistory::add_record(const TrackingRecord& record) {
    records_.push_back(record);
}

std::vector<TrackingRecord> TrackingHistory::get_records(
    uint32_t animal_id) const {
    std::vector<TrackingRecord> result;
    for (const auto& r : records_) {
        if (r.animal_id == animal_id) {
            result.push_back(r);
        }
    }
    return result;
}

double TrackingHistory::total_distance(uint32_t animal_id) const {
    auto animal_records = get_records(animal_id);
    if (animal_records.size() < 2) {
        return 0.0;
    }

    double total = 0.0;
    for (size_t i = 1; i < animal_records.size(); ++i) {
        total += haversine_distance(animal_records[i - 1].position,
                                    animal_records[i].position);
    }
    return total;
}

}  // namespace agrotrilho
