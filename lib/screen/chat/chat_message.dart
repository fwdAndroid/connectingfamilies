import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:just_audio/just_audio.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String friendId;
  final String friendName;
  final String friendImage;

  ChatScreen({
    required this.chatId,
    required this.friendId,
    required this.friendName,
    required this.friendImage,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  bool isRecording = false;
  String? audioPath;
  File? selectedImage;
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    await _recorder!.openRecorder();
    await _player!.openPlayer();
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  Future<void> sendMessage(String? text, String? imageUrl, String? audioUrl,
      [String? audioDuration]) async {
    if ((text == null || text.trim().isEmpty) &&
        imageUrl == null &&
        audioUrl == null) return;

    int timestamp = DateTime.now().millisecondsSinceEpoch;

    DocumentReference chatRef =
        firestore.collection('chats').doc(widget.chatId);
    CollectionReference messagesRef = chatRef.collection('messages');

    await messagesRef.add({
      "senderId": currentUserId,
      "receiverId": widget.friendId,
      "message": text ?? "",
      "imageUrl": imageUrl,
      "audioUrl": audioUrl,
      "timestamp": timestamp,
      "seen": false,
      "audioDuration": audioDuration,
    });

    await chatRef.update({
      "lastMessage": text?.isNotEmpty == true
          ? text
          : (imageUrl != null ? "📷 Image" : "🎵 Audio"),
      "lastMessageTime": timestamp,
      "lastMessageSeen": false
    });

    messageController.clear();
    setState(() => selectedImage = null);
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() => selectedImage = File(pickedFile.path));
    _showImagePreview();
  }

  void _showImagePreview() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Image Preview"),
        content: selectedImage != null
            ? Image.file(selectedImage!)
            : SizedBox.shrink(),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                selectedImage = null;
              });
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _uploadImage(selectedImage!);
            },
            child: Text("Send"),
          ),
        ],
      ),
    );
  }

  Future<void> _uploadImage(File imageFile) async {
    setState(() => isUploading = true);
    String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    TaskSnapshot uploadTask =
        await storage.ref('chat_images/$fileName').putFile(imageFile);
    String imageUrl = await uploadTask.ref.getDownloadURL();
    setState(() => isUploading = false);
    sendMessage(null, imageUrl, null);
  }

  Future<void> startRecording() async {
    Directory tempDir = await getTemporaryDirectory();
    String path =
        '${tempDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac';
    setState(() => isRecording = true);
    await _recorder!.startRecorder(toFile: path);
    audioPath = path;
  }

  Future<void> stopRecording() async {
    String? path = await _recorder!.stopRecorder();
    setState(() => isRecording = false);
    if (path == null) return;

    File audioFile = File(path);
    setState(() {
      audioPath = path; // Store recorded file path for preview
    });

    // Show preview popup
    _showAudioPreview(audioFile);
  }

  void _showAudioPreview(File audioFile) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Audio Preview"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.play_arrow, size: 40),
              onPressed: () async {
                await _player!.startPlayer(fromURI: audioFile.path);
              },
            ),
            SizedBox(height: 10),
            Text("Listen to your recording before sending."),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                audioPath = null; // Reset if canceled
              });
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _uploadAndSendAudio(audioFile);
            },
            child: Text("Send"),
          ),
        ],
      ),
    );
  }

  Future<void> _uploadAndSendAudio(File audioFile) async {
    String fileName = '${DateTime.now().millisecondsSinceEpoch}.aac';
    TaskSnapshot uploadTask =
        await storage.ref('chat_audio/$fileName').putFile(audioFile);
    String audioUrl = await uploadTask.ref.getDownloadURL();

    // Get audio duration
    final audioPlayer = AudioPlayer();
    await audioPlayer.setFilePath(audioFile.path);
    Duration? duration = audioPlayer.duration;
    await audioPlayer.dispose();

    String formattedDuration = _formatDuration(duration ?? Duration.zero);

    sendMessage(null, null, audioUrl, formattedDuration);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.friendName)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection('chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());

                var messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var msg = messages[index];
                    bool isMine = msg['senderId'] == currentUserId;
                    String? text = msg['message'];
                    String? imageUrl = msg['imageUrl'];
                    String? audioUrl = msg['audioUrl'];

                    return Align(
                      alignment:
                          isMine ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: isMine ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (text != null && text.isNotEmpty) Text(text),
                            if (imageUrl != null)
                              Image.network(imageUrl,
                                  width: 200, height: 200, fit: BoxFit.cover),
                            if (audioUrl != null)
                              SizedBox(
                                width: 200,
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.play_arrow),
                                      onPressed: () => _player!
                                          .startPlayer(fromURI: audioUrl),
                                    ),
                                    _buildAudioWave(),
                                  ],
                                ),
                              ),
                            Text(msg['audioDuration'] ??
                                '0:00'), // Display the duration
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          if (isUploading) LinearProgressIndicator(),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                IconButton(icon: Icon(Icons.image), onPressed: pickImage),
                IconButton(
                    icon: Icon(isRecording ? Icons.stop : Icons.mic,
                        color: Colors.red),
                    onPressed: isRecording ? stopRecording : startRecording),
                Expanded(
                    child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                            hintText: "Type a message...",
                            border: OutlineInputBorder()))),
                IconButton(
                    icon: Icon(Icons.send, color: Colors.blue),
                    onPressed: () =>
                        sendMessage(messageController.text, null, null)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioWave() {
    return WaveWidget(
      config: CustomConfig(
        gradients: [
          [Colors.blue, Colors.blueAccent],
          [Colors.lightBlueAccent, Colors.blueGrey],
        ],
        durations: [3500, 1940],
        heightPercentages: [0.5, 0.3],
      ),
      size: Size(150, 50),
    );
  }
}
