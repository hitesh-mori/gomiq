import 'dart:convert';
import 'package:gomiq/provider/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gomiq/apis/chat_api.dart';
import 'package:gomiq/helper_functions/web_toasts.dart';
import 'package:gomiq/main.dart';
import 'package:gomiq/models/chat.dart';
import 'package:gomiq/models/chat_content.dart';
import 'package:gomiq/widgets/chat_item.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gomiq/theme/colors.dart';
import 'package:intl/intl.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  static const route = "/chat";
  static const fullRoute = "/chat";

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  Chat? selectedChat;

  final TextEditingController _promptController = TextEditingController();


  List<Chat> allChats  = [] ;

  bool isSending = false ;

  @override
  void initState() {
    super.initState();
    fetchChats();
  }

  // Fetch chats and update UI
  Future<void> fetchChats() async {

    final fetchedChats = await ChatApi.fetchChatsWithContent("ab9aa5c7-9854-48c1-8686-ee187a5a4f9a");

    setState(() {
      allChats = fetchedChats ;
    });

  }


  Map<String, List<Chat>> groupChatsByDate(List<Chat> chats) {
    final Map<String, List<Chat>> grouped = {};
    final now = DateTime.now();

    for (var chat in chats) {
      final created = chat.createdAt;
      final difference = now.difference(created);
      String key;

      if (difference.inDays == 0 && now.day == created.day) {
        key = 'Today';
      } else if (difference.inDays == 1 ||
          (difference.inDays == 0 && now.day != created.day)) {
        key = 'Yesterday';
      } else if (difference.inDays <= 7) {
        key = 'Last 7 Days';
      } else if (created.year == now.year && created.month == now.month) {
        key = DateFormat('d MMMM').format(created);
      } else {
        key = DateFormat('d MMMM yyyy').format(created);
      }

      grouped.putIfAbsent(key, () => []).add(chat);
    }

    return grouped;
  }


  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size ;
    final groupedChats = groupChatsByDate(allChats);

    return Consumer<UserProvider>(builder: (context,userProvider,child){
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: AppColors.theme['backgroundColor'],
          body: Row(

            children: [

              // Sidebar
              Container(
                width: 250,
                decoration: BoxDecoration(
                  color: AppColors.theme['backgroundColor'],
                  border: Border.all(
                    color: AppColors.theme['tertiaryColor']!.withOpacity(0.1),
                  ),
                ),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment :MainAxisAlignment.spaceBetween,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                "assets/logo/logo.png",
                                height: 40,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),

                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: InkWell(
                                onTap: () async {
                                  bool success = await ChatApi.createChat(
                                    userId: 'ab9aa5c7-9854-48c1-8686-ee187a5a4f9a',
                                    title: 'New Chat Title',
                                  );

                                  if (success) {
                                    // Step 2: Fetch updated chats
                                    List<Chat> updatedChats = await ChatApi.fetchChatsWithContent('ab9aa5c7-9854-48c1-8686-ee187a5a4f9a');

                                    // Step 3: Update UI
                                    setState(() {
                                      allChats.clear();
                                      allChats.addAll(updatedChats);
                                      selectedChat = updatedChats.isNotEmpty ? updatedChats.last : null;
                                    });
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.theme['backgroundColor'],
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        offset: Offset(0, 1),
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                                    child: Row(
                                      children: [
                                        Icon(Icons.add),
                                        Text("ADD", style: GoogleFonts.poppins()),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )

                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Divider(
                        color:
                        AppColors.theme['tertiaryColor']!.withOpacity(0.1),
                      ),

                      Expanded(
                        child: ListView(
                          children: groupedChats.entries.toList().reversed.map((entry) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    entry.key,
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                ...entry.value.reversed.map(
                                      (chat) => ChatItem(
                                    title: chat.title,
                                    isSelected: selectedChat == chat,
                                    onTap: () =>
                                        setState(() => selectedChat = chat),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),

                      Divider(
                        color:
                        AppColors.theme['tertiaryColor']!.withOpacity(0.1),
                      ),

                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          // color: AppColors.the
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  child: Center(child: Icon(Icons.person)),
                                  backgroundColor: AppColors.theme['primaryColor'].withOpacity(0.2),
                                ),
                                SizedBox(width: 5,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(userProvider.user?.userName ?? "User Name",style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.bold),) ,
                                    Text(userProvider.user?.email ?? "User Email",style: GoogleFonts.poppins(fontSize: 12),),
                                  ],
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(Icons.logout),
                              onPressed: (){

                              },
                            )
                          ],
                        ),
                      ) ,
                    ],
                  ),
                ),
              ),

              Expanded(
                child: Column(
                  children: [

                    SizedBox(height: 20,),

                    // Scrollable main content
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: selectedChat != null
                              ? selectedChat!.chatContent.isEmpty ? Padding(
                            padding:  EdgeInsets.symmetric(vertical: mq.height*0.3),
                            child: Text("Start Conversion",style: GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: 25),),
                          ) : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(
                              //   selectedChat!.title,
                              //   style: GoogleFonts.poppins(
                              //       fontSize: 22, fontWeight: FontWeight.w600),
                              // ),
                              // const SizedBox(height: 10),
                              // Text(
                              //   'Created: ${DateFormat('d MMM yyyy, hh:mm a').format(selectedChat!.createdAt)}',
                              //   style: GoogleFonts.poppins(
                              //     fontSize: 14,
                              //     color: Colors.grey,
                              //   ),
                              // ),
                              const SizedBox(height: 20),
                              ...selectedChat!.chatContent.toList().reversed.map(
                                    (content) => Padding(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.theme['primaryColor'].withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),

                                        padding: EdgeInsets.all(8),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: AppColors.theme['primaryColor'].withOpacity(0.2),
                                              child: Icon(Icons.person, size: 20,color:AppColors.theme['tertiaryColor'],),
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                '${content.query}',
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                                softWrap: true,
                                                overflow: TextOverflow.visible,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(height: 30,),

                                      MarkdownBody(
                                        data: content.response,
                                        styleSheet:
                                        MarkdownStyleSheet.fromTheme(
                                            Theme.of(context)).copyWith(
                                          p: GoogleFonts.poppins(fontSize: 14),
                                          codeblockDecoration: BoxDecoration(
                                            color: Colors.transparent,
                                          ),
                                          tableHead: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                          tableBody: GoogleFonts.poppins(),
                                          code: GoogleFonts.robotoMono(),
                                        ),
                                        builders: {
                                          'code': CodeElementBuilder(context),
                                        },
                                      ),

                                      const SizedBox(height: 10),

                                      const Divider(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                              : Padding(
                            padding:  EdgeInsets.symmetric(vertical: mq.height*0.3),
                            child: Text("Click + to create new chat",style: GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: 25),),
                          ),
                        ),
                      ),
                    ),

                    // Sticky bottom container
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
                      child: Container(
                        height: 100,
                        width: mq.width * 0.5,
                        decoration: BoxDecoration(
                          color: AppColors.theme['backgroundColor'],
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0, 1),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                        ),

                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Container(
                                    height: 50,
                                    width: mq.width * 0.4,
                                    child: Theme(
                                      data: ThemeData(
                                          textSelectionTheme: TextSelectionThemeData(
                                              selectionHandleColor:
                                              AppColors.theme['primaryColor'],
                                              cursorColor: AppColors.theme['primaryColor'],
                                              selectionColor:
                                              AppColors.theme['primaryColor'].withOpacity(0.3))),
                                      child: TextFormField(
                                        maxLines: null,
                                        controller: _promptController,
                                        decoration: InputDecoration(
                                          hintText: 'Enter your query here...',
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),

                                  Container(
                                    height: 40,
                                    width: 120,
                                    child: Center(
                                      child: Text("Attach PDF",style: GoogleFonts.poppins(color: Colors.white,fontSize: 14),),
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.theme['primaryColor'],
                                      borderRadius: BorderRadius.circular(8),
                                    ),

                                  )

                                ],
                              ),

                              CircleAvatar(
                                backgroundColor: AppColors.theme['primaryColor'],
                                child:isSending ? Container(height:20,width :20,child: CircularProgressIndicator(color: Colors.white,)) :IconButton(
                                  icon: Icon(Icons.send, color: Colors.white),
                                  onPressed: () async {

                                    final prompt = _promptController.text.trim();
                                    if (prompt.isEmpty || selectedChat == null) return;

                                    setState(() {
                                      isSending = true;
                                    });

                                    final success = await ChatApi.sendPrompt(
                                      prompt: prompt,
                                      userId: 'ab9aa5c7-9854-48c1-8686-ee187a5a4f9a',
                                      chatId: selectedChat!.chatId,
                                    );

                                    setState(() {
                                      isSending = false;
                                    });

                                    if (success) {
                                      _promptController.clear();

                                      final contentUrl = Uri.parse(
                                        'https://chatbot-task-mfcu.onrender.com/api/get_conversation'
                                            '?chat_id=${selectedChat!.chatId}&user_id=ab9aa5c7-9854-48c1-8686-ee187a5a4f9a',
                                      );

                                      final response = await http.get(contentUrl);
                                      if (response.statusCode == 200) {
                                        final body = response.body;
                                        final decoded = jsonDecode(body);
                                        if (decoded is List) {
                                          final updatedContent = decoded
                                              .map<ChatContent>((e) => ChatContent.fromJson(e))
                                              .toList();

                                          setState(() {
                                            selectedChat = Chat(
                                              title: selectedChat!.title,
                                              chatId: selectedChat!.chatId,
                                              createdAt: selectedChat!.createdAt,
                                              chatContent: updatedContent,
                                            );

                                            // Also update in allChats if needed
                                            final idx = allChats.indexWhere((c) => c.chatId == selectedChat!.chatId);
                                            if (idx != -1) {
                                              allChats[idx] = selectedChat!;
                                            }
                                          });
                                        }
                                      }
                                    }
                                  },
                                ),
                              ),

                            ],

                          ),
                        ),
                      ),
                    )


                  ],
                ),
              )





            ],
          ),
        ),
      );
    });
  }
}


class CodeElementBuilder extends MarkdownElementBuilder {

  final BuildContext context;

  CodeElementBuilder(this.context);

  @override
  Widget visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final code = element.textContent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [

          Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.theme['primaryColor'].withOpacity(0.4),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Code Snippet",
                    style: GoogleFonts.poppins(color: Colors.black,fontWeight: FontWeight.w400),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, color: Colors.black,size: 20,),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: code));
                      WebToasts.showToastification("Code Copy", "Copied", Icon(Icons.copy),context) ;
                    },
                  ),
                ],
              ),
            ),
          ),

          // Code Area
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.theme['tertiaryColor'].withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
            child: SelectableText(
              code,
              style: GoogleFonts.robotoMono(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}