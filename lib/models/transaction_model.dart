class TransactionModel {
  final int? id;
  final String title;
  final double amount;
  final String type;
  final String? category;
  final String date;
  final String? description;

  TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.type,
    this.category,
    required this.date,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type,
      'category': category,
      'date': date,
      'description': description,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      title: map['title'] ?? '',
      amount: map['amount']?.toDouble() ?? 0.0,
      type: map['type'] ?? 'expense',
      category: map['category'],
      date: map['date'] ?? '',
      description: map['description'],
    );
  }
}
