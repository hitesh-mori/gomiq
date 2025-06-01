import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gomiq/theme/colors.dart';

class ChatItem extends StatefulWidget {
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
  State<ChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {

  bool isHover = false ;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onExit: (_) {
        setState(() {
          isHover = false;
        });
      },
      onEnter: (_) {
        setState(() {
          isHover = true;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: (widget.isSelected || isHover)
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
                  Text(widget.title, style: GoogleFonts.poppins()),
                    if(isHover)
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
      ),
    );
  }
}
