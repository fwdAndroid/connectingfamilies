import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectingfamilies/uitls/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatMessages extends StatefulWidget {
  final userId;
  final userName;
  final userPhoto;
  final friendName;
  final friendId;
  final friendPhoto;
  final chatUUid;
  const ChatMessages(
      {super.key,
      required this.friendId,
      required this.friendName,
      required this.friendPhoto,
      required this.userId,
      required this.chatUUid,
      required this.userName,
      required this.userPhoto});

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  String groupChatId = "";
  ScrollController scrollController = ScrollController();
  TextEditingController messageController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    if (FirebaseAuth.instance.currentUser!.uid.hashCode <=
        widget.friendId.hashCode) {
      groupChatId =
          "${FirebaseAuth.instance.currentUser!.uid}-${widget.friendId}";
    } else {
      groupChatId =
          "${widget.friendId}-${FirebaseAuth.instance.currentUser!.uid}";
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.friendPhoto),
                  maxRadius: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.friendName,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Online",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("messages")
                  .doc(groupChatId)
                  .collection(groupChatId)
                  .orderBy("timestamp", descending: false)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!.docs == 0
                      ? Center(child: Text("Vacía "))
                      : Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 14),
                            reverse: false,
                            controller: scrollController,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var ds = snapshot.data!.docs[index];
                              return ds.get("type") == 0
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: Align(
                                        alignment: (ds.get("senderId") ==
                                                FirebaseAuth
                                                    .instance.currentUser!.uid
                                            ? Alignment.topLeft
                                            : Alignment.topRight),
                                        child: Column(
                                          crossAxisAlignment:
                                              (ds.get("senderId") ==
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid
                                                  ? CrossAxisAlignment.start
                                                  : CrossAxisAlignment.end),
                                          //     crossAxisAlignment:
                                          // messages[index].messageType ==
                                          //         "receiver"
                                          //     ? CrossAxisAlignment.start
                                          //     : CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                color: (ds.get("senderId") ==
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid
                                                    ? Color(0xfff0f2f9)
                                                    : Color(0xff668681)),
                                              ),
                                              padding: EdgeInsets.all(12),
                                              child: Text(
                                                ds.get("content"),
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: (ds.get(
                                                                "senderId") ==
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid
                                                        ? black
                                                        : colorWhite)),
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              DateFormat.jm().format(DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      int.parse(
                                                          ds.get("time")))),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container();
                            },
                          ),
                        );
                } else if (snapshot.hasError) {
                  return Center(child: Icon(Icons.error_outline));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 14),
              height: 60,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 8, left: 8),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xffF1F1F1),
                              ),
                              borderRadius: BorderRadius.circular(30)),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xffF1F1F1),
                              ),
                              borderRadius: BorderRadius.circular(30)),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xffF1F1F1),
                              ),
                              borderRadius: BorderRadius.circular(30)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xffF1F1F1),
                              ),
                              borderRadius: BorderRadius.circular(30)),
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Color(0xffF1F1F1),
                          hintText: "Type Something...",
                          hintStyle: TextStyle(color: Colors.black54),
                        )),
                  ),
                  SizedBox(width: 10),
                  FloatingActionButton(
                    onPressed: () {
                      sendMessage(messageController.text.trim(), 0);
                    },
                    child: Icon(
                      Icons.keyboard_arrow_right,
                      color: textColor,
                      size: 30,
                    ),
                    backgroundColor: chatbtb,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      messageController.clear();

      var documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            "senderId": FirebaseAuth.instance.currentUser!.uid,
            "receiverId": widget.friendId,
            "time": DateTime.now().millisecondsSinceEpoch.toString(),
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );
      }).then((value) {
        if (type == 0) {
          // Assuming type 0 is for 'note'
          updateLastMessageByProvider(content);
        }
      });

      scrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      // Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  void updateLastMessageByProvider(String messageContent) async {
    final chatDocRef =
        FirebaseFirestore.instance.collection('chats').doc(widget.chatUUid);

    // Check if the document exists before attempting to update it
    final chatDocSnapshot = await chatDocRef.get();
    if (chatDocSnapshot.exists) {
      // Document exists, update the lastMessageByProvider field
      await chatDocRef.update({
        'lastMessageByCustomer': messageContent,
      }).catchError((error) {
        print("Failed to update last message by provider: $error");
      });
    } else {
      print("Document does not exist, cannot update last message by provider");
    }
  }
}
