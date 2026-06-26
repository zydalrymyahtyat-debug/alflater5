class InvoiceModel {
  final int? id;
  final int? customerId;
  final String? customerName;
  final double amount;
  final String type;
  final String? description;
  final String status;
  final String date;

  InvoiceModel({
    this.id,
    this.customerId,
    this.customerName,
    required this.amount,
    required this.type,
    this.description,
    this.status = 'pending',
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_id': customerId,
      'customer_name': customerName,
      'amount': amount,
      'type': type,
      'description': description,
      'status': status,
      'date': date,
    };
  }

  factory InvoiceModel.fromMap(Map<String, dynamic> map) {
    return InvoiceModel(
      id: map['id'],
      customerId: map['customer_id'],
      customerName: map['customer_name'],
      amount: map['amount']?.toDouble() ?? 0.0,
      type: map['type'] ?? 'income',
      description: map['description'],
      status: map['status'] ?? 'pending',
      date: map['date'] ?? '',
    );
  }
}
