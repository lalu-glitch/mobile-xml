import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';

class BankCard extends StatelessWidget {
  final String title;
  final String minimumTopUp;
  final dynamic imageUrl;
  final VoidCallback klik;
  const BankCard({
    required this.title,
    required this.minimumTopUp,
    this.imageUrl,
    required this.klik,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: klik,
      child: Card(
        elevation: 0,
        shadowColor: kNeutral60,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: kWhite,
        margin: const EdgeInsets.only(top: 6, bottom: 6),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: (imageUrl is String && imageUrl.isNotEmpty)
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.contain,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.business_rounded),
                      )
                    : const Icon(
                        Icons.business_rounded,
                        size: 30,
                        color: kNeutral70,
                      ),
              ),
              SizedBox(width: kSize16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    minimumTopUp,
                    style: TextStyle(fontSize: 13, color: kNeutral70),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
