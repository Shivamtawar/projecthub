// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:projecthub/view/home/provider/categories_provider.dart';
import 'package:projecthub/config/api_config.dart';
import 'package:projecthub/constant/app_color.dart';
import 'package:projecthub/constant/app_text.dart';
import 'package:projecthub/view/home/model/categories_info_model.dart';
import 'package:provider/provider.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State createState() {
    return _CategoriesPage();
  }
}

class _CategoriesPage extends State<CategoriesPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<bool> _requestPop() {
    Navigator.of(context).pop();
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    // double viewWidth = 100;
    var crossAxisSpacing = 1;
    var screenWidth = MediaQuery.of(context).size.width;
    var crossAxisCount = 2;
    var width = (screenWidth - ((crossAxisCount - 1) * crossAxisSpacing)) /
        crossAxisCount;
    var cellHeight = width;
    var aspectRatio = width / cellHeight;

    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
          backgroundColor: AppColor.bgColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColor.bgColor,
            title: Text("Categories",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppText.font18Px,
                  // fontFamily: ConstantData.fontFamily,
                  color: AppColor.textColor,
                )),
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  color: AppColor.iconBlack,
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () {
                    Get.back();
                  },
                );
              },
            ),
          ),
          body: Container(
            margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.width * 0.01),
                  child: Consumer<CategoriesProvider>(
                      builder: (context, value, child) {
                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      shrinkWrap: true,
                      childAspectRatio: aspectRatio,
                      // childAspectRatio: 0.64,
                      primary: false,
                      children:
                          List.generate(value.categories!.length, (index) {
                        return BackGroundTile(
                          subCategoryModel: value.categories![index],
                          cellHeight: cellHeight,
                        );
                      }),
                    );
                  }),
                ),
              ],
            ),
          ),
        ));
  }
}

class BackGroundTile extends StatelessWidget {
  final CategoryModel? subCategoryModel;
  final double? cellHeight;

  const BackGroundTile({super.key, this.subCategoryModel, this.cellHeight});

  static Future<Color> getDominantColor(String imageUrl) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      NetworkImage(imageUrl),
      maximumColorCount: 10, // Increases accuracy
    );

    return paletteGenerator.dominantColor?.color ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    double imageSize = cellHeight! * 0.51;
    double radius = 15;

    return InkWell(
      child: Container(
        height: cellHeight,
        //padding: EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 202, 200, 200),
              blurRadius: 10,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder<Color>(
                future: getDominantColor(
                    ApiConfig.getFileUrl(subCategoryModel!.image!)),
                //This function return color from Sqlite DB Asynchronously
                builder: (BuildContext context, AsyncSnapshot<Color> snapshot) {
                  Color color;
                  if (snapshot.hasData) {
                    color = snapshot.data!;
                  } else {
                    color = const Color.fromARGB(255, 255, 241, 200);
                  }

                  return Container(
                    height: imageSize,
                    width: double.infinity,
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: color,
                      borderRadius: BorderRadius.all(
                        Radius.circular(radius * 0.5),
                      ),
                    ),
                    child: Container(
                      //  height: 80,
                      width: 80,
                      child: Image.network(
                        ApiConfig.getFileUrl(subCategoryModel!.image!),
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                }),
            Expanded(
              child: Center(
                child: Text(
                  maxLines: 2,
                  subCategoryModel!.name!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 30, 30, 30)),
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) => SubCategoriesPage(subCategoryModel!.id)));
      },
    );
  }
}
