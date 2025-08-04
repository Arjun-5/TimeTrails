# TimeTrails

# 🕰️ Time Trails

![Time Trails App Icon](./assets/icon/TTLogo.png)

**Explore history like never before — immersive AR experiences of nearby landmarks, from your couch or on the go!**

---

## 🚀 Inspiration

Walking through a city can be ordinary, but it holds untold stories waiting to be discovered. Time Trails was inspired by the desire to blend technology and culture — bringing history alive by connecting users with nearby landmarks through augmented reality. The goal is to make history accessible, engaging, and immersive, encouraging exploration and learning in everyday life.

---

## 🎯 What It Does

Time Trails identifies nearby historical sites, landmarks, and tourist spots based on your location. It lets you:

- View interactive 3D models of landmarks in AR, sourced from Firebase.  
- Explore historical places virtually or plan real-life visits.  
- Add personal notes pinned to map locations for memories or important info.  
- See walking distances and routes directly on the map to nearby points of interest.  
- Unlock geo-tagged collectibles and badges by visiting specific spots.

---

## ⚙️ How I Built It

The app is developed using **Flutter** for a smooth, cross-platform experience. Key components include:

- Google Maps SDK, Street View, Geocoding, and Directions APIs for location data and map integration.  
- Firebase Firestore and Firebase Functions to securely manage 3D model data and user notes, and to keep API keys safe.  
- ARKit and ARCore bridged through Flutter plugins to display 3D models in augmented reality.  
- A modular architecture following MVC principles, with robust state management for seamless user experience.

The 3D models are sourced from the [Leipzig Open Data 3D Stadtmodell](https://opendata.leipzig.de/dataset/3d-stadtmodell) and linked to places by unique place IDs.

---

## ⚠️ Challenges

- **Precise Location Triggering:** Handling GPS inaccuracies and ensuring AR content appears only at the right spots.  
- **AR Integration:** Bridging native AR frameworks with Flutter required extensive testing and optimization.  
- **Map Styling:** Balancing historic aesthetic with clarity and usability on the map interface.  
- **Data Management:** Efficiently syncing models, user notes, and collectibles without degrading performance.  
- **API Limitations:** Managing query limits and restricting walking mode due to Google API quotas.

---

## 🎉 Accomplishments

- Merged location services and AR to create a truly immersive historical exploration app.  
- Developed a secure, scalable backend with Firebase Functions to protect sensitive API keys.  
- Created a clean, user-friendly map interface with note-taking and collectible features.  
- Demonstrated a strong foundation for future expansion in tourism, education, and cultural heritage.

---

## 📚 What I Learned

- The power and potential of combining location-based data with AR to create engaging user experiences.  
- Practical insights into Flutter’s integration with native features and third-party APIs.  
- The importance of modular code architecture for maintainability and scalability.  
- Techniques to handle GPS variability and enhance app responsiveness in real-world conditions.

---

## 📱 Download

**Android APK:**  
[Download Time Trails APK](https://www.dl.dropboxusercontent.com/scl/fi/1t173ycfspuc7yv4z2bz4/Time-Trails.apk?rlkey=0gclbb0wwkve74mwzbowu61ut&e=1&st=vqelaojh&dl=0)

---

## 🛠️ Tech Stack

- Flutter  
- Google Maps SDK & Direction, Routes API  
- Google Geocoding & Directions API  
- Firebase Firestore, Storage & Firebase Functions  
- ARCore (Android) via Flutter plugins  
- 3D building models from Leipzig Open Data

---

## 🧩 Future Plans

- Add textured, higher-quality 3D models.  
- Support multiple travel modes (driving, cycling, etc.).  
- Implement Then & Now AR image overlays.  
- Expand geo-collectibles with AR mini-games and educational content.  
- Enhance offline map and AR capabilities.  
- Add social sharing of trails and badges.

---