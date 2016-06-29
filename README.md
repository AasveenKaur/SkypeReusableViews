# Skype Reusable Views


##TestReusableView

This is a sample application that is using the reusable Video chat screen. The reusable Video chat screen package consist of three parts, namely: 
 1. SFBVidoeChatViewController.xib - General Video screen UI.
 2. SFBVidoeChatViewController.swift - Video screen controller class.
 3. Utils.swift - Class with common helper methods.
 
These are grouped under **ReusableUI - Video Chat** folder in **TestReusableView** project.

### Getting Started - TestReusableView Sample

 1. **Add embedded binary**: In XCode, select the project node and open the project properties pane. Add SkypeForBusiness.framework as an "Embedded Binary" (not a "Linked Framework"). 

  > Note: The SDK comes with a binary for use on physical devices (recommended) and a binary for running the iOS simulator (limited because audio and video function won't work correctly).  The binaries have the same name but are in separate folders. To run your app on a **device**, navigate to the location where you downloaded the App SDK and select the _SkypeForBusiness.framework_ file in the _AppSDKiOS_ folder. To run your app in a **simulator**,  selec the _SkypeForBusiness.framework_ file in the _AppSDKiOSSimulator_ folder.
  
 2. Add **SfBConversationHelper.h/SfBConversationHelper.m** to the project from Helper folder in SKypeForBusiness SDK. Uncomment the following line in TestReusableView-Bridging-Header.h file.

   ```swift
   //Add SfBConversationHelper classes for Audio/Video Chat
    #import "SfBConversationHelper.h"
    ```
  
 3. In **MainViewController.swift class**, modify _startVideoChat_ function to initialize **SFBVidoeChatViewController** class with your _MeetingUrl_ and _MeetingDisplayName_.
 
 4. Clean and run the sample. 
 
 > Note: Use **MainViewController.swift class** function - _presentSFBVidoeChatViewControllerModally_ and _dismissSFBVidoeChatViewController_ to present the video chat screen modally.
 
##Using reusable video chat screen 
 
 Integrating the reusable video chat screen in your application is simple. With the following steps, You can start video chat with minimum lines of code.
 
 ###Prerequisite
 
 Make sure you read and follow all the steps listed in [Getting started](https://github.com/OfficeDev/skype-docs/blob/master/Skype/AppSDK/GettingStarted.md) file for iOS.
 
  - **Create Swift Bridging - Header file**: Create the bridging-header file and add the following import statement.

    ```swift
    //Add SfBConversationHelper classes for Audio/Video Chat
    #import "SfBConversationHelper.h"
    ```
    >Note: The following steps assume that you have added the _ConversationHelper_ class
    to your source to let you complete the scenario with a minimum of code. 

### Getting Started
1.  Add the following files to your project.
  - SFBVidoeChatViewController.xib - General Video screen UI.
  - SFBVidoeChatViewController.swift - Video screen controller class.
  - Utils.swift - Class with common helper methods.

2. In your class, initialize **SFBVidoeChatViewController** class with your _MeetingUrl_ and _MeetingDisplayName_.
 ```swift
 let vc:SFBVidoeChatViewController = SFBVidoeChatViewController(meetingUrl: "meetingUrl", meetingDisplayName: "meetingDisplayName")
        ```
3. set up SFBVidoeChatViewController _endVideoChatWithCompletionHandler_ to run any code after leaving video chat.
```swift
 vc.endVideoChatWithCompletionHandler {
    //Pop Video Chat Screen from navigation controller
    self.popSFBVidoeChatViewController()

    /**NOTE - Use this to Dismiss Video Chat Screen if presented modally
    self.dismissSFBVidoeChatViewController()
    **/
        }
  ```
4. Show Video Chat screen either modally or push to navigation stack.
```swift
    // Push Video Chat Screen to navigation controller stack
    pushSFBVidoeChatViewController(vc)
    
    /** NOTE - Use this to present Video Chat Screen modally
    self.presentSFBVidoeChatViewControllerModally(vc)
    **/

  ```
  
