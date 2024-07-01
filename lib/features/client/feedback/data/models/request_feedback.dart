class RequestFeedback {
  String status;
  String phoneNumber;
  String email;
  String problemText;
  String type;

  RequestFeedback({
    required this.status,
    required this.phoneNumber,
    required this.email,
    required this.problemText,
    required this.type,
  });

  factory RequestFeedback.fromJson(Map<String, dynamic> json) {
    return RequestFeedback(
      status: json['status'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      email: json['email'] ?? '',
      problemText: json['problem_text'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['phone_number'] = phoneNumber;
    data['email'] = email;
    data['problem_text'] = problemText;
    data['type'] = type;
    return data;
  }
}
