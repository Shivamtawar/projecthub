import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projecthub/constant/app_color.dart';
import 'package:projecthub/constant/app_icons.dart';
import 'package:projecthub/constant/app_padding.dart';
import 'package:projecthub/constant/app_textfield_border.dart';
import 'package:projecthub/widgets/app_primary_button.dart';

class BankAccountPage extends StatefulWidget {
  const BankAccountPage({super.key});

  @override
  State createState() => _BankAccountPageState();
}

class _BankAccountPageState extends State<BankAccountPage> {
  final List<Map<String, String>> _bankAccounts = [
    {
      "accountHolderName": "John Doe",
      "accountNumber": "1234567890",
      "ifscCode": "HDFC0001234",
      "bankName": "HDFC Bank",
      "balance": "₹2,426.12",
      "isPrimary": "false",
    },
    {
      "accountHolderName": "Alice Smith",
      "accountNumber": "9876543210",
      "ifscCode": "SBI0005678",
      "bankName": "State Bank of India",
      "balance": "₹4,123.94",
      "isPrimary": "false",
    },
    {
      "accountHolderName": "Robert Brown",
      "accountNumber": "1122334455",
      "ifscCode": "ICICI0001234",
      "bankName": "ICICI Bank",
      "balance": "₹9,871.05",
      "isPrimary": "true",
    },
  ];

  final List _gradientColors = [
    [const Color(0xFF6D0EB5), const Color(0xFF4059F1)], // Purple
    [const Color(0xFF0072FF), const Color(0xFF00C6FF)], // Blue
    [const Color(0xFFFF4E50), const Color(0xFFF9D423)], // Orange
  ];

  Widget _buildBankAccountCard(Map<String, String> account, int index) {
    final gradient = _gradientColors[index % _gradientColors.length];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                account["bankName"]!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _getInfoSection("Holder", account["accountHolderName"]!),
              _getInfoSection("Account Number",
                  "${account["accountNumber"]!.substring(0, 2)}*****${account["accountNumber"]!.substring(account["accountNumber"]!.length - 4, account["accountNumber"]!.length)}"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Set as primary",
                    style: TextStyle(color: Colors.white),
                  ),
                  Radio(
                    value: account["accountNumber"],
                    groupValue: _getPrimaryAccount(),
                    onChanged: (v) {
                      setState(() {
                        _setPrimaryAccount(v as String);
                      });
                    },
                    activeColor: Colors.white,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _getPrimaryAccount() {
    // Returns the account number of the primary account
    return _bankAccounts.firstWhere(
        (account) => account["isPrimary"] == "true")["accountNumber"];
  }

  _setPrimaryAccount(String accountNumber) {
    // Set the selected account as primary
    for (var account in _bankAccounts) {
      if (account["accountNumber"] == accountNumber) {
        account["isPrimary"] = "true";
      } else {
        account["isPrimary"] = "false";
      }
    }
  }

  _getInfoSection(String key, String value) {
    return Row(
      children: [
        SizedBox(
          width: Get.width * 0.3,
          child: Text(key, style: const TextStyle(color: Colors.white70)),
        ),
        const Text(" :   ", style: TextStyle(color: Colors.white70)),
        Text(value, style: const TextStyle(color: Colors.white70))
      ],
    );
  }

  void _showAddAccountDialog() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 16,
          left: 16,
          right: 16,
        ),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Add New Bank Account",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  labelText: "Account Holder Name",
                  border: AppTextfieldBorder.enabledBorder,
                  focusedBorder: AppTextfieldBorder.focusedBorder,
                  enabledBorder: AppTextfieldBorder.enabledBorder,
                  focusedErrorBorder: AppTextfieldBorder.focusedErrorBorder,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  labelText: "Bank Name",
                  border: AppTextfieldBorder.enabledBorder,
                  focusedBorder: AppTextfieldBorder.focusedBorder,
                  enabledBorder: AppTextfieldBorder.enabledBorder,
                  focusedErrorBorder: AppTextfieldBorder.focusedErrorBorder,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  labelText: "Account Number",
                  border: AppTextfieldBorder.enabledBorder,
                  focusedBorder: AppTextfieldBorder.focusedBorder,
                  enabledBorder: AppTextfieldBorder.enabledBorder,
                  focusedErrorBorder: AppTextfieldBorder.focusedErrorBorder,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  labelText: "IFSC Code",
                  border: AppTextfieldBorder.enabledBorder,
                  focusedBorder: AppTextfieldBorder.focusedBorder,
                  enabledBorder: AppTextfieldBorder.enabledBorder,
                  focusedErrorBorder: AppTextfieldBorder.focusedErrorBorder,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.all(AppPadding.itermInsidePadding),
                child: AppPrimaryElevetedButton(
                  title: "Submit",
                  onPressed: () {},
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: AppIcon.backIcon),
        title: const Text("Bank Accounts"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _bankAccounts.length,
              itemBuilder: (context, index) {
                return _buildBankAccountCard(_bankAccounts[index], index);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: _showAddAccountDialog,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "Add New Bank Account",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                backgroundColor: AppColor.iconPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
