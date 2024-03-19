// user.dart
class User {
  int id;
  String phoneNumber; // Option 2: Providing a default value
  String username;
  String email;
  String fullName;
  String password;
  String status;
  String role;
  DateTime createdAt;
  DateTime lastUpdatedAt;

  User({
    required this.id,
    this.phoneNumber = '', // Default value provided
    required this.username,
    required this.email,
    required this.fullName,
    required this.password,
    required this.status,
    required this.role,
    required this.createdAt,
    required this.lastUpdatedAt,
  });
}

// vehicle.dart
class Vehicle {
  int id;
  int userId;
  String fleetNumber;
  String numberPlate;
  DateTime createdAt;
  DateTime lastUpdatedAt;

  Vehicle({
    required this.id,
    required this.userId,
    required this.fleetNumber,
    required this.numberPlate,
    required this.createdAt,
    required this.lastUpdatedAt,
  });
}

// transaction.dart
class Transaction {
  int id;
  String originatorConversationId;
  String driverPhone;
  String resultDesc;
  String resultCode;
  String merchantRequestId;
  String checkoutRequestId;
  double amount;
  double balanceBefore;
  double balanceAfter;
  double serviceCharge;
  String mpesaReceiptNumber;
  DateTime transactionDate;
  String clientPhoneNumber;
  String clientName;
  String paymentStatus;
  String fleetNumber;
  String transactionType;
  int walletId;
  DateTime createdAt;
  DateTime updatedAt;

  Transaction({
    required this.id,
    required this.originatorConversationId,
    required this.driverPhone,
    required this.resultDesc,
    required this.resultCode,
    required this.merchantRequestId,
    required this.checkoutRequestId,
    required this.amount,
    required this.balanceBefore,
    required this.balanceAfter,
    required this.serviceCharge,
    required this.mpesaReceiptNumber,
    required this.transactionDate,
    required this.clientPhoneNumber,
    required this.clientName,
    required this.paymentStatus,
    required this.fleetNumber,
    required this.transactionType,
    required this.walletId,
    required this.createdAt,
    required this.updatedAt,
  });
}

// wallet.dart
class Wallet {
  int id;
  double currentBalance;
  DateTime lastUpdatedAt;
  int vehicleId;

  Wallet({
    required this.id,
    required this.currentBalance,
    required this.lastUpdatedAt,
    required this.vehicleId,
  });
}

// fleet_number.dart
class FleetNumber {
  int id;
  String fleetNumber;

  FleetNumber({
    required this.id,
    required this.fleetNumber,
  });
}

// security_pin.dart
class SecurityPin {
  int id;
  String pin;
  int userId;
  int numberOfTrials;
  bool isLocked;
  DateTime lockExpiryDate;

  SecurityPin({
    required this.id,
    required this.pin,
    required this.userId,
    required this.numberOfTrials,
    required this.isLocked,
    required this.lockExpiryDate,
  });
}
