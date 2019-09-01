# bitrise
This plugin adds plus functionality for Bitrise users.

Installation
=======
* Copy the _bitrise.plugin.zsh_ file or clone the content of this repository to **$ZSH_CUSTOM/plugins/bitrise**  on your computer (usually ~/.oh-my-zsh/custom/plugins/bitrise)
* In your _.zshrc_ file add **bitrise** to the **plugins=()** section

Configuration
=======
For using these functions you have to define your Bitrise token and app id. Place 2 files in your filesystem:
* _.bitrise_token_
    * **If you are using only one Bitrise token** 
        * you can put the _.bitrise_token_ file into your root directory: _~/.bitrise_token_ and this token will be used globally for your projects
        * or you can use the BITRISE_TOKEN environmental variable to store the token 
    * **If you are using multiple Bitrise tokens for your projects**
        * you can have a _.bitrise_token_ file on project level
        * this option overrides the global token from the _~/.bitrise_token_ file and the BITRISE_TOKEN environmental variable
* _.bitrise_appid_
    * **If you only have one Bitrise app** 
        * you can put the _.bitrise_appid_ file into your root directory: _~/.bitrise_appid_ and every time you issue a command this app id will be used
        * or you can use the BITRISE_APPID environmental variable to store the app id
    * **If you have multiple Bitrise apps**
        * you can have a _.bitrise_appid_ file on project level
        * this option overrides the global appid from the _~/.bitrise_appid_ file and the BITRISE_APPID environmental variable


Main Functions
=======
## bitrise_open
* **bitrise_open**
    * Opens up the Bitrise dashboard
* **bitrise open** _page_
    * Opens up the given Bitrise page for your app
    * Options for page parameter are:
        * settings
        * workflows
        * builds
        * add-ons
        * team 
        * code
    * If an unknown page is defined the Dashboard opens up
## bitrise_start
* **bitrise_start**
    * Starts the default workflow for the given app based on the trigger map.
* **bitrise_start** _workflow_id_
    * Starts a new build for the given app with the specified workflow
    * If starting the build succeeds, you get a build url for your build. The last part of this url is your build's slug what can be used to abort the build.
## bitrise_abort
* **bitrise_abort** _build_slug_
    * Cancels the given build or returns an error

Helper functions 
=======
These functions are not using the configuration files, so you can build your own commands or aliases with them:
* **_read_bitrise_appid**
    * Prints the currently used appid
* **_read_bitrise_token**
    * Prints the currently used token
* **_bitrise_url** _app_id_ _page_
    * Prints an url with the specified page for the given app
* **_bitrise_build_start** _token_ _app_id_ _workflow_id_
    * Starts a build for the specified app with the given token
    * _workflow_id_ is optional, if specified the build will be started with the specified workflow
    * If starting the build succeeds, you get a build url for your build. The last part of this url is your build's slug what can be used to abort the build.
* **_bitrise_build_abort** _token_ _app_id_ _build_slug_
    * Aborts the specified app's build with _build_slug_ slug.