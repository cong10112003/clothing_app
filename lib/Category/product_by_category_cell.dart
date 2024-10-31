import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:food_app/common/color_extension.dart';
import 'package:intl/intl.dart';

class ProductByCategoryCell extends StatelessWidget {
  final Map<String, dynamic> item;
  const ProductByCategoryCell({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NumberFormat currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    var media = MediaQuery.of(context).size;
    String imageString = item['ThumbNail'] ?? "";
    bool isValidImageUrl = Uri.tryParse(imageString)?.isAbsolute ?? false;

    // Chuyển base64 sang Uint8List
    Uint8List? _base64ToUint8List(String base64String) {
      try {
        return base64Decode(base64String);
      } catch (e) {
        return null;
      }
    }

    // Hàm tạo hình ảnh từ URL hoặc base64
    Widget _buildImage() {
      if (isValidImageUrl) {
        return Image.network(
          imageString,
          fit: BoxFit.cover,
          width: media.width * 0.4,
          height: media.width * 0.3,
        );
      } else {
        Uint8List? imageBytes = _base64ToUint8List(imageString);
        if (imageBytes != null) {
          return Image.memory(
            imageBytes,
            fit: BoxFit.cover,
            width: media.width * 0.4,
            height: media.width * 0.3,
          );
        } else {
          return Icon(
            Icons.image,
            color: Colors.grey[600],
            size: media.width * 0.3,
          );
        }
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      width: media.width * 0.4,
      height: media.width * 0.6,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            child: Container(
              color: TColor.secondary,
              width: media.width * 0.4,
              height: media.width * 0.3,
              child: _buildImage(),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["ProductName"]?.toString() ?? "N/A",
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: TColor.text,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  item["Description"]?.toString() ?? "N/A",
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: TColor.gray,
                      fontSize: 12,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  currencyFormat.format(item["Price"] ?? 0),
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: TColor.gray,
                      fontSize: 12,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
