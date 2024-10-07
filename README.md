# bookie_fluttie

A cross-platform flutter application with two tabs, enabling users to bookmark their YouTube videos and take notes 
- Tested / Compatible with Android, IOS and iPad devices (Tested with IOS 18)
- The application uses the Cupertino theme and components
## Features
- TabBar with BottomNavigationBarItem's
- Horizontal Navigation
- Vertical Navigation
- Slidable Items
- Data Persistence using SharedPreferences
- Youtube/v3 API used for fetching video details
- Receiving intents/Shared Content from other apps
- Sharing content from the app to other apps
  
### Video Bookmarks Tab
- Share videos from youtube to the app (Go to the YouTube app, click share and select this app.) 
- View, delete, share, and open videos on YouTube app or browser (Click goes to the native app, LongPress goes to the embedded browser)
- Use Sliding for viewing options

### Notes Tab
- Add new notes with subject and details
- With LongPress set done(check-box) status of the note
- When you click to one note, in the opened detailed view page you can edit, delete and share the note.

## Packages
  
- cupertino_icons: ^1.0.8
- flutter_slidable: ^3.1.1
- share_plus: ^10.0.2
- uuid: ^4.5.1
- zikzak_share_handler: (a fork of https://pub.dev/packages/share_handler)
- http: ^1.2.2
- shared_preferences: ^2.3.2
- url_launcher: ^6.3.0
- device_info: ^2.0.3
(also check out the pubspec.yaml file)

## Screenshots
<img src="https://github.com/user-attachments/assets/54df8def-0829-4637-8084-f69ad7b6da32" width="200" alt="WhatsApp Image 2024-10-06 at 18 11 19">
<img src="https://github.com/user-attachments/assets/9646e747-d6b0-4612-851c-672babaf0658" width="200" alt="WhatsApp Image 2024-10-06 at 18 11 20 (1)">
<img src="https://github.com/user-attachments/assets/08613325-7ce1-4e5a-9b1a-f83855aa52a4" width="200" alt="WhatsApp Image 2024-10-06 at 18 11 21">
<img src="https://github.com/user-attachments/assets/ebefd37f-4c19-4172-9ec6-9f65d69c2560" width="200" alt="WhatsApp Image 2024-10-06 at 18 11 20">

## Notes
To build/debug the application on the IOS platform, you may need to make some configurations for enabling sharing features, check details here: https://pub.dev/packages/share_handler
