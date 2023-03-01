import 'package:flutter/material.dart';

class OnboardingMainWidget extends StatelessWidget {
  const OnboardingMainWidget(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.imagePath,
      required this.darkImagePath})
      : super(key: key);

  final String title;
  final String subtitle;
  final String imagePath;
  final String darkImagePath;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final size = MediaQuery.of(context).size;
    final darkMode = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Image.asset(
          darkMode ? darkImagePath : imagePath,
          height: size.height * .4,
          width: size.width * .7,
          fit: BoxFit.cover,
        ),
        Text(
          title,
          style: textTheme.titleLarge?.copyWith(fontSize: 35),
        ),
        const SizedBox(
          height: 40,
        ),
        Text(
          subtitle,
          style: textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
