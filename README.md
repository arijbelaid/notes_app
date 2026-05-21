# Notes App — React Native + Flutter

Application de prise de notes complète développée en parallèle dans les deux frameworks, basé sur le tutoriel de Wahid Hamdi.

## Structure du projet

```
/
├── NotesApp/         → Application React Native (Expo)
└── notes_app/        → Application Flutter
```

---

## NotesApp (React Native)

### Prérequis
- Node.js 18+
- npm ou yarn
- Expo CLI : `npm install -g expo-cli`
- Application Expo Go sur votre téléphone (optionnel)

### Installation

```bash
cd NotesApp
npm install
cp .env.example .env
# Remplir les variables dans .env
expo start
```

### Configuration Appwrite
Remplir le fichier `.env` :
```
APPWRITE_ENDPOINT=https://cloud.appwrite.io/v1
APPWRITE_PROJECT_ID=votre-project-id
APPWRITE_DATABASE_ID=votre-database-id
APPWRITE_COLLECTION_ID=votre-collection-id
```

### Structure
```
NotesApp/
├── App.js
├── src/
│   ├── config/         → Configuration Appwrite
│   ├── contexts/       → AuthContext (gestion état auth)
│   ├── navigation/     → AuthNavigator
│   ├── screens/        → AuthScreen, HomeScreen, NotesScreen
│   ├── components/     → NoteItem, AddNoteModal, EditNoteModal
│   └── services/       → auth.service.js, note.service.js
└── .env.example
```

---

## notes_app (Flutter)

### Prérequis
- Flutter SDK 3.0+
- Dart SDK 3.0+
- Android Studio ou VS Code avec extensions Flutter

### Installation

```bash
cd notes_app
cp .env.example .env
# Remplir les variables dans .env
flutter pub get
flutter run
```

### Configuration Appwrite
Remplir le fichier `.env` :
```
APPWRITE_ENDPOINT=https://cloud.appwrite.io/v1
APPWRITE_PROJECT_ID=votre-project-id
APPWRITE_DATABASE_ID=votre-database-id
APPWRITE_COLLECTION_ID=votre-collection-id
```

### Structure
```
notes_app/
├── lib/
│   ├── main.dart
│   ├── config/         → AppwriteConfig
│   ├── navigation/     → AuthNavigator
│   ├── providers/      → AuthProvider
│   ├── screens/        → AuthScreen, HomeScreen, NotesScreen
│   ├── services/       → AuthService, NoteService
│   └── widgets/        → NoteItem, AddNoteModal, EditNoteModal
└── .env.example
```

---

## Configuration Appwrite (commune aux deux apps)

1. Créer un compte sur [cloud.appwrite.io](https://cloud.appwrite.io)
2. Créer un projet "NotesApp"
3. Créer une base de données "NotesDB"
4. Créer une collection "notes" avec ces attributs :
   - `title` (string, required)
   - `content` (string, required)
   - `user_id` (string, required)
   - `createdAt` (datetime, required)
   - `updatedAt` (datetime, required)
5. Créer des index sur `user_id` et `createdAt`
6. Configurer les permissions : lecture/écriture pour utilisateurs authentifiés

---

## Fonctionnalités implémentées

- ✅ Inscription / Connexion / Déconnexion
- ✅ Création de notes
- ✅ Lecture et affichage des notes
- ✅ Modification des notes
- ✅ Suppression des notes (avec confirmation)
- ✅ Filtrage par utilisateur connecté
- ✅ État vide avec message d'invitation
- ✅ Indicateurs de chargement
- ✅ Gestion des erreurs

---

## Build & Publication

### React Native (EAS)
```bash
npm install -g eas-cli
eas login
eas build:configure
eas build -p android --profile production
eas submit -p android --latest
```

### Flutter
```bash
# Android
flutter build appbundle --release

# iOS
flutter build ios --release
```
