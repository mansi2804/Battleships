# Battleships - CS 442 MP5 
 
## Overview 
Battleships is a mobile game application where users can log in, register, play games of Battleships, and compete against both human and AI opponents. This project integrates a RESTful API to manage user authentication, game state, and gameplay interaction, all within a Flutter mobile application.
            
## Features     
- **User Authentication**: Users can register, log in, and authenticate with a session token.
- **Game Management**: Users can view ongoing and completed games, create new games, and delete old games.
- **Multiplayer & AI Gameplay**: Users can play against a human opponent or an AI opponent.
- **Game Board Interaction**: Players can place their ships on a 5x5 grid and take turns shooting at the opponent's ships.
- **Responsive UI**: The app is responsive to different screen sizes and adapts accordingly.
- **Session Management**: Tokens are stored locally for authentication and automatically expire after 1 hour.
  
## Installation

### Prerequisites
Make sure you have Flutter installed. If you haven't already installed Flutter, follow the official [Flutter installation guide](https://flutter.dev/docs/get-started/install).

### Clone the Repository 
- **Install Dependencies**; In your project directory, run: flutter pub get
-  **Run the App** : To run the app on an emulator or device, execute: flutter run 

## Usage

### Authentication
- **Login**: Enter your username and password to log in.
- **Registration**: If you don't have an account, you can register from the login screen by entering a username and password.

### Game List
- View ongoing and completed games.
- Refresh the game list to see the most up-to-date games.
- Tap on a game to view and play it.

### Starting a New Game
- Create a new game either with a human opponent or an AI opponent.
- Place 5 ships on the board (one per tile). The game will start after ships are placed.

### Playing a Game
- If it’s your turn, you can tap on the grid to shoot at the opponent’s ships.
- After taking a shot, the game will notify you if you hit or missed the opponent’s ship.
- In human vs. AI games, the AI will take a shot immediately after your turn.
- If the game is over, you’ll be notified of the outcome.

## Technologies Used
- **Flutter**: For building the mobile app.
- **HTTP**: For making API calls to the Battleships REST API.
- **Shared Preferences**: To store session tokens locally for authentication.
- **Provider**: For managing state in the app.

## API Reference
This project communicates with a RESTful Battleships API located at `http://165.227.117.48`. The API handles authentication, game creation, and gameplay logic. For a full list of available API endpoints and their documentation, see the project's `test.http` file.

### API Endpoints
- **POST `/register`**: Register a new user.
- **POST `/login`**: Log in an existing user.
- **GET `/games`**: Get all games (active and completed).
- **POST `/games`**: Start a new game with ships placement.

## How It Works
The app interacts with the Battleships API through HTTP requests to perform various actions such as registering, logging in, viewing games, and playing battleships. All interactions are asynchronous to ensure a smooth user experience.

## Thank You!

Thank you for checking out this project! If you have any questions, suggestions, or improvements, feel free to open an issue or submit a pull request. Your feedback is greatly appreciated!

Happy coding! 😊

