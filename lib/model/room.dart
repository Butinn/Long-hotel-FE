class Room {
  int _id;
  String _room_number;
  int _status;
  int _room_type;
  double _price;
  String _note;
  String _feature;
  String _description;


  @override
  String toString() {
    return 'Room{_id: $_id, _room_number: $_room_number, _status: $_status, _room_type: $_room_type, _price: $_price, _note: $_note, _feature: $_feature, _description: $_description}';
  }

  Room(this._id, this._room_number, this._status, this._room_type, this._price,
      this._note, this._feature, this._description);

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  static Room empty() {
    return Room(0,"",0 , 1, 10000,"", "", "");
  }

  Map<String, dynamic> toJson() => {
    'id': _id,
    'roomNumber': _room_number,
    'status': _status,
    'roomType': _room_type,
    'price': _price,
    'note': _note,
    'feature': _feature,
    'description': _description
  };

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
        json['id'] ?? "",
        json['roomNumber'] ?? "",
        json['status'] ?? "",
        json['roomType'] ?? "",
        json['price'] ?? "",
        json['note'] ?? "",
        json['feature'] ?? "",
        json['description'] ?? "");
  }

  String get room_number => _room_number;

  set room_number(String value) {
    _room_number = value;
  }

  int get status => _status;

  set status(int value) {
    _status = value;
  }

  int get room_type => _room_type;

  set room_type(int value) {
    _room_type = value;
  }

  double get price => _price;

  set price(double value) {
    _price = value;
  }

  String get note => _note;

  set note(String value) {
    _note = value;
  }

  String get feature => _feature;

  set feature(String value) {
    _feature = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }
}