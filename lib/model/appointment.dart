class Appointment{
  int _id;
  int _userId;
  int _roomId;
  String _room_number;
  String _fullname;
  String _phone_number;
  String _note;
  String _checkin_time;
  String _checkout_time;
  double _total_price;
  String _createdAt;
  int _status;

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  Appointment(
      this._id,
      this._userId,
      this._roomId,
      this._room_number,
      this._fullname,
      this._phone_number,
      this._note,
      this._checkin_time,
      this._checkout_time,
      this._createdAt,
      this._total_price,
      this._status);

  static Appointment empty() {
    return Appointment(0, 0, 0, "", "", "", "", "", "", "", 0, 0);
  }

  Map<String, dynamic> toJson() => {
    'id': _id,
    'userId': _userId,
    'roomId': _roomId,
    'roomNumber': _room_number,
    'fullname': _fullname,
    "phoneNumber": _phone_number,
    'note': _note,
    'checkinTime': _checkin_time,
    "checkoutTime": _checkout_time,
    'createdAt': _createdAt,
    'totalPrice': _total_price,
    'status': _status
  };

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      json['id'] ?? 0,
      json['userId'] ?? 0,
      json['roomId'] ?? 0,
      json['roomNumber'] ?? "",
      json['fullname'] ?? "",
      json['phoneNumber'] ?? "",
      json['note'] ?? "",
      json['checkinTime'] ?? "",
      json['checkoutTime'] ?? "",
      json['createdAt'] ?? "",
      json['totalPrice'] ?? 0,
      json['status'] ?? 0,
    );
  }

  int get userId => _userId;

  int get status => _status;

  set status(int value) {
    _status = value;
  }

  String get createdAt => _createdAt;

  set createdAt(String value) {
    _createdAt = value;
  }

  double get total_price => _total_price;

  set total_price(double value) {
    _total_price = value;
  }

  String get checkout_time => _checkout_time;

  set checkout_time(String value) {
    _checkout_time = value;
  }

  String get checkin_time => _checkin_time;

  set checkin_time(String value) {
    _checkin_time = value;
  }

  String get note => _note;

  set note(String value) {
    _note = value;
  }

  String get phone_number => _phone_number;

  set phone_number(String value) {
    _phone_number = value;
  }

  String get fullname => _fullname;

  set fullname(String value) {
    _fullname = value;
  }

  String get room_number => _room_number;

  set room_number(String value) {
    _room_number = value;
  }

  int get roomId => _roomId;

  set roomId(int value) {
    _roomId = value;
  }

  set userId(int value) {
    _userId = value;
  }

  @override
  String toString() {
    return 'appointment{_id: $_id, _userId: $_userId, _roomId: $_roomId, _room_number: $_room_number, _fullname: $_fullname, _phone_number: $_phone_number, _note: $_note, _checkin_time: $_checkin_time, _checkout_time: $_checkout_time, _total_price: $_total_price, _createdAt: $_createdAt, _status: $_status}';
  }
}