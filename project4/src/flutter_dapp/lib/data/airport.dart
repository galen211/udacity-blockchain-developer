class Airport {
  String airportIata;
  String airportName;

  Airport([this.airportIata, this.airportName]);

  String get airportDescription => '$airportIata - $airportName';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Airport &&
        o.airportIata == airportIata &&
        o.airportName == airportName;
  }

  @override
  int get hashCode => airportIata.hashCode ^ airportName.hashCode;
}
