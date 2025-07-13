// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:palette_generator/palette_generator.dart';
import 'package:projecthub/app_providers/data_file_provider.dart';
import 'package:projecthub/constant/app_color.dart';
import 'package:projecthub/constant/app_text.dart';
import 'package:projecthub/model/categories_info_model.dart';
import 'package:provider/provider.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State createState() {
    return _CategoriesPage();
  }
}

class _CategoriesPage extends State<CategoriesPage> {
  List<CategoryModel> categoryModelList = [];

  @override
  void initState() {
    super.initState();
  }

  void getData() {
    categoryModelList = Provider.of<DataFileProvider>(context).categories;
  }

  Future<bool> _requestPop() {
    Navigator.of(context).pop();
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    getData();
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
            centerTitle: true,
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
                  child: GridView.count(
                    crossAxisCount: crossAxisCount,
                    shrinkWrap: true,
                    childAspectRatio: aspectRatio,
                    // childAspectRatio: 0.64,
                    primary: false,
                    children: List.generate(categoryModelList.length, (index) {
                      return BackGroundTile(
                        subCategoryModel: categoryModelList[index],
                        cellHeight: cellHeight,
                      );
                    }),
                  ),
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

  static Future<Color> _updatePaletteGenerator(String imageName) async {
    ByteData imageBytes = await rootBundle.load(imageName);
    img.Image photo;
    photo = img.decodeImage(imageBytes.buffer.asUint8List())!;
    //log("imagesize==${photo.width}");
    Rect region =
        Offset.zero & Size(photo.width.toDouble(), photo.height.toDouble());

    PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      AssetImage(imageName),
      size: Size(photo.width.toDouble(), photo.height.toDouble()),
      region: region,
      maximumColorCount: 10,
    );
    return paletteGenerator.colors.first
        .withOpacity(paletteGenerator.colors.first.computeLuminance());
  }

  @override
  Widget build(BuildContext context) {
    double imageSize = cellHeight! * 0.55;
    double radius = 15;
    double bottomRemainSize = cellHeight! - imageSize;

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
                future: _updatePaletteGenerator(subCategoryModel!.image!),
                //This function return color from Sqlite DB Asynchronously
                builder: (BuildContext context, AsyncSnapshot<Color> snapshot) {
                  Color color;
                  if (snapshot.hasData) {
                    color = snapshot.data!;
                  } else {
                    color = Colors.amber;
                  }

                  return Container(
                    height: imageSize,
                    width: double.infinity,
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: color,
                      borderRadius: BorderRadius.all(
                        Radius.circular(radius),
                      ),
                    ),
                    child: Image.asset(
                      subCategoryModel!.image!,
                      fit: BoxFit.cover,
                    ),
                  );
                }),
            Text(
              subCategoryModel!.name!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 30, 30, 30)),
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
