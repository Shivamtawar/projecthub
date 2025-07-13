import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/services.dart';

class ReferScreen extends StatefulWidget {
  const ReferScreen({super.key});

  @override
  State<ReferScreen> createState() => _ReferScreenState();
}

class _ReferScreenState extends State<ReferScreen> {
  bool _isExpanded1 = false;
  bool _isExpanded2 = false;
  bool _isExpanded3 = false;
  String text = "SuperApp";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 600,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(40),
                  bottomLeft: Radius.circular(40)),
              color: Color.fromARGB(255, 74, 35, 179),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Center(
                  child: Text(
                    maxLines: 2,
                    overflow: TextOverflow.visible,
                    "Refer your friends and Earn",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Image.asset(
                  "assets/reward.png",
                  height: 120,
                  width: 170,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/star1.png",
                      height: 30,
                      width: 30,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      "100",
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  width: 310,
                  child: Text(
                    maxLines: 2,
                    overflow: TextOverflow.visible,
                    "Your friend gets 100 TimesPoints on sign up and , you get 100 TimesPoints too everytime!",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 60.0, right: 60),
                  child: DottedBorder(
                    color: Colors.white,
                    strokeWidth: 2,
                    dashPattern: const [6, 3],
                    child: Container(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: Row(
                        children: [
                          Text(
                            text,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 20),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          const Text(
                            "|",
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          InkWell(
                              child: const Text(
                                "Copy Code",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white70),
                              ),
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: text));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text(
                                          'Referral code copied to clipboard!')),
                                );
                              })
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                const Text(
                  "Share your Referral Code via",
                  style: TextStyle(
                      fontSize: 19,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                item('What is Refer and Earn Program?', 'Dummy Text.',
                    _isExpanded1, (value) {
                  setState(() {
                    _isExpanded1 = value;
                  });
                }),
                item('How it works?', 'Dummy Text.', _isExpanded2, (value) {
                  setState(() {
                    _isExpanded2 = value;
                  });
                }),
                item('Where can I use these LoyaltyPoints?', 'Dummy Text.',
                    _isExpanded3, (value) {
                  setState(() {
                    _isExpanded3 = value;
                  });
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget item(
      String header, String details, bool isExpanded, Function(bool) onTap) {
    return ListTile(
      title: Text(
        header,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
      onTap: () {
        onTap(!isExpanded);
      },
      subtitle: isExpanded ? Text(details) : null,
    );
  }
}
