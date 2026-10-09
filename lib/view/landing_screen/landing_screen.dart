import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../configs/app.dart';
import '../../configs/configs.dart';
import '../../model/controllers/duplicate_controller.dart';
import '../rootscreen/root.dart';
import '../widgets/design/design.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final PageController _pageController = PageController();
  int _page = 0;

  late final List<_Slide> _slides = const [
    _Slide(
      image:
          'https://images.pexels.com/photos/374643/pexels-photo-374643.jpeg?auto=compress&cs=tinysrgb&w=1200',
      title: AppStrings.onboardingTitle1,
      body: AppStrings.onboardingBody1,
    ),
    _Slide(
      image:
          'https://images.pexels.com/photos/14581433/pexels-photo-14581433.jpeg?auto=compress&cs=tinysrgb&w=1200',
      title: AppStrings.onboardingTitle2,
      body: AppStrings.onboardingBody2,
    ),
    _Slide(
      image:
          'https://images.pexels.com/photos/37728173/pexels-photo-37728173.jpeg?auto=compress&cs=tinysrgb&w=1200',
      title: AppStrings.onboardingTitle3,
      body: AppStrings.onboardingBody3,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final intro =
        Get.find<DuplicateController>().introFunctions;
    await intro.saveLaunchStatus(status: false);
    if (!mounted) return;
    Get.offAll(const RootScreen(index: 0));
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final scheme = Theme.of(context).colorScheme;
    final isLast = _page == _slides.length - 1;

    return Scaffold(
      body: Stack(
        children: [
          // Full-bleed slides
          PageView.builder(
            controller: _pageController,
            itemCount: _slides.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (context, i) {
              final slide = _slides[i];
              return Stack(
                fit: StackFit.expand,
                children: [
                  ProductImage(url: slide.image, fit: BoxFit.cover),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.35),
                          Colors.transparent,
                          Colors.black.withOpacity(0.55),
                          Colors.black.withOpacity(0.88),
                        ],
                        stops: const [0, 0.35, 0.7, 1],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Brand + skip
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  Text(
                    AppStrings.brandName,
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _finish,
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Slide copy + CTA
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 0, 28, 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dots
                    Row(
                      children: List.generate(
                        _slides.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 260),
                          margin: const EdgeInsets.only(right: 8),
                          width: _page == i ? 28 : 9,
                          height: 9,
                          decoration: BoxDecoration(
                            color: _page == i
                                ? scheme.primary
                                : Colors.white.withOpacity(0.45),
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    // Copy (re-animates per page)
                    Column(
                      key: ValueKey(_page),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _slides[_page].title,
                          style: GoogleFonts.playfairDisplay(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.w600,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _slides[_page].body,
                          style: GoogleFonts.manrope(
                            color: Colors.white.withOpacity(0.88),
                            fontSize: 16,
                            height: 1.55,
                          ),
                        ),
                      ],
                    ).animate().fadeIn(duration: 420.ms).slideY(begin: 0.12),
                    const SizedBox(height: 30),
                    GlowButton(
                      label: isLast ? 'Start glowing' : 'Continue',
                      gradient: true,
                      onPressed: () {
                        if (isLast) {
                          _finish();
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 380),
                            curve: Curves.easeOutCubic,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Slide {
  final String image;
  final String title;
  final String body;

  const _Slide({required this.image, required this.title, required this.body});
}
