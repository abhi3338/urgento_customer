import 'package:firestore_chat/models/chat_entity.dart';
import 'package:fuodz/requests/chat.request.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ChatService {
  //
  static sendChatMessage(String message, ChatEntity chatEntity) async {
    //notify the involved party
    final otherPeerKey = chatEntity.peers.keys.firstWhere(
      (peerKey) => chatEntity.mainUser.id != peerKey,
    );
    //
    final otherPeer = chatEntity.peers[otherPeerKey];
    final apiResponse = await ChatRequest().sendNotification(
      title: "New Message from".tr() + " ${chatEntity.mainUser.name}",
      body: message,
      topic: otherPeer.id,
      path: chatEntity.path,
      user: chatEntity.mainUser,
      otherUser: otherPeer,
    );

    print("Result ==> ${apiResponse.body}");
  }
}
