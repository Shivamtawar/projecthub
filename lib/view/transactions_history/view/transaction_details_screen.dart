// screens/transaction_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/transaction_model.dart';

class TransactionDetailScreen extends StatefulWidget {
  final TransactionModel transaction;

  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  State createState() => _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  @override
  void initState() {
    super.initState();
    // futureTransaction = _paymentService.getTransactionDetails(widget.paymentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Transaction Details'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildStatusCard(widget.transaction),
              const SizedBox(height: 16),
              _buildAmountCard(widget.transaction),
              const SizedBox(height: 16),
              _buildDetailsCard(widget.transaction),
            ],
          ),
        ));
  }

  Widget _buildStatusCard(TransactionModel transaction) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              _getStatusIcon(transaction.status),
              size: 48,
              color: _getStatusColor(transaction.status),
            ),
            const SizedBox(height: 8),
            Text(
              _getStatusText(transaction.status),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _getStatusColor(transaction.status),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Transaction ID: ${transaction.razorpayPaymentId}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              _formatDate(transaction.transactionDate),
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountCard(TransactionModel transaction) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Amount',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Amount:'),
                Text(
                  '₹${(transaction.paymentAmount - transaction.gstAmount! - transaction.platformFee!).toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            if (transaction.gstAmount != null) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('GST:'),
                  Text('₹${transaction.gstAmount!.toStringAsFixed(2)}'),
                ],
              ),
            ],
            if (transaction.platformFee != null) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Platform Fee:'),
                  Text('₹${transaction.platformFee!.toStringAsFixed(2)}'),
                ],
              ),
            ],
            // if (transaction.paymentGatewayFee != null) ...[
            //   const SizedBox(height: 8),
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       const Text('Gateway Fee:'),
            //       Text('₹${transaction.paymentGatewayFee!.toStringAsFixed(2)}'),
            //     ],
            //   ),
            // ],
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '₹${(transaction.paymentAmount).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(TransactionModel transaction) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
                'Payment Method', transaction.paymentMethod ?? 'N/A'),
            _buildDetailRow('Currency', transaction.currency),
            if (transaction.orderId != null)
              _buildDetailRow('Order ID', transaction.orderId.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey[600]),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'failed':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'completed':
        return Icons.check_circle;
      case 'failed':
        return Icons.error;
      case 'pending':
        return Icons.pending;
      default:
        return Icons.payment;
    }
  }

  String _getStatusText(String status) {
    return status[0].toUpperCase() + status.substring(1);
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final transactionDay =
        DateTime(date.toLocal().year, date.toLocal().month, date.toLocal().day);

    final timeFormat = DateFormat('hh:mm a'); // 12-hour format with AM/PM

    if (transactionDay == today) {
      return 'Today, ${timeFormat.format(date)}';
    } else if (transactionDay == today.subtract(const Duration(days: 1))) {
      return 'Yesterday, ${timeFormat.format(date)}';
    } else {
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    }
  }
}
