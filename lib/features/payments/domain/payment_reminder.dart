class PaymentReminder {
  const PaymentReminder({
    required this.id,
    required this.businessId,
    required this.customerName,
    required this.amountDue,
    required this.dueDate,
    required this.channel,
    required this.locale,
    required this.status,
  });

  final String id;
  final String businessId;
  final String customerName;
  final double amountDue;
  final DateTime dueDate;
  final ReminderChannel channel;
  final String locale;
  final ReminderStatus status;
}

enum ReminderChannel { whatsapp, sms, email }

enum ReminderStatus { scheduled, sent, failed, paid }
