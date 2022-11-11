import 'package:flutter/material.dart';

import 'multi_slice_progress_indicator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Multi Slice Progress Indicator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late final ProgressController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ProgressController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MultiSliceProgressIndicator(
            // radius: 64,
            controller: _controller,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Button(
                  label: 'Start',
                  color: Colors.pink,
                  onPressed: () {
                    _controller.start();
                  },
                ),
                Button(
                  label: 'Succeed',
                  color: Colors.cyan,
                  onPressed: () {
                    _controller.completeWithSuccess();
                  },
                ),
                Button(
                  label: 'Fail',
                  color: Colors.red,
                  onPressed: () {
                    _controller.completeWithFailure();
                  },
                ),
                Button(
                  label: 'Reverse',
                  color: Colors.indigo,
                  onPressed: () {
                    _controller.reverse();
                  },
                ),
                Button(
                  label: 'Cancel',
                  color: Colors.brown,
                  onPressed: () {
                    _controller.stop();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      ),
      child: Text(label),
    );
  }
}
