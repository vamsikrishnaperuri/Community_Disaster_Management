import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _ChatbotState();
}


class _ChatbotState extends State<FeedbackPage> {

  ChatUser myself = ChatUser(id: '1',firstName: 'Vamsi');
  ChatUser bot = ChatUser(id: '2',firstName: 'Gemini');

  List<ChatMessage> allMessages = [];
  List<ChatUser> typing=[];

  final oururl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=API_KEY';
  final header={
    'Content-Type': 'application/json'
  };
  getData(ChatMessage m) async {
    typing.add(bot);
    allMessages.insert(0, m);
    setState(() {

    });
    var data = {"contents":[{"parts":[{"text":m.text}]}]};

    final disasterKeywords = [
      "disaster", "calamity", "catastrophe", "emergency", "crisis", "tragedy",
      "incident", "hazard", "risk", "vulnerability", "earthquake", "tsunami",
      "volcano", "hurricane", "typhoon", "cyclone", "tornado", "flood", "drought",
      "wildfire", "blizzard", "heatwave", "landslide", "avalanche",
      "industrial accident", "chemical spill", "nuclear accident", "oil spill",
      "infrastructure failure", "war", "terrorism", "civil unrest", "famine",
      "genocide", "pandemic", "epidemic", "preparedness", "mitigation",
      "response", "recovery", "relief", "rescue", "evacuation", "shelter", "aid",
      "rehabilitation", "aftermath", "casualty", "damage", "destruction",
      "impact", "loss", "needs assessment", "vulnerable populations", "Hello", "Hi", "Hlo"
    ];

    bool isDisasterRelated = false;
    for (final keyword in disasterKeywords) {
      if (m.text.toLowerCase().contains(keyword)) {
        isDisasterRelated = true;
        break; // Exit the loop as soon as a keyword is found
      }
    }

    if (isDisasterRelated) {
      try {
        final response = await http.post(Uri.parse(oururl),
            headers: header, body: jsonEncode(data));

        if (response.statusCode == 200) {
          var result = jsonDecode(response.body);
          String botReply = result['candidates'][0]['content']['parts'][0]['text'];

          ChatMessage m1 = ChatMessage(
              text: botReply,
              user: bot,
              createdAt: DateTime.now());
          allMessages.insert(0, m1);

        } else {
          print("Error occurred: ${response.statusCode}");
          ChatMessage m1 = ChatMessage(
              text: "I'm designed to assist with disaster-related inquiries. Perhaps I can help you with a different question?",
              user: bot,
              createdAt: DateTime.now());
          allMessages.insert(0, m1);
        }
      } catch (e) {
        print("Error occurred: $e");
        ChatMessage m1 = ChatMessage(
            text: "An error occurred. Please try again later.",
            user: bot,
            createdAt: DateTime.now());
        allMessages.insert(0, m1);
      } finally {
        typing.remove(bot);
        setState(() {});
      }
    } else {
      ChatMessage m1 = ChatMessage(
          text: "I'm not sure about that question. Please ask about disasters.",
          user: bot,
          createdAt: DateTime.now());
      allMessages.insert(0, m1);
      typing.remove(bot);
      setState(() {}); // Important to update the UI
    }
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(centerTitle: true,backgroundColor: Colors.white10,title: Text("Chatbot",
        style:GoogleFonts.salsa(textStyle: TextStyle(color: Colors.amber[800],fontSize: 30,)),),),
      backgroundColor: Colors.black,

      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('lib/assets/chatbg.jpg'),fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: DashChat(
            typingUsers: typing,
            currentUser: myself,
            onSend: (ChatMessage m){
              getData(m);
            },
            messages: allMessages,
            inputOptions: const InputOptions(
              alwaysShowSend: true,
              cursorStyle: CursorStyle(color: Colors.black54),
            ),
            messageOptions: MessageOptions(
              currentUserContainerColor: Colors.amber[900],
              avatarBuilder: yourAvatarbuilder,
            ),
          ),
        ),
      ),
    );
  }

  Widget yourAvatarbuilder(ChatUser user,Function? onAvatarTap,Function? onAvatarLongPress) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: Image.asset('lib/assets/chatbot.png',height: 40,width: 40,)),
    );
  }
}
