// To parse this JSON data, do
//
//     final flightFile = flightFileFromJson(jsonString);

import 'dart:convert';

class FlightFile {
  FlightFile({
    this.pagination,
    this.data,
  });

  Pagination pagination;
  List<Datum> data;

  factory FlightFile.fromRawJson(String str) =>
      FlightFile.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FlightFile.fromJson(Map<String, dynamic> json) => FlightFile(
        pagination: Pagination.fromJson(json["pagination"]),
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pagination": pagination.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.flightDate,
    this.flightStatus,
    this.departure,
    this.arrival,
    this.airline,
    this.flight,
    this.aircraft,
    this.live,
  });

  DateTime flightDate;
  FlightStatus flightStatus;
  Arrival departure;
  Arrival arrival;
  Airline airline;
  Flight flight;
  dynamic aircraft;
  dynamic live;

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        flightDate: DateTime.parse(json["flight_date"]),
        flightStatus: flightStatusValues.map[json["flight_status"]],
        departure: Arrival.fromJson(json["departure"]),
        arrival: Arrival.fromJson(json["arrival"]),
        airline: Airline.fromJson(json["airline"]),
        flight: Flight.fromJson(json["flight"]),
        aircraft: json["aircraft"],
        live: json["live"],
      );

  Map<String, dynamic> toJson() => {
        "flight_date":
            "${flightDate.year.toString().padLeft(4, '0')}-${flightDate.month.toString().padLeft(2, '0')}-${flightDate.day.toString().padLeft(2, '0')}",
        "flight_status": flightStatusValues.reverse[flightStatus],
        "departure": departure.toJson(),
        "arrival": arrival.toJson(),
        "airline": airline.toJson(),
        "flight": flight.toJson(),
        "aircraft": aircraft,
        "live": live,
      };
}

class Airline {
  Airline({
    this.name,
    this.iata,
    this.icao,
  });

  String name;
  String iata;
  String icao;

  factory Airline.fromRawJson(String str) => Airline.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Airline.fromJson(Map<String, dynamic> json) => Airline(
        name: json["name"],
        iata: json["iata"],
        icao: json["icao"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "iata": iata,
        "icao": icao,
      };
}

class Arrival {
  Arrival({
    this.airport,
    this.timezone,
    this.iata,
    this.icao,
    this.terminal,
    this.gate,
    this.baggage,
    this.delay,
    this.scheduled,
    this.estimated,
    this.actual,
    this.estimatedRunway,
    this.actualRunway,
  });

  String airport;
  String timezone;
  String iata;
  String icao;
  String terminal;
  String gate;
  String baggage;
  int delay;
  DateTime scheduled;
  DateTime estimated;
  DateTime actual;
  DateTime estimatedRunway;
  DateTime actualRunway;

  factory Arrival.fromRawJson(String str) => Arrival.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Arrival.fromJson(Map<String, dynamic> json) => Arrival(
        airport: json["airport"],
        timezone: json["timezone"],
        iata: json["iata"],
        icao: json["icao"],
        terminal: json["terminal"] == null ? null : json["terminal"],
        gate: json["gate"] == null ? null : json["gate"],
        baggage: json["baggage"] == null ? null : json["baggage"],
        delay: json["delay"] == null ? null : json["delay"],
        scheduled: DateTime.parse(json["scheduled"]),
        estimated: DateTime.parse(json["estimated"]),
        actual: json["actual"] == null ? null : DateTime.parse(json["actual"]),
        estimatedRunway: json["estimated_runway"] == null
            ? null
            : DateTime.parse(json["estimated_runway"]),
        actualRunway: json["actual_runway"] == null
            ? null
            : DateTime.parse(json["actual_runway"]),
      );

  Map<String, dynamic> toJson() => {
        "airport": airport,
        "timezone": timezone,
        "iata": iata,
        "icao": icao,
        "terminal": terminal == null ? null : terminal,
        "gate": gate == null ? null : gate,
        "baggage": baggage == null ? null : baggage,
        "delay": delay == null ? null : delay,
        "scheduled": scheduled.toIso8601String(),
        "estimated": estimated.toIso8601String(),
        "actual": actual == null ? null : actual.toIso8601String(),
        "estimated_runway":
            estimatedRunway == null ? null : estimatedRunway.toIso8601String(),
        "actual_runway":
            actualRunway == null ? null : actualRunway.toIso8601String(),
      };
}

class Flight {
  Flight({
    this.number,
    this.iata,
    this.icao,
    this.codeshared,
  });

  String number;
  String iata;
  String icao;
  Codeshared codeshared;

  factory Flight.fromRawJson(String str) => Flight.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Flight.fromJson(Map<String, dynamic> json) => Flight(
        number: json["number"],
        iata: json["iata"],
        icao: json["icao"],
        codeshared: json["codeshared"] == null
            ? null
            : Codeshared.fromJson(json["codeshared"]),
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "iata": iata,
        "icao": icao,
        "codeshared": codeshared == null ? null : codeshared.toJson(),
      };
}

class Codeshared {
  Codeshared({
    this.airlineName,
    this.airlineIata,
    this.airlineIcao,
    this.flightNumber,
    this.flightIata,
    this.flightIcao,
  });

  String airlineName;
  String airlineIata;
  String airlineIcao;
  String flightNumber;
  String flightIata;
  String flightIcao;

  factory Codeshared.fromRawJson(String str) =>
      Codeshared.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Codeshared.fromJson(Map<String, dynamic> json) => Codeshared(
        airlineName: json["airline_name"],
        airlineIata: json["airline_iata"],
        airlineIcao: json["airline_icao"],
        flightNumber: json["flight_number"],
        flightIata: json["flight_iata"],
        flightIcao: json["flight_icao"],
      );

  Map<String, dynamic> toJson() => {
        "airline_name": airlineName,
        "airline_iata": airlineIata,
        "airline_icao": airlineIcao,
        "flight_number": flightNumber,
        "flight_iata": flightIata,
        "flight_icao": flightIcao,
      };
}

enum FlightStatus { LANDED, ACTIVE, SCHEDULED, CANCELLED }

final flightStatusValues = EnumValues({
  "active": FlightStatus.ACTIVE,
  "cancelled": FlightStatus.CANCELLED,
  "landed": FlightStatus.LANDED,
  "scheduled": FlightStatus.SCHEDULED
});

class Pagination {
  Pagination({
    this.limit,
    this.offset,
    this.count,
    this.total,
  });

  int limit;
  int offset;
  int count;
  int total;

  factory Pagination.fromRawJson(String str) =>
      Pagination.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        limit: json["limit"],
        offset: json["offset"],
        count: json["count"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "limit": limit,
        "offset": offset,
        "count": count,
        "total": total,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
