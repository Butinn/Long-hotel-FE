class Schedule {
  int _id;
  int _userId;
  String _fullname;
  String _phoneNumber;
  String _note;
  String _appointmentTime;
  String _createdAt;
  int _timeSlot;
  int _status;

  int get timeSlot => _timeSlot;

  set timeSlot(int value) {
    _timeSlot = value;
  }



  Schedule(this._id, this._fullname, this._userId, this._phoneNumber,
      this._note, this._appointmentTime, this._createdAt,this._timeSlot, this._status);

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  static Schedule empty() {
    return Schedule(0, "", 0, "", "", "", "",0, 0);
  }

  Map<String, dynamic> toJson() => {
        'id': _id,
        'fullname': _fullname,
        'userId': _userId,
        'phoneNumber': _phoneNumber,
        'note': _note,
        'appointmentTime': _appointmentTime,
        'createdAt': _createdAt,
    'timeSlot': _timeSlot,
        'status': _status
      };

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
        json['id'] ?? "",
        json['fullname'] ?? "",
        json['userId'] ?? "",
        json['phoneNumber'] ?? "",
        json['note'] ?? "",
        json['appointmentTime'] ?? "",
        json['createdAt'] ?? "",
        json['timeSlot'] ?? "",
        json['status'] ?? "");
  }

  int get userId => _userId;

  set userId(int value) {
    _userId = value;
  }

  String get fullname => _fullname;

  set fullname(String value) {
    _fullname = value;
  }

  String get phoneNumber => _phoneNumber;

  set phoneNumber(String value) {
    _phoneNumber = value;
  }

  String get note => _note;

  set note(String value) {
    _note = value;
  }

  String get appointmentTime => _appointmentTime;

  set appointmentTime(String value) {
    _appointmentTime = value;
  }

  String get createdAt => _createdAt;

  set createdAt(String value) {
    _createdAt = value;
  }

  int get status => _status;

  set status(int value) {
    _status = value;
  }
}
