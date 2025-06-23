import 'package:flutter/material.dart';
import 'package:gomiq/theme/colors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatListShimmer extends StatelessWidget {
  const ChatListShimmer({super.key});

  Widget shimmerItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.grey[300],
        ),
      ),
    );
  }

  Widget shimmerSection(String label, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title in black (not inside shimmer)
          Text(
            label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),

          // Items inside shimmer
          Shimmer.fromColors(
            baseColor: AppColors.theme['tertiaryColor'].withOpacity(0.1),
            highlightColor: AppColors.theme['tertiaryColor'].withOpacity(0.09),
            child: Column(
              children: List.generate(count, (_) => shimmerItem()),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          shimmerSection("Today", 1),
          shimmerSection("Yesterday", 2),
          shimmerSection("Last 7 Days", 3),
        ],
      ),
    );
  }
}
