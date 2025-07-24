import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:gomiq/provider/chat_provider.dart';
import 'package:gomiq/provider/user_provider.dart';
import 'package:gomiq/shimmer_effect/chat_item_shimmer.dart';
import 'package:gomiq/widgets/custom_button.dart';
import 'package:gomiq/widgets/custom_text_feild.dart';
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
import 'package:url_launcher/url_launcher.dart';

class ChatScreen extends StatefulWidget {
  static const route = "/chat";
  static const fullRoute = "/chat";

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Chat? selectedChat;

  bool isLoadChats = false;


  final TextEditingController _promptController = TextEditingController();

  bool isSending = false;

  final ScrollController _scrollController = ScrollController();
  bool _showScrollButton = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    initAppData();
    fetchChats();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;

    if ((maxScroll - currentScroll) <= 10) {
      if (_showScrollButton) {
        setState(() => _showScrollButton = false);
      }
    } else {
      if (!_showScrollButton) {
        setState(() => _showScrollButton = true);
      }
    }
  }

  Future<void> initAppData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    await userProvider.initUser();
  }

  // Fetch chats and update UI
  Future<void> fetchChats() async {
    print("hello come");
    setState(() {
      isLoadChats = true;
    });

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    await chatProvider.fetchChatsProvider(context);

    setState(() {
      isLoadChats = false;
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
      } else if ((difference.inDays == 0 && now.day != created.day)) {
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
    mq = MediaQuery.of(context).size;

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    final groupedChats = groupChatsByDate(chatProvider.allChats);

    return Consumer2<UserProvider, ChatProvider>(
        builder: (context, userProvider, chatProvider, child) {
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  WebToasts.showToastification(
                                      "Waiting...",
                                      "We are creating new chat please wait",
                                      Icon(
                                        Icons.timelapse,
                                        color: Colors.green,
                                      ),
                                      context);

                                  bool success = await ChatApi.createChat(
                                    userId: userProvider.currUserId ?? "",
                                    title: 'New Chat Title',
                                  );

                                  await chatProvider
                                      .fetchChatsProvider(context);

                                  if (success) {
                                    setState(() {
                                      selectedChat =
                                          chatProvider.allChats.isNotEmpty
                                              ? chatProvider.allChats.last
                                              : null;
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 5),
                                    child: Row(
                                      children: [
                                        Icon(Icons.add),
                                        Text("ADD",
                                            style: GoogleFonts.poppins()),
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
                      isLoadChats
                          ? Expanded(child: ChatListShimmer())
                          : Expanded(
                              child: ListView(
                                children: groupedChats.entries
                                    .toList()
                                    .reversed
                                    .map((entry) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          onTap: () => setState(
                                              () => selectedChat = chat),
                                          chatId: chat.chatId,
                                          onDelete: () async {
                                            final success =
                                                await ChatApi.deleteChat(
                                              userId:
                                                  userProvider.currUserId ?? "",
                                              chatId: chat.chatId,
                                              title: chat.title,
                                            );

                                            if (success) {
                                              print("Deleted successfully");

                                              WebToasts.showToastification(
                                                  "Confirmation",
                                                  "Chat deleted successfully.",
                                                  Icon(
                                                    Icons.check_circle,
                                                    color: Colors.green,
                                                  ),
                                                  context);

                                              setState(() {});
                                            } else {
                                              WebToasts.showToastification(
                                                  "Failed",
                                                  "Something Went wrong.",
                                                  Icon(
                                                    Icons.error_outline,
                                                    color: Colors.red,
                                                  ),
                                                  context);
                                            }

                                            await fetchChats();
                                          },
                                            onEdit: () async {
                                              final controller = TextEditingController(text: chat.title);

                                              bool isLoading = false; // Local dialog loading state

                                              await showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return StatefulBuilder(
                                                    builder: (context, setState) {
                                                      return AlertDialog(
                                                        title: Text(
                                                          "Edit Chat Title",
                                                          style: GoogleFonts.poppins(
                                                              fontWeight: FontWeight.bold, fontSize: 16),
                                                        ),
                                                        contentPadding: const EdgeInsets.all(20),
                                                        content: Container(
                                                          width: 300,
                                                          height: 100,
                                                          child: CustomTextFeild(
                                                            controller: controller,
                                                            hintText: controller.text,
                                                            isNumber: false,
                                                            prefixicon: Icon(Icons.update),
                                                            obsecuretext: false,
                                                          ),
                                                        ),
                                                        actions: [
                                                          CustomButton(
                                                            height: 50,
                                                            width: 200,
                                                            loadWidth: 150,
                                                            isLoading: isLoading,
                                                            textColor: Colors.white,
                                                            bgColor: AppColors.theme['primaryColor'],
                                                            onTap: () async {
                                                              final newTitle = controller.text.trim();

                                                              if (newTitle.isEmpty || newTitle == chat.title) return;

                                                              setState(() => isLoading = true); // Local dialog setState

                                                              final success = await ChatApi.updateChatTitle(
                                                                userId: userProvider.currUserId ?? "",
                                                                chatId: chat.chatId,
                                                                title: newTitle,
                                                              );

                                                              if (success) {
                                                                WebToasts.showToastification(
                                                                  "Confirmation",
                                                                  "Chat Title Updated successfully.",
                                                                  Icon(Icons.check_circle, color: Colors.green),
                                                                  context,
                                                                );
                                                              } else {
                                                                WebToasts.showToastification(
                                                                  "Failed",
                                                                  "Something went wrong.",
                                                                  Icon(Icons.error_outline, color: Colors.red),
                                                                  context,
                                                                );
                                                              }

                                                              Navigator.pop(context); // close dialog
                                                              await fetchChats();
                                                            },
                                                            title: "Update",
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                              );
                                            }
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  child: Center(child: Icon(Icons.person)),
                                  backgroundColor: AppColors
                                      .theme['primaryColor']
                                      .withOpacity(0.2),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userProvider.user?.userName ??
                                          "User Name",
                                      style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      userProvider.user?.email ?? "User Email",
                                      style: GoogleFonts.poppins(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(Icons.logout),
                              onPressed: () async {
                                context.go('/');

                                await userProvider.logout();
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),

                    // Scrollable main content
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: selectedChat != null
                              ? selectedChat!.chatContent.isEmpty
                                  ? Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: mq.height * 0.3),
                                      child: Text(
                                        "Start Conversion",
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25),
                                      ),
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                        ...selectedChat!.chatContent
                                            .toList()
                                            .reversed
                                            .map(
                                              (content) => Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: AppColors.theme[
                                                                'primaryColor']
                                                            .withOpacity(0.1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          CircleAvatar(
                                                            backgroundColor:
                                                                AppColors.theme[
                                                                        'primaryColor']
                                                                    .withOpacity(
                                                                        0.2),
                                                            child: Icon(
                                                              Icons.person,
                                                              size: 20,
                                                              color: AppColors
                                                                      .theme[
                                                                  'tertiaryColor'],
                                                            ),
                                                          ),
                                                          SizedBox(width: 10),
                                                          Expanded(
                                                            child: SelectableText(
                                                              '${content.query}',
                                                              style: GoogleFonts.poppins(
                                                                fontWeight: FontWeight.w600,
                                                                fontSize: 16,
                                                              ),
                                                              // optional
                                                              showCursor: true,
                                                              cursorWidth: 2,
                                                              cursorColor: Colors.blue,
                                                            ),
                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 30,
                                                    ),
                                                    Column(
                                                      children: [
                                                        MarkdownBody(
                                                          data: content.response,
                                                          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                                                            p: GoogleFonts.poppins(fontSize: 14),
                                                            codeblockDecoration: BoxDecoration(color: Colors.transparent),
                                                            code: GoogleFonts.robotoMono(
                                                              fontSize: 13,
                                                              backgroundColor: AppColors.theme['tertiaryColor']!.withOpacity(0.1),
                                                              color: AppColors.theme['primaryColor'],
                                                            ),
                                                            tableHead: GoogleFonts.poppins(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 14,
                                                            ),
                                                            tableBody: GoogleFonts.poppins(),
                                                          ),
                                                          builders: {
                                                            'pre': CodeElementBuilder(context),
                                                          },
                                                          onTapLink: (text, href, title) async {

                                                            final url = Uri.tryParse(href ?? title ?? text ?? "https://hitesh-mori.web.app");

                                                            await launchUrl(url!, mode: LaunchMode.platformDefault);



                                                          },
                                                        ),
                                                        SizedBox(
                                                          height: 30,
                                                        ),
                                                        CopyFeedbackCard(
                                                          textToCopy: "Here goes the text of your response",
                                                        ),
                                                      ],
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
                                  padding: EdgeInsets.symmetric(
                                      vertical: mq.height * 0.3),
                                  child: Text(
                                    "Click + to create new chat",
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  ),
                                ),
                        ),
                      ),
                    ),

                    // Sticky bottom container
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 20),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 50,
                                        width: mq.width * 0.4,
                                        child: Theme(
                                          data: ThemeData(
                                              textSelectionTheme:
                                                  TextSelectionThemeData(
                                                      selectionHandleColor:
                                                          AppColors.theme[
                                                              'primaryColor'],
                                                      cursorColor:
                                                          AppColors.theme[
                                                              'primaryColor'],
                                                      selectionColor: AppColors
                                                          .theme['primaryColor']
                                                          .withOpacity(0.3))),
                                          child: TextFormField(
                                            maxLines: null,
                                            controller: _promptController,
                                            decoration: InputDecoration(
                                              hintText:
                                                  'Enter your query here...',
                                              border: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                            ),
                                            onFieldSubmitted: (_) => handleSendButton(),
                                            textInputAction: TextInputAction.done,
                                          ),
                                        ),
                                      ),
                                      MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: InkWell(
                                          onTap: ()async{

                                          },
                                          child: Container(
                                            height: 40,
                                            width: 120,
                                            child: Center(
                                              child: Text(
                                                "Attach PDF",
                                                style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 14),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  AppColors.theme['primaryColor'],
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  CircleAvatar(
                                    backgroundColor:
                                        AppColors.theme['primaryColor'],
                                    child: isSending
                                        ? Container(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ))
                                        : IconButton(
                                            icon: Icon(Icons.send,
                                                color: Colors.white),
                                            onPressed: handleSendButton,
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (selectedChat != null && _showScrollButton)
                          Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                      onTap: _scrollToBottom,
                                      child: BouncingArrow())),
                            ],
                          )
                      ],
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

  Future<void> handleSendButton()async{

    final prompt = _promptController.text.trim();

    if(prompt=="" || selectedChat == null){
      WebToasts.showToastification("Warning", "Don't leave prompt field empty, fill the given field to send prompt", Icon(Icons.warning,color: Colors.yellow,), context);
      return ;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);


    setState(() {
      isSending = true;
    });

    final success =
    await ChatApi.sendPrompt(
      prompt: prompt,
      userId:
      userProvider.currUserId ??
          "",
      chatId: selectedChat!.chatId,
    );

    setState(() {
      isSending = false;
    });

    if (success) {
      _promptController.clear();

      final contentUrl = Uri.parse(
        'https://chatbot-task-mfcu.onrender.com/api/get_conversation'
            '?chat_id=${selectedChat!.chatId}&user_id=${userProvider.currUserId ?? ""}',
      );

      final response =
      await http.get(contentUrl);
      if (response.statusCode ==
          200) {
        final body = response.body;
        final decoded =
        jsonDecode(body);
        if (decoded is List) {
          final updatedContent = decoded
              .map<ChatContent>((e) =>
              ChatContent
                  .fromJson(e))
              .toList();

          setState(() {
            selectedChat = Chat(
              title:
              selectedChat!.title,
              chatId: selectedChat!
                  .chatId,
              createdAt: selectedChat!
                  .createdAt,
              chatContent:
              updatedContent,
            );

            // Also update in allChats if needed
            final idx = chatProvider
                .allChats
                .indexWhere((c) =>
            c.chatId ==
                selectedChat!
                    .chatId);
            if (idx != -1) {
              chatProvider
                  .allChats[idx] =
              selectedChat!;
            }
          });
        }
      }
    }

  }
}

class CodeElementBuilder extends MarkdownElementBuilder {
  final BuildContext context;

  CodeElementBuilder(this.context);

  @override
  Widget visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final code = element.textContent;

    final md.Element? codeElement = element.children?.firstWhere(
      (child) => child is md.Element && child.tag == 'code',
    ) as md.Element?;

    final language =
        codeElement?.attributes['class']?.replaceFirst('language-', '') ??
            'CODE';

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
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    language[0].toUpperCase() + language.substring(1),
                    style: GoogleFonts.poppins(
                        color: Colors.black, fontWeight: FontWeight.w400),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.copy,
                      color: Colors.black,
                      size: 20,
                    ),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: code));
                      WebToasts.showToastification(
                          "Code Copy", "Copied", Icon(Icons.copy), context);
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

class BouncingArrow extends StatefulWidget {
  const BouncingArrow({super.key});

  @override
  State<BouncingArrow> createState() => _BouncingArrowState();
}

class _BouncingArrowState extends State<BouncingArrow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, 0.2), // Moves down slightly
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _bounceAnimation,
      child: CircleAvatar(
        backgroundColor: Colors.blue.withOpacity(0.1),
        // radius: 25,
        child: const Icon(Icons.arrow_downward_outlined, color: Colors.black),
      ),
    );
  }
}


class CopyFeedbackCard extends StatefulWidget {
  final String textToCopy;

  const CopyFeedbackCard({super.key, required this.textToCopy});

  @override
  State<CopyFeedbackCard> createState() => _CopyFeedbackCardState();
}

class _CopyFeedbackCardState extends State<CopyFeedbackCard> {
  bool copied = false;

  bool isEnter = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.theme['primaryColor']!.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.theme['primaryColor']!.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(2, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "If you found this response helpful, feel free to copy and share it!",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 10),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(

              onTap: () async {
                await Clipboard.setData(ClipboardData(text: widget.textToCopy));
                setState(() {
                  copied = true;
                });
                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted) {
                    setState(() => copied = false);
                  }
                });

                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(
                //     content: const Text("Response copied to clipboard!"),
                //     backgroundColor: AppColors.theme['primaryColor'],
                //     behavior: SnackBarBehavior.floating,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //   ),
                // );

                WebToasts.showToastification("Confirmation", "Response copied to clipboard!", Icon(Icons.copy), context) ;
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: copied
                      ? AppColors.theme['primaryColor']
                      : AppColors.theme['primaryColor']!.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  copied ? "Copied!" : "Copy",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: copied ? Colors.white : AppColors.theme['primaryColor'],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
