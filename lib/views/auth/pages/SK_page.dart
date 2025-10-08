import 'package:flutter/material.dart';

import '../../../core/helper/constant_finals.dart';

class SyaratDanKetentuan extends StatelessWidget {
  const SyaratDanKetentuan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        title: const Text(
          'Syarat & Ketentuan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: kWhite,
        scrolledUnderElevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Diperbarui pada 02 Juli 2023',
              style: TextStyle(color: kOrange, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: kWhite,
                  border: Border.all(color: kLightGrey, width: 1.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  widthFactor: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          ''' Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque sed luctus tellus. Interdum et malesuada fames ac ante ipsum primis in faucibus. Pellentesque tincidunt eros at felis auctor suscipit. Mauris ac mollis leo. Duis erat dui, lobortis id sapien id, semper aliquet libero. Nam et dictum dolor. Nam laoreet eros vitae massa molestie, vulputate euismod velit ornare. Morbi leo sapien, iaculis eu dui sit amet, feugiat rutrum lectus. Nulla eu felis a enim viverra consectetur a sed lacus. Integer convallis, nisl nec tincidunt facilisis, nibh lectus semper arcu, eu egestas lectus ipsum malesuada sapien. Ut ullamcorper tincidunt egestas. In id metus nec nulla ornare feugiat et a lacus. Ut et dui ipsum. Praesent tempor, risus eu hendrerit dignissim, mi ante faucibus nulla, nec imperdiet nunc justo nec nisi.\n\n Sed egestas porttitor libero eget rutrum. Sed imperdiet nisi id dui vulputate, quis feugiat tortor mollis. Sed scelerisque pretium magna, a congue diam aliquam vitae. Sed varius interdum enim. Duis accumsan mattis tellus quis dignissim. Suspendisse eget arcu sed massa lobortis accumsan. Nam cursus dictum sem, ut luctus neque vestibulum sit amet.\n\n Donec bibendum ornare erat at elementum. Donec ac pharetra diam. Ut rutrum ut risus bibendum pretium. Proin lectus sem, pharetra ac varius nec, aliquet sit amet augue. Aliquam semper varius massa non sodales. Phasellus at diam eu odio porta fringilla a in neque. Suspendisse tellus nibh, condimentum vitae dignissim in, euismod a mauris. Nullam id laoreet enim. In eu nibh mauris. Nunc iaculis ac risus id pretium. Vestibulum sollicitudin eget nisl non porta.\n\n Phasellus et rhoncus elit. Etiam vel augue ac ante convallis interdum. Quisque aliquet varius turpis vitae porttitor. Duis mollis arcu metus, et varius ante varius vel. Suspendisse aliquet varius accumsan. Curabitur fermentum turpis neque, id malesuada turpis congue non. Etiam euismod lorem sed nisi pulvinar posuere. Pellentesque risus dui, commodo sit amet lorem vel, iaculis rutrum orci. Ut sit amet interdum velit.\n\n Integer vulputate maximus ipsum, viverra finibus nulla facilisis nec. Sed imperdiet tincidunt massa ac facilisis. Quisque posuere, odio quis commodo malesuada, nisi lorem accumsan odio, vitae pharetra quam leo vitae diam. Cras pellentesque sem lorem, at blandit tortor feugiat ut. Interdum et malesuada fames ac ante ipsum primis in faucibus. Proin eget arcu ex. Ut id eleifend tortor, vitae convallis ligula. Cras nulla nibh, scelerisque at tincidunt faucibus, sollicitudin at metus. Nulla id efficitur odio, non fringilla ligula. Proin sagittis metus sit amet nisi tincidunt, id vehicula ipsum lobortis. Ut in orci a felis congue consequat. Aliquam eu lectus id risus scelerisque viverra eu vitae massa. Praesent consequat, ipsum vitae dapibus elementum, elit lorem vehicula mauris, facilisis dapibus urna turpis vel erat. Proin luctus euismod augue sit amet gravida. Cras lobortis leo at lectus malesuada, sed aliquet neque viverra. Nulla faucibus, metus ut egestas placerat, elit nibh mattis neque, id vehicula lectus mauris a ante.\n\n  Maecenas maximus tempor velit vel porta. Morbi augue neque, mollis in mattis a, vestibulum quis justo. Sed hendrerit dignissim elit tincidunt elementum. Nullam lacinia mattis purus non iaculis. Proin eget.
                          ''',
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kLightGrey,
                        foregroundColor: kBlack,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text(
                        "Kembali",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kOrange,
                        foregroundColor: kWhite,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: const Text(
                        "Setuju",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
