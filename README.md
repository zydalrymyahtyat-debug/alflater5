# 📱 المحاسب الذكي - دليل البناء

## نظرة عامة
تطبيق محاسبي متكامل مبني بـ Flutter مع:
- واجهة عربية أنيقة مع دعم RTL
- قاعدة بيانات SQLite محلية
- رسوم بيانية تفاعلية
- رسوم متحركة سلسة
- تصميم Material 3

## المتطلبات
- Flutter SDK 3.0+
- Android Studio أو VS Code
- Android SDK

## خطوات التشغيل

### 1. تثبيت التبعيات
```bash
cd accounting_app
flutter pub get
```

### 2. تشغيل التطبيق
```bash
flutter run
```

### 3. بناء APK
```bash
# APK عادي
flutter build apk

# APK مقسم (لأحجام أصغر)
flutter build apk --split-per-abi

# App Bundle (للرفع على Google Play)
flutter build appbundle
```

## هيكل المشروع
```
lib/
├── main.dart              # نقطة الدخول
├── models/               # نماذج البيانات
│   ├── customer_model.dart
│   ├── invoice_model.dart
│   └── transaction_model.dart
├── screens/              # الشاشات
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── home_screen.dart
│   ├── invoices_screen.dart
│   ├── customers_screen.dart
│   ├── transactions_screen.dart
│   └── reports_screen.dart
├── database/             # قاعدة البيانات
│   └── database_helper.dart
├── utils/                # الأدوات
│   └── app_colors.dart
└── widgets/              # الويدجت المشتركة
```

## المميزات
✅ شاشة تسجيل دخول أنيقة
✅ لوحة تحكم مع إحصائيات حية
✅ إدارة الفواتير (إضافة/عرض)
✅ إدارة العملاء مع الرصيد
✅ إدارة المعاملات المالية
✅ تقارير مالية مع رسوم بيانية (Pie & Bar)
✅ قاعدة بيانات SQLite محلية
✅ رسوم متحركة سلسة (flutter_animate)
✅ تصميم Material 3
✅ دعم كامل للغة العربية (RTL)

## الألوان المستخدمة
- Primary: #1A5F7A (أزرق محيطي)
- Accent: #E57C23 (برتقالي)
- Success: #22C55E (أخضر)
- Error: #EF4444 (أحمر)

## ملاحظات
- يحتوي التطبيق على بيانات تجريبية مدمجة
- يمكن تخصيص الألوان من ملف `lib/utils/app_colors.dart`
