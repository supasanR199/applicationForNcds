import 'package:flutter/material.dart';
import 'package:appilcation_for_ncds/function/DisplayTime.dart';

import 'ProfilePhoto.dart';

class ChatBubble extends StatelessWidget {
  ChatBubble(
      {Key key,
      @required this.text,
      @required this.isCurrentUser,
      @required this.time,
      @required this.peerName
      // @required this.peername
      })
      : super(key: key);
  String text;
  final bool isCurrentUser;
  final int time;
  var peerName;
  // final String peername;

  @override
  Widget build(BuildContext context) {
    if (text == null) {
      text = "";
    }
    if (isCurrentUser) {
      return Padding(
        // asymmetric padding
        padding: EdgeInsets.fromLTRB(
          isCurrentUser ? 64.0 : 16.0,
          4,
          isCurrentUser ? 16.0 : 64.0,
          4,
        ),
        child: Align(
          // align the child within the container
          alignment:
              isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Padding(
              //   padding: EdgeInsets.only(right: 8),
              //   child: Text("${peerName["Firstname"]} ${peerName["Lastname"]}"),
              // ),
              DecoratedBox(
                // chat bubble decoration
                decoration: BoxDecoration(
                  color: isCurrentUser ? Colors.blue : Colors.grey[300],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: isCurrentUser ? Colors.white : Colors.black87),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  chatTime(time),
                  style: Theme.of(context).textTheme.overline,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Padding(
        // asymmetric padding
        padding: EdgeInsets.fromLTRB(
          isCurrentUser ? 64.0 : 16.0,
          4,
          isCurrentUser ? 16.0 : 64.0,
          4,
        ),
        child: Align(
          // align the child within the container
          alignment:
              isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  chatProFileShow(context, peerName["Img"]),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${peerName["Firstname"]} ${peerName["Lastname"]}",
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: isCurrentUser ? Colors.white : Colors.black87),
                    ),
                    DecoratedBox(
                      // chat bubble decoration
                      decoration: BoxDecoration(
                        color: isCurrentUser ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          text,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color:
                                  isCurrentUser ? Colors.white : Colors.black87),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        chatTime(time),
                        style: Theme.of(context).textTheme.overline,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
