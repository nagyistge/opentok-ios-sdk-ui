OpenTok iOS text chat widget
============================

The OpenTok iOS Text Chat widget provides code for adding a user interface component
for displaying and capturing text chat messages in an Andriod application.

The OpenTok iOS Text Chat widget API is included in the OTKTextChatBundle.bundle file,
available at the
[opentok-ios-sdk-ui Releases](https://github.com/opentok/opentok-ios-sdk-ui/releases) page.

The text-chat-sample directory in this repo used the text chat widget the [OpenTok signaling 
API](https://tokbox.com/developer/guides/signaling/iOS/) to provide text chat in an
OpenTok session.

## Using the text chat widget

The OTKTextChatBundle.bundle includes the classes and protocols that define the OpenTok iOS
text chat widget API.

The OTKTextChatComponent class defines an iOS view control for adding and controling the text chat
user interface:

* It includes a `view` property, which is a UIView that includes user interface elements
  for entering a chat message to send and displaying sent and received messages.

* It includes `delegate` property, which is defined by the OTKTextChatDelegate protocol. The
  includes a `[OTKTextChatDelegate onMessageReadyToSend:]` message is sent when the user clicks
  the Send button (to send a message).

* The `[OTKTextChatComponent addMessage:]` method adds a new received messages to the message list.
  The OTKChatMessage class defines the message.

The following sections provide details.

### Instantiating and configuring the text chat component

Instantiate a OTKTextChatComponent and add it to a container:

```objectivec
_textChat = [[OTKTextChatComponent alloc] init];

CGRect r = self.view.bounds;
r.origin.y += 20;
r.size.height -= 20;
[_textChat.view setFrame:r];
[self.view addSubview:_textChat.view];
```

You can (optionally) set the maximum length of an outgoing text message, by calling the
`TextChatComponent.setMaxTextLength(length)` method (passing in the maximum length for outgoing
messages):

```objectivec
[_textChat setMaxLength:1050];
```
By default the maximum length is 1000 characters. 

You can (optionally) set the sender ID and sender alias and the sender name for messages created
by the client (outgoing messages):

```objectivec
[_textChat setSenderId:@"1234" alias:@"Me"];
```

This method takes two parameters:

* `senderId` (NSString) - The local client's sender ID. The TextChatComponent compares the sender ID
  of a message you add to the message list (see "Displaying received messages") to the sender ID you
  use in the `[TextChatComponent setSenderId:alias]` method. Based on that it determines if the
  message is sent by the local client or by someone else. Note, however, that outgoing messages
  composed when the user clicks the Send button are automatically added to the message list (as
  sent messages).

* `alias` (NSString) - The local client's sender alias, which is the name displayed for
  outgoing messages the user creates when clicking the Send button.

### Receiving events when the user clicks the Send button

To receive events when the user clicks the Send button:

1. Set the the `TextChatComponent.delegate` property:

   ```objectivec
   _textChat.delegate = self;
   ```
   
   Then implement the `[OTKTextChatDelegate onMessageReadyToSend:]` method:
   
   ```objectivec
   - (BOOL)onMessageReadyToSend:(OTKChatMessage *)message {
       NSLog(@"onMessageReadyToSend: (%@)", message.text);
   }
   ```

In your implementation of the `[OTKTextChatDelegate onMessageReadyToSend:]` method, you can
check the `text` property of the `message` parameter to get the text of the new message.
Then you can implement code to process the outgoing message. For example, the sample app
in this repo uses the OpenTok signaling API to broadcast the chat message to clients connected
to an OpenTok session.

Sent messages are automatically displayed in the message list.

### Displaying received messages

When your app receives a text message, use the `[OTKTextChatComponent addMessage:]` method
to add it to the message list user interface.

First create the OTKChatMessage object:

```objectivec
OTKChatMessage *msg = [[OTKChatMessage alloc]init];
msg.senderId = @"5678";
msg.senderAlias = @"Bob";
msg.text = @"Hello.";
[self.textChat addMessage:msg];
```

The `OTKChatMessage` object has these properties:

* `senderId` (NSString) - The sender ID that identifies the sender of the message. If this
  matches the sender ID for the local client, the TextChatComponent object display's the
  message as a sent message in the message list. Otherwise, it displays it as a received
  message. (See the discussion of the `[TextChatComponent setSenderId:alias:]` method in
  "Instantiating and configuring the text chat component".)

* `senderAlias` (NSString) - The name of the sender of the message to display in the message list.

* `text` (NSString) - The text of the message to display in the message list.

In the example, these values are hardcoded. However, in a real app, you would pass
in values for the specific message.

Calling the `[TextChatComponent addMessage:]` method causes the message to be displayed in
the TextChatComponent's message list.

By default, a chat message is assigned the current time on the client. However, you can set it
to another time by calling the `setTimestamp(long time)` method of the ChatMessage object.
