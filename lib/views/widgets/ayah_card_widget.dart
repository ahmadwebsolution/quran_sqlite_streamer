import 'package:flutter/material.dart';
import '../../models/ayah_model.dart';

class AyahCardWidget extends StatelessWidget {
  final Ayah ayah;
  final bool isPlaying;
  final bool isAudioLoading;
  final VoidCallback onPlayToggle;

  const AyahCardWidget({
    super.key,
    required this.ayah,
    required this.isPlaying,
    required this.isAudioLoading,
    required this.onPlayToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 16,
                  child: Text(
                    '${ayah.ayahNumber}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                if (isAudioLoading)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  IconButton(
                    icon: Icon(
                      isPlaying ? Icons.stop_circle : Icons.play_circle_fill,
                      size: 34,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: onPlayToggle,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              ayah.textArabic,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              ayah.textTranslation,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}