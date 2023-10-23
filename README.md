# calculator

A Simple Calculator for Flutter Learning Practice.

## Install Flutter
1. [Install Flutter](https://docs.flutter.dev/get-started/install)
2. [Setup VSCode](https://docs.flutter.dev/get-started/editor?tab=vscode)

## Run App (on Windows)
1. Open PowerShell:
   - Press `Win + S`, type `PowerShell`, and select "Windows PowerShell."

2. Navigate to code repo:

For example, when code is located at ``simple-calculator``:
```
cd simple-calculator
```

Install dependencies:
```
flutter pub get
```

3. Launch web app at port ``8080``:
```
flutter run -d chrome --web-port=8080
```
Press `Q` or `Ctrl+C` to terminate app

4. Edit code & Hot reload:
- Add/edit code at VSCode
- Switch to PowerShell terminal then press `r` to apply changes

## TODOs:

1. Implement the actual math operations:
https://github.com/azeravn-developer/simple-calculator/blob/master/lib/calculator.dart#L190

2. Prevent user to enter invalid input:
https://github.com/azeravn-developer/simple-calculator/blob/master/lib/calculator.dart#L182

3. Show history tracking:
https://github.com/azeravn-developer/simple-calculator/blob/master/lib/calculator.dart#L162

4. Save/Load history to persisted disk so that calculation history is maintained between runs:
https://github.com/azeravn-developer/simple-calculator/blob/master/lib/calculator.dart#L169
