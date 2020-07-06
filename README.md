# LockScreenDismissal

The **DisableAutoLockScreenDismissal.ps1** script can be used to automate the process of turning **off** the option _Automatically dismiss the lock screen if Windows recognizes your face_ option in Windows 10 when using Windows Hello. By default, Windows Hello face recognition will dismiss the lock screen. The script disables that option, thus requiring a user to press a key or mouse button to unlock the screen. The script can be deployed with Intune, Configuration Manager, or Desired State Configuration to multiple users.
