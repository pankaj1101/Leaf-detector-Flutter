# 🌿 Medileaf – Medicinal Leaf Detection App

**Medileaf** is a Flutter-based mobile application that detects medicinal plant leaves from images and displays the **name of the leaf** using **on-device machine learning**.
The app leverages **TensorFlow Lite** for fast and offline image classification.

---

## 🚀 Features

* 📸 Pick leaf images from the gallery or camera
* 🧠 On-device ML inference using TensorFlow Lite
* 🌱 Detect and display medicinal leaf names
* ⚡ Fast, offline, and lightweight
* 📱 Clean and simple Flutter UI

---

## 🛠️ Tech Stack

* **Flutter** – Cross-platform UI framework
* **TensorFlow Lite** – ML model inference
* **Dart** – Programming language

---

## 📦 Packages Used

```yaml
dependencies:
  image_picker: ^1.2.1
  tflite_flutter: ^0.12.1
  image: ^4.6.0
```

### 🔹 Package Purpose

* **image_picker** – Select images from camera or gallery
* **tflite_flutter** – Run TensorFlow Lite model in Flutter
* **image** – Image preprocessing (resize, normalize, etc.)

---

## 📸 How It Works

1. User selects a leaf image using the camera or gallery
2. Image is preprocessed (resize & normalize)
3. TensorFlow Lite model analyzes the image
4. App displays the detected **leaf name**

---

## 🧠 ML Model

* TensorFlow Lite (`.tflite`) model
* Runs **entirely offline**
* Optimized for mobile performance

> ⚠️ Make sure the model file is placed inside the `assets` directory and registered in `pubspec.yaml`.

---

## 📂 Project Structure (Simplified)

```
lib/
 ├── leaf_detector_screen.dart
 ├── lib/main.dart
assets/
 ├── /model
 |      ├── /leaf_model.tflite
 |      └── /labels.txt
```

---

## ▶️ Getting Started

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/pankaj1101/Leaf-detector-Flutter.git
cd Leaf-detector-Flutter
```

### 2️⃣ Install Dependencies

```bash
flutter pub get
```

### 3️⃣ Run the App

```bash
flutter run
```

---

## 🔐 Permissions

Make sure to add required permissions:

### Android (`AndroidManifest.xml`)

```xml
<uses-permission android:name="android.permission.CAMERA"/>
```

### iOS (`Info.plist`)

```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required to detect leaf images</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Photo access is required to pick leaf images</string>
```

---

## 🌍 Future Enhancements

* 🔍 Confidence score for predictions
* 📊 Leaf details & medicinal benefits
* 🌐 Multi-language support
* ☁️ Cloud model updates

---

## 🤝 Contributing

Contributions are welcome!
Feel free to fork the repo and submit a pull request.

---

## 📄 License

This project is licensed under the **MIT License**.

---

## 👨‍💻 Author

**Pankaj Ram**
Flutter Developer | Mobile App Enthusiast

