class FeedbackResponse {
  int? id;
  String status;
  String phoneNumber;
  DateTime createdTime;
  DateTime? solvedTime;
  String email;
  String problemText;
  int type;
  String? ticketSolver;

  FeedbackResponse({
    this.id,
    required this.status,
    required this.phoneNumber,
    required this.createdTime,
    this.solvedTime,
    required this.email,
    required this.problemText,
    required this.type,
    this.ticketSolver,
  });

  factory FeedbackResponse.fromJson(Map<String, dynamic> json) {
    return FeedbackResponse(
      id: json['id'],
      status: json['status'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      createdTime: DateTime.parse(json['created_time']),
      solvedTime: json['solved_time'] != null ? DateTime.parse(json['solved_time']) : null,
      email: json['email'] ?? '',
      problemText: json['problem_text'] ?? '',
      type: json['type'] ?? 0,
      ticketSolver: json['ticket_solver'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['phone_number'] = this.phoneNumber;
    data['created_time'] = this.createdTime.toIso8601String();
    data['solved_time'] = this.solvedTime?.toIso8601String();
    data['email'] = this.email;
    data['problem_text'] = this.problemText;
    data['type'] = this.type;
    data['ticket_solver'] = this.ticketSolver;
    return data;
  }
}

