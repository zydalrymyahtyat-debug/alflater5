import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/invoice_model.dart';
import '../models/customer_model.dart';
import '../models/transaction_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('accounting.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE customers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT,
        email TEXT,
        address TEXT,
        balance REAL DEFAULT 0,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE invoices (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customer_id INTEGER,
        customer_name TEXT,
        amount REAL NOT NULL,
        type TEXT NOT NULL,
        description TEXT,
        status TEXT DEFAULT 'pending',
        date TEXT NOT NULL,
        FOREIGN KEY (customer_id) REFERENCES customers (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        type TEXT NOT NULL,
        category TEXT,
        date TEXT NOT NULL,
        description TEXT
      )
    ''');

    // Insert sample data
    await _insertSampleData(db);
  }

  Future _insertSampleData(Database db) async {
    await db.insert('customers', {
      'name': 'أحمد محمد',
      'phone': '0501234567',
      'email': 'ahmed@example.com',
      'address': 'الرياض',
      'balance': 5000,
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('customers', {
      'name': 'خالد العلي',
      'phone': '0559876543',
      'email': 'khaled@example.com',
      'address': 'جدة',
      'balance': 3200,
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('customers', {
      'name': 'سعد عبدالله',
      'phone': '0561112233',
      'email': 'saad@example.com',
      'address': 'الدمام',
      'balance': -1200,
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert('invoices', {
      'customer_id': 1,
      'customer_name': 'أحمد محمد',
      'amount': 2500,
      'type': 'income',
      'description': 'فاتورة خدمات شهر يناير',
      'status': 'paid',
      'date': DateTime.now().toIso8601String(),
    });

    await db.insert('invoices', {
      'customer_id': 2,
      'customer_name': 'خالد العلي',
      'amount': 1800,
      'type': 'income',
      'description': 'فاتورة مشروع تصميم',
      'status': 'pending',
      'date': DateTime.now().toIso8601String(),
    });

    await db.insert('transactions', {
      'title': 'إيجار المكتب',
      'amount': 3000,
      'type': 'expense',
      'category': 'إيجار',
      'date': DateTime.now().toIso8601String(),
      'description': 'إيجار شهري',
    });

    await db.insert('transactions', {
      'title': 'مبيعات المنتجات',
      'amount': 8500,
      'type': 'income',
      'category': 'مبيعات',
      'date': DateTime.now().toIso8601String(),
      'description': 'مبيعات اليوم',
    });
  }

  // Customers
  Future<List<CustomerModel>> getCustomers() async {
    final db = await database;
    final maps = await db.query('customers', orderBy: 'id DESC');
    return maps.map((e) => CustomerModel.fromMap(e)).toList();
  }

  Future<int> insertCustomer(CustomerModel customer) async {
    final db = await database;
    return await db.insert('customers', customer.toMap());
  }

  Future<int> updateCustomer(CustomerModel customer) async {
    final db = await database;
    return await db.update(
      'customers',
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  Future<int> deleteCustomer(int id) async {
    final db = await database;
    return await db.delete('customers', where: 'id = ?', whereArgs: [id]);
  }

  // Invoices
  Future<List<InvoiceModel>> getInvoices() async {
    final db = await database;
    final maps = await db.query('invoices', orderBy: 'id DESC');
    return maps.map((e) => InvoiceModel.fromMap(e)).toList();
  }

  Future<int> insertInvoice(InvoiceModel invoice) async {
    final db = await database;
    return await db.insert('invoices', invoice.toMap());
  }

  Future<int> updateInvoice(InvoiceModel invoice) async {
    final db = await database;
    return await db.update(
      'invoices',
      invoice.toMap(),
      where: 'id = ?',
      whereArgs: [invoice.id],
    );
  }

  Future<int> deleteInvoice(int id) async {
    final db = await database;
    return await db.delete('invoices', where: 'id = ?', whereArgs: [id]);
  }

  // Transactions
  Future<List<TransactionModel>> getTransactions() async {
    final db = await database;
    final maps = await db.query('transactions', orderBy: 'id DESC');
    return maps.map((e) => TransactionModel.fromMap(e)).toList();
  }

  Future<int> insertTransaction(TransactionModel transaction) async {
    final db = await database;
    return await db.insert('transactions', transaction.toMap());
  }

  Future<int> deleteTransaction(int id) async {
    final db = await database;
    return await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  // Statistics
  Future<Map<String, dynamic>> getStatistics() async {
    final db = await database;

    final incomeResult = await db.rawQuery(
      "SELECT COALESCE(SUM(amount), 0) as total FROM transactions WHERE type = 'income'",
    );
    final expenseResult = await db.rawQuery(
      "SELECT COALESCE(SUM(amount), 0) as total FROM transactions WHERE type = 'expense'",
    );
    final invoiceResult = await db.rawQuery(
      "SELECT COUNT(*) as count FROM invoices",
    );
    final customerResult = await db.rawQuery(
      "SELECT COUNT(*) as count FROM customers",
    );

    return {
      'totalIncome': (incomeResult.first['total'] as num?)?.toDouble() ?? 0.0,
      'totalExpense': (expenseResult.first['total'] as num?)?.toDouble() ?? 0.0,
      'invoiceCount': (invoiceResult.first['count'] as num?)?.toInt() ?? 0,
      'customerCount': (customerResult.first['count'] as num?)?.toInt() ?? 0,
    };
  }
}
