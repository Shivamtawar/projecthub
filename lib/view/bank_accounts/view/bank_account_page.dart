import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:projecthub/view/bank_accounts/provider/bank_account_provider.dart';
import 'package:projecthub/view/profile/provider/user_provider.dart';
import 'package:projecthub/constant/app_color.dart';
import 'package:projecthub/constant/app_icons.dart';
import 'package:projecthub/constant/app_padding.dart';
import 'package:projecthub/constant/app_text.dart';
import 'package:projecthub/constant/app_textfield_border.dart';
import 'package:projecthub/view/bank_accounts/model/bank_account_model.dart';
import 'package:projecthub/widgets/app_primary_button.dart';
import 'package:provider/provider.dart';

class BankAccountPage extends StatefulWidget {
  const BankAccountPage({super.key});

  @override
  State createState() => _BankAccountPageState();
}

class _BankAccountPageState extends State<BankAccountPage> {
  bool _isError = false;
  String _errorMessage = '';
  bool _isSubmitPressedOnce = false;
  final formkey = GlobalKey<FormState>();
  final TextEditingController accountHolderNameController =
      TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController ifscCodeController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getData();
  }

  final List _gradientColors = [
    [const Color(0xFF6D0EB5), const Color(0xFF4059F1)], // Purple
    [const Color(0xFF0072FF), const Color(0xFF00C6FF)], // Blue
    [const Color(0xFFFF4E50), const Color(0xFFF9D423)], // Orange
    [const Color(0xFF11998E), const Color(0xFF38EF7D)], // Green-Teal
  ];

  getData() async {
    try {
      final provider = Provider.of<BankAccountProvider>(context, listen: false);
      await provider.fetchUserBankAccounts(
          Provider.of<UserInfoProvider>(context, listen: false).user!.userId);
      _isError = false;
      _errorMessage = '';
    } catch (e) {
      log(e.toString());
      setState(() {
        _isError = true;
        _errorMessage = e.toString();
        Get.snackbar("Error occurs", e.toString());
      });
    }
  }

  Widget _buildBankAccountCard(BankAccount bankAccount, int index) {
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
                bankAccount.bankName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _getInfoSection(
                  "Account Holder",
                  (bankAccount.accountHolderName != null)
                      ? bankAccount.accountHolderName!
                      : "Not provided"),
              _getInfoSection("Account Number",
                  "${bankAccount.accountNumber.substring(0, 2)}*****${bankAccount.accountNumber.substring(bankAccount.accountNumber.length - 4, bankAccount.accountNumber.length)}"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Set as primary",
                    style: TextStyle(color: Colors.white),
                  ),
                  Radio(
                    value: bankAccount,
                    groupValue: _getPrimaryAccount(bankAccount),
                    onChanged: (v) {
                      _setPrimaryAccount(bankAccount);
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

  _getPrimaryAccount(BankAccount bankAccount) {
    // Returns the account number of the primary account
    return (bankAccount.isPrimary) ? bankAccount : null;
  }

  _setPrimaryAccount(BankAccount bankAccount) async {
    try {
      final provider = Provider.of<BankAccountProvider>(context, listen: false);
      await provider.setPrimaryBankAccount(
          Provider.of<UserInfoProvider>(context, listen: false).user!.userId,
          bankAccount.accountId);
    } catch (e) {
      Get.snackbar("Not updated", "Failed to set primary account");
    }
  }

  _getInfoSection(String key, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: Get.width * 0.3,
          child: Text(key, style: const TextStyle(color: Colors.white70)),
        ),
        const Text(" :   ", style: TextStyle(color: Colors.white70)),
        SizedBox(
            width: Get.width * 0.4,
            child: Text(value, style: const TextStyle(color: Colors.white70)))
      ],
    );
  }

  showConfirmationDialoge() {
    Get.defaultDialog(
        title: "Confirm details",
        titleStyle: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w500,
          color: AppColor.primaryColor,
        ),
        textConfirm: "Submit",
        onConfirm: () async {
          Map data = {
            'user_id': Provider.of<UserInfoProvider>(context, listen: false)
                .user!
                .userId,
            'account_holder_name': accountHolderNameController.text.trim(),
            'bank_name': bankNameController.text.trim(),
            'account_number': accountNumberController.text.trim(),
            'ifsc_code': ifscCodeController.text.trim(),
          };
          final provider =
              Provider.of<BankAccountProvider>(context, listen: false);
          try {
            await provider.addUserBankAccounts(data);
            Get.snackbar("Succeful😀", "Bank account added successfully",
                backgroundColor: const Color.fromARGB(255, 136, 254, 136));

            await provider.fetchUserBankAccounts(
                // ignore: use_build_context_synchronously
                Provider.of<UserInfoProvider>(context, listen: false)
                    .user!
                    .userId);
          } catch (e) {
            Get.snackbar(
                "Failed", e.toString().replaceFirst('Exception: ', ''));
          }
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
          setState(() {
            _isSubmitPressedOnce = false;
          });

          accountHolderNameController.clear();
          accountNumberController.clear();
          ifscCodeController.clear();
          bankNameController.clear();
        },
        onCancel: () {
          Navigator.of(context).pop();
          _showAddAccountDialog();
        },
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _getConfirmInfo(
                  "Account Holder", accountHolderNameController.text.trim()),
              const SizedBox(height: 5),
              _getConfirmInfo("Bank Name", bankNameController.text.trim()),
              const SizedBox(height: 5),
              _getConfirmInfo(
                  "Account Number", accountNumberController.text.trim()),
              const SizedBox(height: 5),
              _getConfirmInfo("IFSC code", ifscCodeController.text.trim())
            ],
          ),
        ));
  }

  _getConfirmInfo(String key, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: Get.width * 0.3,
          child: Text(key),
        ),
        const Text(" : "),
        SizedBox(
          width: Get.width * 0.3,
          child: Text(value),
        ),
      ],
    );
  }

  validateFormOnChange(value) {
    if (_isSubmitPressedOnce) {
      formkey.currentState!.validate();
    }
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
          child: Form(
            key: formkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Add New Bank Account",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: accountHolderNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter valid data";
                    }
                    return null;
                  },
                  onChanged: validateFormOnChange,
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
                TextFormField(
                  controller: bankNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter valid data";
                    }
                    return null;
                  },
                  onChanged: validateFormOnChange,
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
                TextFormField(
                  controller: accountNumberController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter valid data";
                    }
                    return null;
                  },
                  onChanged: validateFormOnChange,
                  keyboardType: TextInputType.number,
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
                TextFormField(
                  controller: ifscCodeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter valid data";
                    }
                    return null;
                  },
                  onChanged: validateFormOnChange,
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
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        _isSubmitPressedOnce = true;
                      });
                      if (formkey.currentState!.validate()) {
                        Navigator.of(context).pop();
                        showConfirmationDialoge();
                      }
                      // Navigator.of(context).pop();
                    },
                  ),
                )
              ],
            ),
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
        title: const Text("Your Bank Accounts"),
      ),
      body: Consumer<BankAccountProvider>(builder: (context, value, child) {
        if (value.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (_isError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_errorMessage),
                ElevatedButton(onPressed: getData, child: const Text("Refresh"))
              ],
            ),
          );
        }
        if (value.accounts!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 150.h,
                  width: 150.w,
                  child:
                      SvgPicture.asset("assets/images/no_creation_found.svg"),
                ),
                SizedBox(height: 20.h),
                Text(
                  "No bank account added",
                  style: AppText.heddingStyle2bBlack,
                ),
                const SizedBox(height: 15),
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AppPrimaryElevetedButton(
                      onPressed: _showAddAccountDialog,
                      title: "Add New Bank Account",
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    )),
              ],
            ),
          );
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: value.accounts!.length,
                itemBuilder: (context, index) {
                  return _buildBankAccountCard(value.accounts![index], index);
                },
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: AppPrimaryElevetedButton(
                  onPressed: _showAddAccountDialog,
                  title: "Add New Bank Account",
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                )),
          ],
        );
      }),
    );
  }
}
