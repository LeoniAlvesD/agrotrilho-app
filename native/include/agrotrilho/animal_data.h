#ifndef AGROTRILHO_ANIMAL_DATA_H
#define AGROTRILHO_ANIMAL_DATA_H

#include <string>
#include <cstdint>

namespace agrotrilho {

struct AnimalData {
    uint32_t id;
    std::string name;
    int age;
    double weight;
    std::string breed;
};

}  // namespace agrotrilho

#endif  // AGROTRILHO_ANIMAL_DATA_H
