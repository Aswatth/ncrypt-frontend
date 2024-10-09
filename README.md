# Ncrypt

This is a desktop application built using flutter for managing passwords and secrets. All sensitive data are encrypted
using AES-encryption using Go and are stored as encrypted key-value pair.

Features:

- Ability to import and export data.
    - All stored data can be exported as a single encrypted file with _.ncrypt_ extension.
    - To import a _.ncrypt_ file user would be required to enter the master-password which was used when exporting.
      _**Caution**: Importing will completely overwrite existing
      data._
![img_5.png](readme_images/img_5.png)
- Automatic backup.
    - If enabled in the setting, on logout and application close, an automatic backup will be performed to set location
      using given file_name appended with date-time stamp.
![img_1.png](readme_images/img_1.png)
- Ability to lock data.
    - Locked data would require user to re-enter master password to view,edit and delete data.
![img_3.png](readme_images/img_3.png)
![img_4.png](readme_images/img_4.png)
- Supports multiple accounts.
    - Multiple accounts from a single website or app are grouped under single name.
![img_2.png](readme_images/img_2.png)
- Password generator.
    - Users can set their preferences for generating password which will be used for generating password for accounts or
      in general help you with randomized password based on your preference.
![img.png](readme_images/img.png)

App icon: <a href="https://www.flaticon.com/free-icons/security" title="security icons">Security icons created by

Freepik - Flaticon</a>

Thanks to:
- <a href="https://github.com/skandansn"> Skandan </a>
- <a href="https://github.com/shishirkallapur"> Shishir </a>
for their valuable inputs.
