# World Maker
Little project for fun that generates a world map.

Currently generates maps based on seed for:
* Elevation
* Climate
* Rainfall
* Temperature
* Rivers and Lakes
* Basic Civilization Borders
* Civilizations
    * Flags
    * Names

You can also export these maps as png files.

![Screenshot](/Screenshots/screen.PNG?raw=true "Screenshot")

## Instructions

### Using the program
You can download a working version in releases page or on [itch.io](https://substandardshrimp.itch.io/world-maker).

On left panel you can pick size of map generate. Larger maps will take longer to generate but will be more detailed. You can also adjust amount of continental plates in the world. More plates generally mean more mountains. 

After generating you can use the controls in lower left corner to save maps. Just give the map a name and press save. Saved maps are found in: C:/Users/user/AppData/Roaming/Godot/app_userdata/World Maker

Alternatively you can type in your own chosen save location

Also after generating there are buttons to adjust map with additional erosion etc.

Once you are done you can move to generating civilizations with done. This also will add detail to the map

There is a separate flag generator for just generating flags than can be then saved

You can get some instructions by clicking the questionmark

### Code

#### Data
Most data used in game like possible civ names and colors used are stored in JSON files located at [Data](Data/) folder. Adding to names will automatically add them to possible names without needing to change code.