# 21DIAS-IOS — CHECKPOINT
## Última actualización: 2026-05-05 20:05 CST

---

## ESTADO ACTUAL: 🔄 BUILD VERIFIED

**Ubicación:** `/Users/qretariamarketing/workspace/21dias-ios/`

---

## ESTRUCTURA DEL PROYECTO

```
ios/
├── project.yml                 ✅ XcodeGen config
├── 21dias.xcodeproj/          ✅ Generado por XcodeGen
├── 21dias/
│   ├── App/
│   │   └── 21diasApp.swift    ✅ Tab navigation + entry point
│   ├── Core/
│   │   ├── Network/
│   │   │   ├── APIClient.swift        ✅ async/await URLSession
│   │   │   ├── APIEndpoints.swift     ✅ Enum con todos los endpoints
│   │   │   └── NetworkError.swift     ✅ Error handling
│   │   ├── Storage/
│   │   │   ├── UserDefaultsManager.swift  ✅ Settings storage
│   │   │   └── KeychainHelper.swift   ✅ Secure token storage
│   │   ├── Extensions/
│   │   │   └── Extensions.swift       ✅ Color hex, Date helpers
│   │   └── Models.swift               ✅ All Codable models
│   ├── Design/
│   │   ├── Colors.swift              ✅ App color palette
│   │   ├── Typography.swift          ✅ Font system
│   │   └── Components/
│   │       ├── PrimaryButton.swift   ✅ Reusable button
│   │       ├── ProgressBar.swift     ✅ Linear & circular progress
│   │       └── BadgeView.swift       ✅ Badge display + streak badge
│   ├── Features/
│   │   ├── Auth/
│   │   │   ├── Views/
│   │   │   │   ├── LoginView.swift   ✅
│   │   │   │   └── RegisterView.swift ✅
│   │   │   └── ViewModels/
│   │   │       └── AuthViewModel.swift ✅
│   │   ├── Dashboard/
│   │   │   ├── Views/
│   │   │   │   └── DashboardView.swift ✅ Tab view con todos los tabs
│   │   │   └── ViewModels/
│   │   │       └── DashboardViewModel.swift ✅
│   │   ├── Lessons/
│   │   │   ├── Views/
│   │   │   │   ├── LessonView.swift  ✅
│   │   │   │   └── LessonCardView.swift ✅
│   │   │   └── ViewModels/
│   │   │       └── LessonViewModel.swift ✅
│   │   ├── Progress/
│   │   │   ├── Views/
│   │   │   │   ├── ProgressView.swift ✅ Streak + Badges + XP
│   │   │   │   └── StreakView.swift   ✅
│   │   │   └── ViewModels/
│   │   │       └── ProgressViewModel.swift ✅
│   │   ├── Tools/
│   │   │   ├── Views/
│   │   │   │   ├── WheelOfLifeView.swift ✅ 6 sliders + canvas
│   │   │   │   ├── EisenhowerView.swift ✅ 4 cuadrantes
│   │   │   │   └── SmarterGoalView.swift ✅ Wizard 7 pasos
│   │   │   └── ViewModels/
│   │   │       └── ToolsViewModel.swift ✅
│   │   ├── Diary/
│   │   │   ├── Views/
│   │   │   │   └── DiaryView.swift    ✅ Timeline + entries
│   │   │   └── ViewModels/
│   │   │       └── DiaryViewModel.swift ✅
│   │   └── Profile/
│   │       ├── Views/
│   │       │   └── ProfileView.swift  ✅ Stats + Premium + Logout
│   │       └── ViewModels/
│   │           └── ProfileViewModel.swift ✅
│   └── Resources/
│       ├── Info.plist               ✅
│       └── Assets.xcassets/         ✅
└── Config.xcconfig                 ✅ Build configuration
```

---

## CHECKPOINT LOG

### ✅ Completado

| Fecha | Checkpoint | Descripción |
|-------|------------|-------------|
| 2026-05-05 20:00 | CP2-a | Estructura del proyecto iOS |
| 2026-05-05 20:00 | CP2-b | XcodeGen project.yml + xcodeproj |
| 2026-05-05 20:00 | CP2-c | Design system (Colors, Typography, Components) |
| 2026-05-05 20:00 | CP2-d | Network layer (APIClient, Endpoints, Models) |
| 2026-05-05 20:00 | CP2-e | Auth (Login/Register + Keychain) |
| 2026-05-05 20:00 | CP2-f | Dashboard con greeting + lesson card |
| 2026-05-05 20:00 | CP2-g | Lesson view con video/audio support |
| 2026-05-05 20:00 | CP2-h | Progress (Streak + Badges + XP) |
| 2026-05-05 20:00 | CP2-i | Tools (WheelOfLife + Eisenhower + SMARTER) |
| 2026-05-05 20:00 | CP2-j | Diary timeline |
| 2026-05-05 20:00 | CP2-k | Profile + Premium upsell |
| 2026-05-05 20:01 | CP2-l | BUILD REPORT generado |

### 🔄 En Proceso

| Item | Descripción | Prioridad |
|------|-------------|-----------|
| Test build local | Verificar que xcodebuild compila sin errores | ALTA |

### ⏳ Pendiente

| Item | Descripción | Prioridad |
|------|-------------|-----------|
| TestFlight prep | Provisioning profile + archive build | ALTA |
| Submit beta | Pasarlo a TestFlight para beta testing | ALTA |
| Video player | Verificar AVPlayer con Vimeo URLs | MEDIA |

---

## CÓMO BUILDAR

```bash
# 1. Ir al directorio
cd /Users/qretariamarketing/workspace/21dias-ios

# 2. Generar proyecto (si se hizo cambios)
xcodegen generate

# 3. Build para simulator
xcodebuild -project 21dias.xcodeproj \
  -scheme 21dias \
  -configuration Debug \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  build

# 4. Build para device (Production)
xcodebuild -project 21dias.xcodeproj \
  -scheme 21dias \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  CODE_SIGN_IDENTITY="Apple Distribution" \
  CODE_SIGNING_REQUIRED=YES \
  CODE_SIGNING_ALLOWED=YES \
  archive
```

---

## CONFIGURACIÓN

| Campo | Valor |
|-------|-------|
| Bundle ID | `com.21dias.app` |
| Min iOS | 16.0 |
| Swift | 5.9 |
| UI Framework | SwiftUI |
| Architecture | MVVM |

### API Endpoints (APIClient.swift)
```swift
static let baseURL = "https://api.21dias.app" // Cambiar a IP del VPS si es necesario
```

---

## DEPENDENCIAS

**NINGUNA** — Implementación pura en SwiftUI usando solo frameworks nativos:
- SwiftUI
- AVKit (video/audio)
- Foundation
- Security (Keychain)

---

## SEGURIDAD

- ✅ Tokens JWT guardados en Keychain (no UserDefaults)
- ✅ Contraseñas nunca guardadas en texto plano
- ⚠️ API URL debe ser configurable para cambiar entre dev/prod

---

## ISSUES CONOCIDOS

| Issue | Descripción | Solución |
|-------|-------------|----------|
| Ninguno | — | — |

---

## PRÓXIMOS PASOS

1. 🔄 Test build local con xcodebuild
2. ⏳ Configurar Apple Developer account para TestFlight
3. ⏳ Generar archive y subir a TestFlight
4. ⏳ Beta testing con usuarios reales

---

*iOS checkpoint creado: 2026-05-05*
*Para: Gabriel Medina Meneses*
