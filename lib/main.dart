import 'package:flutter/material.dart';

void main() => runApp(const CounterApp());

class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Counter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const CounterPage(),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage>
    with SingleTickerProviderStateMixin {
  int _counter = 0;
  late AnimationController _controller;
  late Animation<Color?> _color1;
  late Animation<Color?> _color2;

  void _increase() => setState(() => _counter++);
  void _decrease() {
    if (_counter > 0) {
      setState(() => _counter--);
    }
  }

  void _reset() => setState(() => _counter = 0);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);

    _color1 = ColorTween(
      begin: Colors.deepPurple,
      end: Colors.pinkAccent,
    ).animate(_controller);

    _color2 = ColorTween(
      begin: Colors.indigo,
      end: Colors.orangeAccent,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildGradientCounterText(String value) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [
          Colors.cyanAccent,
          Colors.pinkAccent,
          Colors.yellowAccent,
          Colors.lightGreenAccent,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 100,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCircleTextButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.orangeAccent, width: 5),
      ),
      child: RawMaterialButton(
        onPressed: onPressed,
        shape: const CircleBorder(),
        fillColor: color,
        constraints: const BoxConstraints.tightFor(
          width: 100,
          height: 100,
        ),
        elevation: 6.0,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.yellow,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _color1.value ?? Colors.deepPurple,
                  _color2.value ?? Colors.indigo,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: SizedBox(
                width: 400, // fixed layout
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 100, vertical: 50),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.orange, width: 10),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Counter',
                            style:
                            TextStyle(fontSize: 50, color: Colors.white70),
                          ),
                          const SizedBox(height: 10),
                          _buildGradientCounterText('$_counter',),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCircleTextButton(
                          label: "Decrease",
                          color: Colors.redAccent,
                          onPressed: _decrease,
                        ),
                        _buildCircleTextButton(
                          label: "Reset",
                          color: Colors.blueGrey,
                          onPressed: _reset,
                        ),
                        _buildCircleTextButton(
                          label: "Increase",
                          color: Colors.green,
                          onPressed: _increase,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
