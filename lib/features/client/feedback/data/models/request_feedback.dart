class RequestFeedback {
  String status;
  String phoneNumber;
  String email;
  String problemText;
  int type;

  RequestFeedback({
    required this.status,
    required this.phoneNumber,
    required this.email,
    required this.problemText,
    required this.type,
  });

  factory RequestFeedback.fromJson(Map<String, dynamic> json) {
    return RequestFeedback(
      status: json['status'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      problemText: json['problem_text'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'phone_number': phoneNumber,
      'email': email,
      'problem_text': problemText,
      'type': type,
    };
  }
}
