OpenTok iOS Text Chat UI sample
===============================
A basic sample app showing the use of the OpenTok iOS Text Chat UI sample

## Configuring the app

1. Open the TextChatSample.xcodeproj.

2. Download the [OpenTok iOS SDK](https://tokbox.com/developer/sdks/ios/).

3. Locate the OpenTok.framework file in the OpenTok iOS SDK, and add it to
   the list of Frameworks in the TextChatSample project.

4. In the ViewController.m file, set the following
   properties to a test OpenTok session ID, token, and API key:

   ```
   // Replace with your OpenTok API key
   static NSString* const kApiKey = @"";
   // Replace with your generated session ID
   static NSString* const kSessionId = @"";
   // Replace with your generated token
   static NSString* const kToken = @"";
  ```

   You can get your a test OpenTok session ID, a test token, and the API key at
   the [OpenTok dashboard](https://dashboard.tokbox.com/).

5. Debug the project on a supported device.

   For a list of supported devices, see the "System requirements"
   on [this page](https://tokbox.com/developer/sdks/ios/)

The app connects to an OpenTok session and uses the OpenTok signaling API to
send and receive text messages to the session. Tap the text field at the bottom
of the app, enter a text message, and then tap the Send button.

## Understanding the code

Upon startup, the ViewController class connects to the OpenTok session. Upon
connecting to the session, it instantiates a OTKTextChatComponent instance and
adds its view as a subview of the main view:

```
// When the connection has completed okay we can create the chat component 
_textChat = [[OTKTextChatComponent alloc] init];
_textChat.delegate = self;

CGRect r = self.view.bounds;
r.origin.y += 20;
r.size.height -= 20;
[_textChat.view setFrame:r];
[self.view addSubview:_textChat.view];
```

The OTKTextChatComponent class is defined in the OpenTok iOS Text Chat UI API.
It defines an API and a user interface for text chat messaging.

The code sets the main ViewController object as the delegate for
OTKTextChatComponent events.
Note that the ViewController class implements the OTKTextChatDelegate
delegate methods.

The ViewController class implements the
`[OTKTextChatDelegate onMessageReadyToSend:]` method. This method is called when
the user clicks the Send button:

```
- (BOOL)onMessageReadyToSend:(OTKChatMessage *)message {
    message.sender = _session.connection.data;
    OTError *error = nil;
    [_session signalWithType:@"type" string:message.text connection:nil error:&error];
    if (error) {
        return NO;
    } else {
        return YES;
    }
}
```

The app uses the `[OTSession signalWithType: string: connection: error:]` method
(defined by the OpenTok iOS SDK) to send a message to the session. The signal
`type` indicates that it is a text chat message. The signal's `data` is set to the text of the message to send.

When the session is received, the implementation of the
`[OTSessionDelegate receivedSignalType:fromConnection:withString:]` method 
(defined by the OpenTok iOS SDK) is called:

```
- (void)session:(OTSession*)session receivedSignalType:(NSString*)type
 fromConnection:(OTConnection*)connection
     withString:(NSString*)string {
    if (![connection.connectionId isEqualToString:_session.connection.connectionId]) {
        OTKChatMessage *msg = [[OTKChatMessage alloc]init];
        msg.sender = connection.data;
        msg.text = string;
        [self.textChat sendMessage:msg];
    }
}
```

The code creates a new OTKChatMessage instance. The OTKChatMessage class is
defined by the OpenTok iOS Text Chat UI API. It defines a message to be
displayed by an OTKTextChatComponent instance. An OTKChatMessage instance has
a sender (a string that identifies the sender of the message) and the text
of the message.

The code checks to see if the signal was sent by another client
(`![connection.connectionId isEqualToString:_session.connection.connectionId]`).
If it was, it sets the `sender` property of the OTKChatMessage object to the
connection data you specify when creating the user's token (see
[Token creation](https://tokbox.com/developer/guides/create-token/) ).
The `text` property of the OTKChatMessage object is set to the chat message
text.

The code calls the `[OTKTextChatComponent sendMessage:]` method 
which causes the message to be displayed in the message list of the OTKTextChatComponent view:
