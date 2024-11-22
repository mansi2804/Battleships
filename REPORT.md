# MP Report

## Self-Evaluation Checklist

- [X] The app builds without error
- [X] I tested the app in at least one of the following platforms (check all that apply):
  - [X] iOS simulator / MacOS
  - [ ] Android emulator
- [X] Users can register and log in to the server via the app
- [X] Session management works correctly; i.e., the user stays logged in after closing and reopening the app, and token expiration necessitates re-login
- [X] The game list displays required information accurately (for both active and completed games), and can be manually refreshed
- [X] A game can be started correctly (by placing ships, and sending an appropriate request to the server)
- [X] The game board is responsive to changes in screen size
- [X] Games can be started with human and all supported AI opponents
- [X] Gameplay works correctly (including ship placement, attacking, and game completion)

## Summary and Reflection

In this project, I focused on implementing user authentication, real-time gameplay, and game state management for the Battleships game in Flutter. I made key decisions to use http for API requests, shared_preferences for session management, and provider for state management, which streamlined the development process and helped maintain a clean architecture. One notable challenge was ensuring the app remained responsive while waiting for API responses, which I addressed using asynchronous calls. Additionally, I spent time on designing an intuitive user interface that could dynamically update during gameplay. While the core features such as starting games and managing user sessions were functional.

Overall, I enjoyed the process of integrating the Flutter app with a RESTful API and creating a seamless user experience. The most challenging part was managing the game state during real-time updates, especially ensuring that the UI reflected the game progress correctly. I gained valuable experience working with asynchronous data and learned how to handle game logic in a mobile app environment.
