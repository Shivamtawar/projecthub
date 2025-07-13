import 'package:flutter/widgets.dart';
import 'package:projecthub/view/bank_accounts/provider/bank_account_provider.dart';
import 'package:projecthub/app_providers/creation_provider.dart';
import 'package:projecthub/view/profile/provider/user_provider.dart';
import 'package:provider/provider.dart';

import '../view/cart/provider/card_creation_provider.dart';
import '../view/purchase/provider/purchased_creation_provider.dart';

class ClearDataController {
  void clearAllProviders(BuildContext context) {
    Provider.of<UserInfoProvider>(context, listen: false).reset();
    Provider.of<ListedCreationProvider>(context, listen: false).reset();
    Provider.of<GeneralCreationProvider>(context, listen: false).reset();
    Provider.of<TreandingCreationProvider>(context, listen: false).reset();
    Provider.of<PurchedCreationProvider>(context, listen: false).reset();
    Provider.of<RecomandedCreationProvider>(context, listen: false).reset();
    Provider.of<RecentCreationProvider>(context, listen: false).reset();
    Provider.of<InCardCreationProvider>(context, listen: false).reset();
    Provider.of<BankAccountProvider>(context, listen: false).reset();
    // Add more providers here...
  }
}
