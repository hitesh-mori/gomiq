import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:gomiq/apis/chat_api.dart';
import 'package:gomiq/helper_functions/web_toasts.dart';
import 'package:gomiq/provider/chat_provider.dart';
import 'package:gomiq/provider/user_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gomiq/theme/colors.dart';
import 'package:provider/provider.dart';

class ChatItem extends StatefulWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final String chatId ;
  final Function()? onDelete;


  const ChatItem({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap, required this.chatId,required this.onDelete,
  });

  @override
  State<ChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {

  bool isHover = false ;
  bool isHover2  = false;


  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider,ChatProvider>(builder: (context,userProvider,chatProvider,child){
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
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.title, style: GoogleFonts.poppins()),
                    if(isHover)
                      CustomPopup(
                        barrierColor: Colors.transparent,
                        backgroundColor: AppColors.theme['backgroundColor'],
                        contentPadding: EdgeInsets.symmetric(horizontal: 2),
                        content: Container(
                          height: 102,
                          width: 120,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 10,),
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: InkWell(
                                  onTap: (){

                                  },
                                  child: Container(
                                    width: 100,
                                    child: Center(child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Update"),
                                    )),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: AppColors.theme['primaryColor'].withOpacity(0.1),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10,),
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: InkWell(
                                  onTap:widget.onDelete,
                                  child: Container(
                                    width: 100,
                                    child: Center(child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Delete"),
                                    )),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: AppColors.theme['primaryColor'].withOpacity(0.1),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10,),

                            ],
                          ),
                        ),
                        child:  MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Icon(Icons.more_horiz_outlined),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }) ;
  }
}
