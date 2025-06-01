import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gomiq/theme/colors.dart';

class ChatItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const ChatItem({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: isSelected
                ? AppColors.theme['primaryColor'].withOpacity(0.2)
                : AppColors.theme['backgroundColor'],
            // boxShadow: const [
            //   BoxShadow(
            //     color: Colors.black12,
            //     blurRadius: 1,
            //     offset: Offset(0, 1),
            //   ),
            // ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: GoogleFonts.poppins()),
                  if(isSelected)
                  IconButton(
                    icon: const Icon(Icons.more_horiz_outlined),
                    onPressed: () {

                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
