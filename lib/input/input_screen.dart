import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          child: Text("뒤로"),
          onPressed: () {
            context.pop(true);
          },
        ),
        title: Text("중고상품 업로드"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.lightBlue,
      ),
    );
  }
}
