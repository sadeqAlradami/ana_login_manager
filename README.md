# ana_login_manager

## Intro
a widget provided to login by ana platform.support android and ios.


## Features
* Login using ana platform.
* Ready to use login button (Normal & Big)
* Easy to handle auth code.

## Usage

add this line to pubspec.yaml

```yaml

   dependencies:

     ana_login_manager: ^0.0.1


```

import package

```dart

    import 'package:ana_login_manager/ana_login_manager.dart';

```

Initiate SDK by passing client id.

```dart


  AnaLoginManager.init("your_client_id");


```

You can add a login button to your page by adding:

```dart
     Center(
        child:AnaLoginManager.loginButton(
            context,
            scope: "scopes_you_want_to_access",
            onSuccess: (LoginResult? result){
              //handle login result here.
            },
            onError: (PlatformException error,message){
              
            }
        )
     );

```

## More
- [Update Log](CHANGELOG.md)

## LICENSE


```

MIT License

Copyright (c) 2018 Jpeng

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


 ```
