import 'package:flutter/material.dart';


class MyRecipesPage extends StatefulWidget {
  final Map<String, dynamic> detail;
  const MyRecipesPage({super.key, required this.detail});
  

  @override
  State<MyRecipesPage> createState() => _MyRecipesPageState();
}

class _MyRecipesPageState extends State<MyRecipesPage> {

 

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
