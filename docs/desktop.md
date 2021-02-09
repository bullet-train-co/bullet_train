# Distributing as a Desktop Application

Bullet Train is fine-tuned to run well within an Electron container and the easiest way to generate code-signed, Electron-powered application bundles for Windows, macOS, and Linux is the commercial tool provided by our friends at [ToDesktop](https://www.todesktop.com).

## Developing Desktop Experiences Locally

To test your application's desktop experience during development, you can simply [download and install Bullet Train's own prebuilt desktop application](https://dl.todesktop.com/210204wqi0hp3xe). This example application (built by ToDesktop) points to `http://localhost:3000`, so after spinning up `rails s`, you can launch this application to tweak and tune your desktop experience in real time.

This same bundle is available for the following platforms:

 - [Windows](https://dl.todesktop.com/210204wqi0hp3xe/windows/nsis/x64)
 - [macOS](https://dl.todesktop.com/210204wqi0hp3xe/mac/dmg/x64)
 - [Linux](https://dl.todesktop.com/210204wqi0hp3xe/linux/appImage/x64)
