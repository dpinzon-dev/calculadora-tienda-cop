import 'package:calculadora_tienda/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créditos', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.calculate_outlined,
                size: 64,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: 24),
              const Text(
                'Calculadora Tienda',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              const Text(
                'Desarrollado por',
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 6),
              const Text(
                'Diego Alexander Pinzón Camargo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const Text(
                'Más proyectos en GitHub',
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () async {
                  final uri = Uri.parse(
                    'https://github.com/dpinzon-dev?tab=repositories',
                  );
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                child: const Text(
                  'github.com/dpinzon-dev',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
