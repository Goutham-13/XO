import 'package:flutter/material.dart';
import 'game_screen.dart';

class ModeSelectionScreen extends StatefulWidget {
  const ModeSelectionScreen({super.key});

  @override
  State<ModeSelectionScreen> createState() => _ModeSelectionScreenState();
}

class _ModeSelectionScreenState extends State<ModeSelectionScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller1;
  late final AnimationController _controller2;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  void _onTap(int modeIndex) async {
    if (_isNavigating) return;
    setState(() => _isNavigating = true);

    final controller = modeIndex == 0 ? _controller1 : _controller2;
    await controller.forward();
    await controller.reverse();

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(isSinglePlayer: modeIndex == 1),
      ),
    ).then((_) {
      setState(() => _isNavigating = false);
    });
  }

  Widget _animatedInkButton({
    required String label,
    required VoidCallback onTap,
    required Color inkColor,
    required AnimationController controller,
  }) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final scale = 1 - controller.value;
        final opacity = 0.7 + (controller.value * 0.3);
        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          margin: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: inkColor, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Notebook',
              fontSize: 22,
              color: inkColor,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/notebook.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Choose Mode',
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Notebook',
                  color: Colors.black,
                ),
              ),
              _animatedInkButton(
                label: "Two Player (Offline)",
                onTap: () => _onTap(0),
                inkColor: Colors.blue.shade800,
                controller: _controller1,
              ),
              _animatedInkButton(
                label: "Single Player (vs Bot)",
                onTap: () => _onTap(1),
                inkColor: Colors.red.shade700,
                controller: _controller2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
