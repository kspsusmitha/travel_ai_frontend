import 'package:flutter/material.dart';

enum UserType {
  soloTraveler,
  groupTraveler,
  businessTraveler,
  familyTraveler,
}

extension UserTypeExtension on UserType {
  String get displayName {
    switch (this) {
      case UserType.soloTraveler:
        return 'Solo Traveler';
      case UserType.groupTraveler:
        return 'Group Traveler';
      case UserType.businessTraveler:
        return 'Business Traveler';
      case UserType.familyTraveler:
        return 'Family Traveler';
    }
  }

  String get description {
    switch (this) {
      case UserType.soloTraveler:
        return 'Plan your solo adventures';
      case UserType.groupTraveler:
        return 'Collaborate with friends';
      case UserType.businessTraveler:
        return 'Manage business trips';
      case UserType.familyTraveler:
        return 'Plan family vacations';
    }
  }

  IconData get icon {
    switch (this) {
      case UserType.soloTraveler:
        return Icons.person;
      case UserType.groupTraveler:
        return Icons.group;
      case UserType.businessTraveler:
        return Icons.business;
      case UserType.familyTraveler:
        return Icons.family_restroom;
    }
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final UserType userType;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'userType': userType.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      userType: UserType.values.firstWhere(
        (e) => e.name == json['userType'],
        orElse: () => UserType.soloTraveler,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
