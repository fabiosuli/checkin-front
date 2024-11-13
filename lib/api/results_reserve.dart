class ResulstReserv {
  GuestResults? guest;
  ResultsReservation? reservation;
  Payment? payment;
  Vehicle? vehicle;
  Preferences? preferences;

  ResulstReserv(
      {this.guest,
      this.reservation,
      this.payment,
      this.vehicle,
      this.preferences});

  ResulstReserv.fromJson(Map<String, dynamic> json) {
    guest =
        json['guest'] != null ? new GuestResults.fromJson(json['guest']) : null;
    reservation = json['reservation'] != null
        ? new ResultsReservation.fromJson(json['reservation'])
        : null;
    payment =
        json['payment'] != null ? new Payment.fromJson(json['payment']) : null;
    vehicle =
        json['vehicle'] != null ? new Vehicle.fromJson(json['vehicle']) : null;
    preferences = json['preferences'] != null
        ? new Preferences.fromJson(json['preferences'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.guest != null) {
      data['guest'] = this.guest!.toJson();
    }
    if (this.reservation != null) {
      data['reservation'] = this.reservation!.toJson();
    }
    if (this.payment != null) {
      data['payment'] = this.payment!.toJson();
    }
    if (this.vehicle != null) {
      data['vehicle'] = this.vehicle!.toJson();
    }
    if (this.preferences != null) {
      data['preferences'] = this.preferences!.toJson();
    }
    return data;
  }
}

class GuestResults {
  String? firstName;
  String? lastName;
  String? birthDate;
  String? phone;
  String? email;
  Address? address;

  GuestResults(
      {this.firstName,
      this.lastName,
      this.birthDate,
      this.phone,
      this.email,
      this.address});

  GuestResults.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    birthDate = json['birthDate'];
    phone = json['phone'];
    email = json['email'];
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['birthDate'] = this.birthDate;
    data['phone'] = this.phone;
    data['email'] = this.email;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    return data;
  }
}

class Address {
  String? street;
  int? number;
  String? city;
  String? state;
  String? postalCode;
  String? country;

  Address(
      {this.street,
      this.number,
      this.city,
      this.state,
      this.postalCode,
      this.country});

  Address.fromJson(Map<String, dynamic> json) {
    street = json['street'];
    number = json['number'];
    city = json['city'];
    state = json['state'];
    postalCode = json['postalCode'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['street'] = this.street;
    data['number'] = this.number;
    data['city'] = this.city;
    data['state'] = this.state;
    data['postalCode'] = this.postalCode;
    data['country'] = this.country;
    return data;
  }
}

class ResultsReservation {
  String? reservationNumber;
  String? checkInDate;
  String? checkOutDate;
  String? roomNumber;
  String? roomType;
  int? totalAmount;
  String? currency;
  String? status;

  ResultsReservation(
      {this.reservationNumber,
      this.checkInDate,
      this.checkOutDate,
      this.roomNumber,
      this.roomType,
      this.totalAmount,
      this.currency,
      this.status});

  ResultsReservation.fromJson(Map<String, dynamic> json) {
    reservationNumber = json['reservationNumber'];
    checkInDate = json['checkInDate'];
    checkOutDate = json['checkOutDate'];
    roomNumber = json['roomNumber'];
    roomType = json['roomType'];
    totalAmount = json['totalAmount'];
    currency = json['currency'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reservationNumber'] = this.reservationNumber;
    data['checkInDate'] = this.checkInDate;
    data['checkOutDate'] = this.checkOutDate;
    data['roomNumber'] = this.roomNumber;
    data['roomType'] = this.roomType;
    data['totalAmount'] = this.totalAmount;
    data['currency'] = this.currency;
    data['status'] = this.status;
    return data;
  }
}

class Payment {
  String? paymentMethod;
  String? cardLastFourDigits;
  String? transactionId;
  String? paymentDate;
  int? amountPaid;
  String? currency;

  Payment(
      {this.paymentMethod,
      this.cardLastFourDigits,
      this.transactionId,
      this.paymentDate,
      this.amountPaid,
      this.currency});

  Payment.fromJson(Map<String, dynamic> json) {
    paymentMethod = json['paymentMethod'];
    cardLastFourDigits = json['cardLastFourDigits'];
    transactionId = json['transactionId'];
    paymentDate = json['paymentDate'];
    amountPaid = json['amountPaid'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paymentMethod'] = this.paymentMethod;
    data['cardLastFourDigits'] = this.cardLastFourDigits;
    data['transactionId'] = this.transactionId;
    data['paymentDate'] = this.paymentDate;
    data['amountPaid'] = this.amountPaid;
    data['currency'] = this.currency;
    return data;
  }
}

class Vehicle {
  String? licensePlate;
  String? model;
  int? year;
  String? color;

  Vehicle({this.licensePlate, this.model, this.year, this.color});

  Vehicle.fromJson(Map<String, dynamic> json) {
    licensePlate = json['licensePlate'];
    model = json['model'];
    year = json['year'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['licensePlate'] = this.licensePlate;
    data['model'] = this.model;
    data['year'] = this.year;
    data['color'] = this.color;
    return data;
  }
}

class Preferences {
  String? bedType;
  String? smokingPreference;
  List<String>? additionalRequests;

  Preferences({this.bedType, this.smokingPreference, this.additionalRequests});

  Preferences.fromJson(Map<String, dynamic> json) {
    bedType = json['bedType'];
    smokingPreference = json['smokingPreference'];
    additionalRequests = json['additionalRequests'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bedType'] = this.bedType;
    data['smokingPreference'] = this.smokingPreference;
    data['additionalRequests'] = this.additionalRequests;
    return data;
  }
}
