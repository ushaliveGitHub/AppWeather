# WeatherForecast

## Overview

The App provides  detailed hourly and weekly weather forecast for current user location. The App can also provide forecast for any city/town in the world by allowing using to search and add '+' a new weather location.

## Prerequisites

1. Xcode 8.0 (iOS 10.0) or later
2. This App  uses darkSky and Google APIs. For the app to work you need to get API Keys from darkSky,Google Places API Web Service and GoogleGeoCoding.

3. **_To _get SECRET KEY_** from darkSky, follow  instructions below.

    - Go to https://darksky.net/dev/login and sign up by creating a new account.
    - Once you get the secret key , save or write down the Key. Please do not share your key with anyone.
    
4. **To _get a KEY_** from googleGeoCoding , follow  instructions below.

    - Go to https://developers.google.com/maps/documentation/geocoding/get-api-key and click on **_get a KEY_**.
    - If you don't have google account you may have to create one.
    - Google will prompt you to register your project name. For example you can call it "WeatherApp".
    - Google will provide you with a "KEY" . save or write down the Key. Please do not share your key with anyone.
    
5.   **To _get a KEY_** from Google Places API Web Service , follow  instructions below.
   
    - Go to https://developers.google.com/places/web-service/get-api-key and click on **_get a KEY_**.
    - If you don't have google account you may have to create one.
    - Google will prompt you to register your project name. You can choose "WeatherApp" from the list (you already created).
    - Google will provide you with a "KEY" . save or write down the Key. Please do not share your key with anyone.   
    
    
## To Run this app in Xcode    

1. Clone or download this repository.
2. Create a new property list file called **_keys.plist_**. Follow step by step instructions below to create the file. Its very important to get all the api keys and create the property list dictionary with exactly the same key names as listed.

        - Open WeatherForecast project in xcode. 
        - Access XCode menu File->New->File.
        - Select file type as 'property list' from the template list.
        - Name the file  **_keys.plist_** 
        - Open keys.plist and add '+' a new key **_DarkSkyApi_** from the Root of the dictionary.
        - set the key type to String.
        - fill the value with the Secret Key from darkSky.net
        - Add a 2nd key **_GoogleApi_** of type String and fill the value with api key from **_Google Places API Web Service_**
        - Add a 3rd key **_GoogleApiByID_** of type String and fill the value with api key from **_googleGeoCoding_**
        - Now the project is ready to be compiled and run.
    

## Versioning

WeatherForecast 1.0

## Authors

Usha Natarajan

## License

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

## Acknowledgments

* Inspiration  - The weather channel app
* Weather Api Source - darkSky
* Julien Colin - for Date Time Formatting
* Ashley Mills - for network reachability
* Shani Rivers - for how to hide your clientID Key

