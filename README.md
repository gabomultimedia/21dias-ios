# 21 Días — App iOS

App nativa iOS para **21 Días de Impulso Sostenible** — desarrollada en SwiftUI.

## Requisitos
- iOS 16.0+
- Xcode 15.0+
- Swift 5.9

## Stack
- **UI Framework:** SwiftUI
- **Architecture:** MVVM
- **Networking:** URLSession + async/await
- **Local Storage:** UserDefaults + Keychain

## Features
- Login/Registro con JWT
- Dashboard con streak y progreso
- Vista de lecciones diarias
- Gamificación completa (XP, badges, rachas)
- Herramientas interactivas (Rueda de la Vida, Eisenhower, SMARTER)
- Diario personal
- Sistema de referidos
- Rankings / Leaderboard
- Community
- Premium upsell

## Setup

```bash
# Generar proyecto Xcode
xcodegen generate

# Abrir en Xcode
open 21dias.xcodeproj
```

## Configuración

En `Config.xcconfig`:
```
API_BASE_URL=https://api.21dias.app
```

## API Endpoints

El API base está en: `https://api.21dias.app`

Ver documentación completa en: https://github.com/gabomultimedia/21dias-backend

## Building

```bash
# Simulator
xcodebuild -project 21dias.xcodeproj -scheme 21dias -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 15' build

# Device (Release)
xcodebuild -project 21dias.xcodeproj -scheme 21dias -configuration Release -destination 'generic/platform=iOS' archive
```

## Assets

El equipo de diseño debe entregar:
- App icons (1024x1024)
- Badge icons (256x256, 16 badges)
- Streak flame animations (Lottie)
- Transformation cards para sharing

Ver `ASSETS_LIST.md` en el proyecto principal para lista completa.

## Repositorios Relacionados

- [21dias-backend](https://github.com/gabomultimedia/21dias-backend) — Backend API
- [21dias-android](https://github.com/gabomultimedia/21dias-android) — App Android

## Licencia
Proprietario — Gabriel Medina Meneses / QRETARIA Marketing
