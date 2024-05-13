import 'package:intl/intl.dart';

class FeedbackResponse {
  int id;
  String status;
  String phoneNumber;
  DateTime? createdTime;
  DateTime? solvedTime;
  String email;
  String problemText;
  int type;
  dynamic? ticketSolver;

  FeedbackResponse({
    required this.id,
    required this.status,
    required this.phoneNumber,
    required this.createdTime,
    required this.solvedTime,
    required this.email,
    required this.problemText,
    required this.type,
    required this.ticketSolver,
  });

  factory FeedbackResponse.fromJson(Map<String, dynamic> json) {
    return FeedbackResponse(
      id: json['id'],
      status: json['status'],
      phoneNumber: json['phone_number'],
      createdTime: json['created_time'] != null ? DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['created_time']) : null,
      solvedTime: json['solved_time'] != null ? DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['solved_time']) : null,
      email: json['email'],
      problemText: json['problem_text'],
      type: json['type'],
      ticketSolver: json['ticket_solver'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'phone_number': phoneNumber,
      'created_time': createdTime?.toIso8601String(),
      'solved_time': solvedTime?.toIso8601String(),
      'email': email,
      'problem_text': problemText,
      'type': type,
      'ticket_solver': ticketSolver,
    };
  }
}
