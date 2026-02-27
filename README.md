# Labar Grains Monorepo

A Flutter monorepo for the Labar Grains Farmers Application using Melos for workspace management.

## Project Structure

```
labar/
├── apps/
│   ├── labar_app/          # Mobile app (Android & iOS)
│   └── labar_admin/        # Web admin dashboard
├── packages/
│   └── ui_library/         # Shared UI components
├── assets/                 # Shared assets
├── melos.yaml             # Monorepo configuration
├── justfile               # Command runner recipes
└── pubspec.yaml           # Root workspace
```

## Prerequisites

- Flutter SDK (>=3.24.0)
- Dart SDK (>=3.5.0)
- [Melos](https://melos.invertase.dev/) - `dart pub global activate melos`
- [Just](https://github.com/casey/just) (optional but recommended) - Command runner

## Quick Start

### Using Just (Recommended)

```bash
# List all available commands
just

# Full setup (bootstrap, build, generate assets & l10n)
just setup

# Run mobile app
just run-app

# Run web admin
just run-admin
```

### Using Melos Directly

```bash
# Bootstrap workspace
melos bootstrap

# Run build_runner
melos run build:runner

# Format code
melos run format

# Analyze code
melos run analyze
```

## Common Commands

### Workspace Management

```bash
just bootstrap          # Bootstrap all packages
just clean             # Clean all packages
just get               # Run pub get on all packages
just rebuild           # Clean, bootstrap, and build
just fresh             # Complete fresh build from scratch
```

### Code Generation

```bash
just build             # Run build_runner on all packages
just build-app         # Run build_runner on labar_app only
just build-admin       # Run build_runner on labar_admin only
just watch-app         # Watch mode for labar_app
just l10n              # Generate localization files
```

### Assets

```bash
just icons             # Generate launcher icons
just splash            # Generate splash screen
just assets            # Generate both icons and splash
```

### Running Apps

```bash
just run-app           # Run mobile app
just run-app device=<device-id>  # Run on specific device
just run-admin         # Run web admin on Chrome
just release-app       # Run mobile app in release mode
```

### Building

```bash
just build-apk         # Build Android APK
just build-appbundle   # Build Android App Bundle
just build-ios         # Build iOS app
just build-web         # Build web app
```

### Code Quality

```bash
just format            # Format all Dart code
just analyze           # Analyze all packages
just fix               # Fix Dart code issues
just test              # Run all tests
just test-app          # Run labar_app tests only
```

### Utilities

```bash
just devices           # List Flutter devices
just doctor            # Run flutter doctor
just upgrade           # Upgrade all dependencies
```

## Applications

### Labar Grains App (Mobile)

**Package Name**: `com.geeksaxis.labar`  
**Platforms**: Android, iOS  
**Languages**: English, Hausa

```bash
cd apps/labar_app
flutter run
```

### Labar Grains Admin (Web)

**Package Name**: `com.geeksaxis.labar`  
**Platform**: Web

```bash
cd apps/labar_admin
flutter run -d chrome
```

## Localization

The mobile app supports English and Hausa languages using ARB files.

- English: `apps/labar_app/lib/l10n/app_en.arb`
- Hausa: `apps/labar_app/lib/l10n/app_ha.arb`

Generate localization files:
```bash
just l10n
```

Usage in code:
```dart
import 'package:labar_app/core/extensions/localization_extension.dart';

Text(context.l10n.login)
```

## Architecture

Both apps follow Clean Architecture with:
- **State Management**: flutter_bloc + hydrated_bloc
- **Dependency Injection**: get_it + injectable
- **Routing**: auto_route
- **Backend**: supabase_flutter

## Development Workflow

1. **Initial Setup**
   ```bash
   just setup
   ```

2. **Make Changes**
   - Edit code in `apps/` or `packages/`
   - Add translations to ARB files if needed

3. **Generate Code**
   ```bash
   just build
   just l10n  # if translations changed
   ```

4. **Test**
   ```bash
   just run-app
   just test
   ```

5. **Format & Analyze**
   ```bash
   just format
   just analyze
   ```

## Troubleshooting

### Clean Build
If you encounter issues, try a fresh build:
```bash
just fresh
```

### Dependency Issues
```bash
just clean
just bootstrap
```

### Code Generation Issues
```bash
just build
```

## Resources

- [Melos Documentation](https://melos.invertase.dev/)
- [Just Documentation](https://github.com/casey/just)
- [Flutter Documentation](https://flutter.dev/docs)
- [Moon Design System](https://flutter.moon.io)
