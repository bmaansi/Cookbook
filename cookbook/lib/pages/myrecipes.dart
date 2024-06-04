import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';



class MyRecipesPage extends StatefulWidget {
  final Map<String, dynamic> detail;
  const MyRecipesPage({super.key, required this.detail});
  

  @override
  State<MyRecipesPage> createState() => _MyRecipesPageState();
}

class _MyRecipesPageState extends State<MyRecipesPage> {

    Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      if (kDebugMode) {
      print('Could not launch $url'); 
      }
    }
  }

  @override
    Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.detail['Title']),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Image.network(widget.detail['Image']),

            Text(
              // ignore: prefer_interpolation_to_compose_strings
              'STEPS:' +
              (widget.detail['Steps'] as List)
              .map((step) => "\n-$step")
              .join(),
              style: const TextStyle(fontSize: 16),
            ),

              const SizedBox(height: 10),
            
             Text(
              // ignore: prefer_interpolation_to_compose_strings
              'INGREDIENTS:' +
              (widget.detail['Ingredients'] as List)
              .map((ing) => "\n-$ing")
              .join(),
              style: const TextStyle(fontSize: 16),
            ),

          ],
        ),
      ),
    );
  }

}
