abstract class Maintainable {
  void performMaintenance();
}

mixin GPSLocatable {
  Future<void> trackLocation(String vehicleId) async {
    print('   [GPS SYSTEM]: Connecting to satellite for $vehicleId...');
    await Future.delayed(Duration(seconds: 2));
    print('   [GPS SYSTEM SUCCESS]: Live location coordinates synced for $vehicleId!');
  }
}

abstract class Vehicle implements Maintainable {
  String vehicleId;
  String routeName;
  int passengerCapacity;
  double baseFare;

  Vehicle({
    required this.vehicleId,
    required this.routeName,
    required this.passengerCapacity,
    required this.baseFare,
  });

  double calculateFare(int distanceInKm);

  Future<String> processTripPaymentAsync(int distanceInKm) async {
    print('   [ASYNC TASK STARTED]: Processing transaction for $vehicleId...');
    
    await Future.delayed(Duration(seconds: 2));
    
    double fare = calculateFare(distanceInKm);
    return 'Transaction Complete! Amount Paid: ₱${fare.toStringAsFixed(2)} for $vehicleId';
  }

  void displayInfo() {
    print('ID: $vehicleId | Route: $routeName | Capacity: $passengerCapacity');
  }
}

class TraditionalJeepney extends Vehicle with GPSLocatable {
  TraditionalJeepney({
    required String vehicleId,
    required String routeName,
    required int passengerCapacity,
  }) : super(
          vehicleId: vehicleId,
          routeName: routeName,
          passengerCapacity: passengerCapacity,
          baseFare: 13.00,
        );

  @override
  double calculateFare(int distanceInKm) {
    if (distanceInKm <= 4) return baseFare;
    return baseFare + ((distanceInKm - 4) * 1.75);
  }

  @override
  void performMaintenance() {
    print('   [MAINTENANCE]: Changing engine oil for Traditional Jeep $vehicleId.');
  }
}

class ModernElectricJeepney extends Vehicle implements Maintainable {
  bool hasAircon;

  ModernElectricJeepney({
    required String vehicleId,
    required String routeName,
    required int passengerCapacity,
    this.hasAircon = true,
  }) : super(
          vehicleId: vehicleId,
          routeName: routeName,
          passengerCapacity: passengerCapacity,
          baseFare: 15.00,
        );

  @override
  double calculateFare(int distanceInKm) {
    double fare = distanceInKm <= 4 ? baseFare : baseFare + ((distanceInKm - 4) * 2.00);
    return hasAircon ? fare + 2.00 : fare;
  }

  @override
  void displayInfo() {
    super.displayInfo();
    print('   Type: Modern E-Jeepney | Airconditioned: $hasAircon');
  }

  @override
  void performMaintenance() {
    print('   [MAINTENANCE]: Battery health check for E-Jeep $vehicleId.');
  }
}

void main() async {
  print('=== NTC ASYNCHRONOUS PUBLIC TRANSIT SYSTEM ===\n');

  TraditionalJeepney traditionalJeep = TraditionalJeepney(
    vehicleId: 'TJ-101',
    routeName: 'Quiapo - Espana',
    passengerCapacity: 18,
  );

  ModernElectricJeepney modernJeep = ModernElectricJeepney(
    vehicleId: 'EJ-202',
    routeName: 'Cubao - Divisoria',
    passengerCapacity: 24,
    hasAircon: true,
  );

  int tripDistance = 8;

  print('--- PROVING NON-BLOCKING ASYNC BEHAVIOR ---');
  print('1. System initialized. Requesting trip payment for TJ-101...');

  String receipt = await traditionalJeep.processTripPaymentAsync(tripDistance);
  
  print('2. [SERVER RESPONSE RECEIVED]: $receipt');
  print('----------------------------------\n');

  print('--- SYNCING FLEET GPS DATA (ASYNC/AWAIT) ---');
  traditionalJeep.displayInfo();
  
  await traditionalJeep.trackLocation(traditionalJeep.vehicleId);

  print('\n--- EXECUTING MAINTENANCE CHECK ---');
  modernJeep.displayInfo();
  modernJeep.performMaintenance();

  print('\n=============================================');
}
