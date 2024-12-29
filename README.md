# WordWizard
#### Video Demo:  https://youtu.be/EfX6UVZSQtU
#### Description:

So to start off this essay, I will explain what exactly what this project is.

The title WordWizard is more of a playful title mainly aimed at children especially since a wizard is a fantasy creature that has magic for powers.
So the app has the start screen, an information screen and even a settings screen.
The point of this app is supposed to be a very extensible educational app that is very user friendly.
A lot of educational apps I personally used in the past felt pretty rushed and put the education over the user.
My app is about finding a balance between both, allowing the user to actually have a dark mode and users can customize their settings to there liking.
Also I try to be as beginner friendly as possible in my Information screen with helpful paragraphs on how to get started and even linked my wordlist I used along with the source code of my app.

Now that I laid out the basics about my app, I will go over crucial design decisions.
I will say I had a lot of fun creating the UI in SwiftUI, that wasn’t a problem I especially based my Information View design on a past android project I made called Task Tracker. 
Source of that project is on my GitHub, the other views like Home Screen with the start button and Settings were relatively easy since I am using Apple’s built in design language.
The GameView part was also simple UI design but the logic was hardest part in that view.
The hardest part in the project honestly was the wordlist, I know sounds crazy but this makes or breaks the user experience.
I originally started off by picking words.txt in the wordlist repo I linked, which ended up making the loading times longer and it was harder to parse since the “wordlist” also has numbers in it for some reason.
It had case sensitive words on it so I ended up making a case sensitive setting too, but once I put that wordlist to test and had my family members test it.
They told me they didn’t like it so I had to re-strategize.

So I then picked the words_alpha.txt list in their repo which has more realistically used words, no weird symbols like ampersands but there was no capitalized letters. 
So I completely scratched the case sensitivity setting out.
Also I found a library Apple allows developers to use called UITextChecker() which takes in a string and returns a boolean if the string is a word or not.
Then I used this to my advantage and wrapped it in a function called isCorrect() and I ran that on every single word in the list on a users first load.
Then I checked and out of 370,000 words it only counted 125,000 were legitimate according to that function.
Now my completed strategy is to load the 370,000 words on first load then whatever words were marked correct I then create another list that is filtered and load that list instead on every load.
With that I have increased load times exponentially from before which before took 10-15 seconds each time to start the app now after the first load it takes under 2 seconds.
With all the decisions I made along the way, now it is time to go over my files for this project.

# Components directory:

This is a directory which is for separate UI components used for views which the files in their are InfoType.swift and WebView.swift.

## InfoType.swift:

It is a simple component that is used in my InfoView which is for displaying the InfoItem’s information which is the title and description.

## WebView.swift:

It says what is for which takes a url and pops up a web view of that page.

# Data directory:

This is a directory which is for handling cross view logic, this contains words.txt which is the words_alpha list, Mode.swift, ViewModel.swift and InfoItem.swift.

## Mode.swift:

Is a enum that is used in the ViewModel to represent the modes in types so .random, .easy, .medium and .hard.

## InfoItem.swift:

A simple struct that is used as a type so it is easy to represent in InfoItem which contains the properties title and description which are strings.

## ViewModel.swift:

This is a huge object that handles a lot of my logic.
It has my settings which are being saved and loaded.
It handles loading state, filtering/sorting words, generating type arrays so easy, medium and hard words.
It checks the current gameWords if they are unique and saves the filtered words inside the app data.

# Views:

This isn’t stored in a directory since they all have the name View at the end and I find myself changing these more often.
This is essentially the user seeable screens that the user will run into during the app lifetime.
I will go over these from top to bottom in terms of app start.

## WordWizardApp.swift:

This is the starting point of the app which initializes the ViewModel object into my app, apply’s the loaded theme globally and runs the ViewModel start up function so it can get all the data setup.

## ContentView.swift:

This is basically my home screen, it displays the LoadingView if ViewModel says it is still loading else it then displays TabBar view if a game is not active.
If a game is active then it will display the GameView.
It also clears the game words on view and regenerates it to ensure the user always has new words especially if they changed the settings.

## LoadingView:

This is pretty self explanatory it is just a view that says loading with a rotating circle.

## TabBarView:

This is a view that manages my other views based on the user selected an icon on the task bar.
It also has the start button for the home screen if a user wants to start the game which toggles my isGameActive state so ContentView can re-render the GameView.
So this view also contains InfoView and SettingsView and it disables itself if the game is active.

## GameView:

This is the view that essentially contains the UI for the game along with handling the logic for if a user got the word correct.
It heavily uses my ViewModel data to get up to date information on the words and the total questions.

## InfoView:

This view contains drop-down headers that when clicked will pop up a description on how to do something or what exactly is a feature in the app.
Along with links that open a popup WebView which contains additional information like my GitHub repo and the wordlist repo I used.

## SettingsView:

This is a important view which determines the gameplay and the look of the UI.
This also heavily uses ViewModel to update the state of the app and determine which settings will be automatically loaded by default in future app lifetimes.

In conclusion, this app was a very good learning experience and I had so much fun.
Apps that cater to user experience are usually the best apps and I hope my app can serve as a good example of this.
