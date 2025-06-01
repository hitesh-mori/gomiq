import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gomiq/helper_functions/web_toasts.dart';
import 'package:gomiq/main.dart';
import 'package:gomiq/models/chat.dart';
import 'package:gomiq/models/chat_content.dart';
import 'package:gomiq/widgets/chat_item.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gomiq/theme/colors.dart';
import 'package:intl/intl.dart';
import 'package:markdown/markdown.dart' as md;

class ChatScreen extends StatefulWidget {
  static const route = "/chat";
  static const fullRoute = "/chat";

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  Chat? selectedChat;

  final List<Chat> allChats = [

    Chat(
      title: "Flutter Setup",
      createdAt: DateTime.now(),
      chatContent: [
        ChatContent(
            toId: '1',
            fromId: '2',
            question: "How to install Flutter?",
            answer:
            '''
        
  ## 🚀 Flutter Setup Guide

  Follow these steps to install **Flutter** on your machine:

  ## 🛠️ Requirements

  - Windows/macOS/Linux
  - Git
  - IDE (VS Code / Android Studio)


  ## 📦 Installation Steps

  1. Download the Flutter SDK from [flutter.dev](https://flutter.dev)
  2. Extract the zip file and add Flutter to your PATH.
  3. Run: '''

        ),
        ChatContent(
          toId: '2',
          fromId: '1',
          question: "How to check Flutter version?",
          answer: "Run:\n```bash\nflutter --version\n```",
        ),
      ],
    ),
    Chat(
      title: "Dart Basics",
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      chatContent: [
        ChatContent(
          toId: '1',
          fromId: '2',
          question: "What is a Dart variable?",
          answer:
          "A container for storing data.\n\n| Type | Example |\n|------|---------|\n| int  | 5       |\n| String | 'hello' |",
        ),
      ],
    ),
    Chat(
      title: "Async Await",
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      chatContent: [
        ChatContent(
            toId: '2',
            fromId: '1',
            question: "How does async work in Dart?",
            answer: '''
        # Inde interea

## Rettulit principium

Lorem markdownum forem: furtim: movi pastor, cumque nec; terrae perque nobis.
Summo oret census *sistere* vidit Latiis novis Cinyphiumque niveis tutam,
latitavimus. Bella et est accipiunt moenia altis et iam prius languere agricolam
omnesque, in.

> Inter nostrae Tellus opem inops? [Funeris](http://herbis-ne.org/pectore) summo
> Lycaon convivia tutaeque. Quid tum tota orbem morti gradumque laetos, aliis
> pontus ademit? Quisquam aequora, cetera tauri cvrrvs, neve perosa, data vir!
> Secreta illud, more arida Gallicus!

## Retia mota foedantem fuit

Precanda hinc fiet voracior; tempora constitit trabes. Sed simul relinquant ea
**quis herboso**. Manu haec linquit Siculis, an caelum misso in **per arbore**,
luctantiaque matres novaque [subitam](http://temptant.io/interdum-meritis) ille
dixit, venienti.

> Atris vellere lumine molle nequiquam tu gentis, nox **enim stridore**, numerum
> gradientis Olympum ignarus. Agros gurges *pugnae* inque, est est quam albus,
> per caespite vulnere moly, ab *meruit*, externo. Ipsis hastam se ipse Stygius
> ipsa solus sub motae: mansit Threicio adstitit. Unius aetherioque daedalus, et
> a Aesacon [inmensa](http://esset-gramen.io/), pictarumque.

## Possit flamine tecta ut rura harenas

Est ordine Stygius non, alta sibi, laetitiae antiquum formaque *illic nare*
capacem sorores undas nascentia mihique? Fibra *quae pars esse* ministri
rotatis, coimus ego, dixit pro huius. Totoque squamis cavernis est, cum *non
superatae* proxima, reportat, in terris, miserum multaque?

- Stheneleius quod arduus
- Commune latrator dissimilisque postquam vel tremor nomen
- Visaque ferventi longisque ire
- Vidi sequente Lichan
- Et in fecit femineae
- Litoris viros rex sunt tum leti quot

## Longo re serva

In victorem solvit, acta prole **attulerat Threicio** ager quisquis morata
virtus avem citius aether. Quae tangunt si videres soror.

Iuvet illam, multarum manu laniare itum cerva at animosus Tethyn insonuit.
Iasonis laudis mallem nam! Est et enixa opacas mortale, sanguine, ut oravere
debes.

Gravem grave, et lacrimas Parosque! Se nomen, ne **animam valvis** credi
pendentia abscidit bracchia levabas omnibus, talia missos signa. Addit aut regna
interdum sic esset, mortalem est irae moriens pleni **traxit**, desierant. Quam
superantque *medio latet* locum antris, priora?

            
          '''
        ),
      ],
    ),
    Chat(
      title: "FutureBuilder",
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      chatContent: [
        ChatContent(
          toId: '1',
          fromId: '2',
          question: "What is FutureBuilder?",
          answer:
          "A widget that builds itself based on a Future.\n\n```dart\nFutureBuilder(\n  future: fetchData(),\n  builder: (context, snapshot) {\n    if (snapshot.connectionState == ConnectionState.waiting) {\n      return CircularProgressIndicator();\n    } else {\n      return Text('Done');\n    }\n  },\n)\n```",
        ),
      ],
    ),
    Chat(
      title: "Old Topic",
      createdAt: DateTime(2024, 4, 24),
      chatContent: [
        ChatContent(
          toId: '1',
          fromId: '2',
          question: "What is FutureBuilder?",
          answer:
          "A widget that builds itself based on a Future.\n\nCheck [docs](https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html).",
        ),
      ],
    ),
    Chat(
      title: "Async Await",
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      chatContent: [
        ChatContent(
          toId: '2',
          fromId: '1',
          question: "How does async work in Dart?",
          answer:
          "It allows non-blocking operations using `async` and `await`.\n\n```dart\nFuture<void> fetchData() async {\n  await Future.delayed(Duration(seconds: 2));\n}\n```",
        ),
      ],
    ),
    Chat(
      title: "FutureBuilder",
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      chatContent: [
        ChatContent(
          toId: '1',
          fromId: '2',
          question: "What is FutureBuilder?",
          answer:
          "A widget that builds itself based on a Future.\n\n```dart\nFutureBuilder(\n  future: fetchData(),\n  builder: (context, snapshot) {\n    if (snapshot.connectionState == ConnectionState.waiting) {\n      return CircularProgressIndicator();\n    } else {\n      return Text('Done');\n    }\n  },\n)\n```",
        ),
      ],
    ),
    Chat(
      title: "Old Topic",
      createdAt: DateTime(2024, 4, 24),
      chatContent: [
        ChatContent(
          toId: '1',
          fromId: '2',
          question: "What is FutureBuilder?",
          answer:
          "A widget that builds itself based on a Future.\n\nCheck [docs](https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html).",
        ),
      ],
    ),
    Chat(
      title: "Async Await",
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      chatContent: [
        ChatContent(
          toId: '2',
          fromId: '1',
          question: "How does async work in Dart?",
          answer:
          "It allows non-blocking operations using `async` and `await`.\n\n```dart\nFuture<void> fetchData() async {\n  await Future.delayed(Duration(seconds: 2));\n}\n```",
        ),
      ],
    ),
    Chat(
      title: "FutureBuilder",
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      chatContent: [
        ChatContent(
          toId: '1',
          fromId: '2',
          question: "What is FutureBuilder?",
          answer:
          "A widget that builds itself based on a Future.\n\n```dart\nFutureBuilder(\n  future: fetchData(),\n  builder: (context, snapshot) {\n    if (snapshot.connectionState == ConnectionState.waiting) {\n      return CircularProgressIndicator();\n    } else {\n      return Text('Done');\n    }\n  },\n)\n```",
        ),
      ],
    ),
    Chat(
      title: "Old Topic",
      createdAt: DateTime(2024, 4, 24),
      chatContent: [
        ChatContent(
          toId: '1',
          fromId: '2',
          question: "What is FutureBuilder?",
          answer:
          "A widget that builds itself based on a Future.\n\nCheck [docs](https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html).",
        ),
      ],
    ),

  ];

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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        "assets/logo/logo.png",
                        height: 50,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Divider(
                      color:
                      AppColors.theme['tertiaryColor']!.withOpacity(0.1),
                    ),
                    Expanded(
                      child: ListView(
                        children: groupedChats.entries.map((entry) {
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
                              ...entry.value.map(
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
                            ? Column(
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
                            ...selectedChat!.chatContent.map(
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
                                          Text(
                                            '${content.question}',
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                            softWrap: true,
                                            overflow: TextOverflow.visible,
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: 30,),

                                    MarkdownBody(
                                      data: content.answer,
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
                            : Center(
                          child: Text(
                            "Select a chat from the drawer",
                            style: GoogleFonts.poppins(fontSize: 20),
                          ),
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
                                child: Center(child: Icon(Icons.send,color: Colors.white,)),
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
          // Top Bar with Title and Copy Button
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