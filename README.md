# PortugalTrains

Portugal Trains is a Swift wrapper for the Infraestruturas de Portugal (IP) API.

*Note*: The IP API is not documented, and it's access can be removed at any point, or some sort of auth might be added in the future.

# Overview
This library was made to be used in the iOS App [redE](https://apps.apple.com/us/app/rede-comboios-de-portugal/id1447635458), and deployed in version 2022.1. 

The IP API allows to search for train stations time tables, and specific trains time tables. The IP website also allows a user to see the train station details, but that functionality doesn't have an open API, which must be accessed through [other means](https://dados.gov.pt/en/datasets/estacoes-e-apeadeiros-dos-caminhos-de-ferro-portugueses/).

The API allows the search for all the train stations in Portugal, but it provides only the Name and Node ID. This Node ID can then be used to return the time tables for each train station.

# Installation

### Swift Package Manager
PortugalTrains is available through [Swift Package Manager](https://github.com/apple/swift-package-manager). 
To install it, simply add the dependency to your Package.Swift file:

```Swift
...
dependencies: [
    .package(url: "https://github.com/joaoc-pires/PortugalTrains.git", from: "1.0.0"),
],
targets: [
    .target( name: "YourTarget", dependencies: ["PortugalTrains"]),
]
...
```

# How to use

### Searching for a train station by name

```Swift
import PortugalTrains

let searchService = StationService()
searchService.search(for: query) { result in
    switch result {
        case .failure(let error): print(error.localizedDescription)
        case .success(let reply): print(reply.response)
    }
}
```

The method ```search(for query:)``` is available using a closure and an asynchronous call. The closure returns an object of type ```Result<StationQueryReply, NetworkError>)``` while the asynchronous call can throw and returns only a ```StationQueryReply``` object.

The object ```StationQueryReply``` only has a property, a list of ```Node``` which contains the node ID, and the station name.

*Note*: The ```Node``` object also contains a distance property which as far as I can tell, always returns 0. For consistency, the property is also available in the ```Node``` object.

### Getting the Time Table for a given station

```Swift
import PortugalTrains

let searchService = StationService()
searchService.getTimeTable(forStationId: id) { result in
    switch result {
        case .failure(let error): print(error.localizedDescription)
        case .success(let reply): print(reply.response)
    }
}
```
The method ```getTimeTable(forStationId stationId:, startTime:, endTime:)``` is only available using a closure. The closure returns an object of type ```Result<StationReply, NetworkError>)```. You can omit the start and end time, which will return the time table from now until the end of the day.

The object ```StationReply``` only has a property, a list of ```TimeTable```. This list should at max be 2 elements long - one for arrivals and another for departures.

### TimeTable Object

This object has the following properties:
+ nodeId: The ID of the train station;
+ stationName: The name of the train station;
+ tableType: indicates if the it's for arrivals or departures;
+ elements: a list of ```TimeTableElement```;

### TimeTableElement Object

This object has the following properties:
+ hasPassed: Boolean indicating if the train has passed the station;
+ time: The time which is expected the train to arrive/leave the station;
+ timeToOrder: A value used to order the list;
+ timeToOrder2: A value used to order the listl;
+ destinyStationId: The nodeID of the train's final destination;
+ originStationId: The nodeID of the train's original departure;
+ trainId: The tain ID;
+ trainId2: Another train ID;
+ destinyStationName: The name of the station of the train's final destination;
+ originStationName: The name of the station of the train's orifinal departure;
+ observations: Some info regarding the train;
+ company: The company operating the train;
+ serviceType: The service type of the train;

*Note*: the observations and serviceType properties are strings in Portuguese.

# Planned Development

- [x] Implement getTimeTable asynchronously;
- [ ] Implement TimeTableElement.serviceType as an Enum;
- [ ] Implement TimeTableElement.observations as an Enum;
- [x] Add search by train id;

## License
PortugalTrains is available under the MIT license. See the LICENSE file for more info.

## Author

Joao Pires: joao@zeroloop.org
