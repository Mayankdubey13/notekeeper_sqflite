class Notes {
  int? _id;
  String? _title;
  String? _description;
  String? _date;
  int? _priority;

  Notes(this._title, this._priority, this._date, [this._description]);

  Notes.withId(this._id, this._title, this._priority, this._date,
      [this._description]);

  int get id {
    return _id!;
  }

  String get title => _title!;

  String get description => _description ?? " ";

  String get date => _date!;

  int get priority => _priority!;

  set title(String newTitle) {
    if (newTitle.length <= 256) {
      _title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 256) {
      // _description = newDescription;
    }
    _description = newDescription;
  }

  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      _priority = newPriority;
    }
  }

  set date(String newDate) {
    _date = newDate;
  }

  // Convert the note object into map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["title"] = _title;
    map["discription"] = _description;
    map["priority"] = _priority;
    map["date"] = _date;
    return map;
  }
  //Extract a note object  from a map object

  Notes.fromMapObject(Map<String, dynamic> map) {
    _id = map["id"];
    _title = map["title"];
    _description = map["discription"];
    _priority = map["priority"];
    _date = map["date"];
  }
}
