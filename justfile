# Labar Monorepo - Just Commands
# Install just: https://github.com/casey/just

# List all available commands
default:
    @just --list

# Bootstrap the entire workspace
bootstrap:
    melos bootstrap

# Clean all packages
clean:
    melos clean

# Run pub get on all packages
get:
    melos run get

# Format all Dart code
format:
    melos run format

# Analyze all packages
analyze:
    melos run analyze

# Run build_runner for all packages
build:
    melos run build:runner

# Run build_runner for labar_app only
build-app:
    cd apps/labar_app && dart run build_runner build --delete-conflicting-outputs

# Run build_runner for labar_admin only
build-admin:
    cd apps/labar_admin && dart run build_runner build --delete-conflicting-outputs

# Generate launcher icons for labar_app
icons:
    cd apps/labar_app && dart run flutter_launcher_icons

# Generate splash screen for labar_app
splash:
    cd apps/labar_app && dart run flutter_native_splash:create

# Generate both icons and splash for labar_app
assets: icons splash

# Generate localization files for labar_app
l10n:
    cd apps/labar_app && flutter gen-l10n

# Run labar_app on connected device
run-app device="":
    cd apps/labar_app && flutter run --dart-define-from-file=.env {{ if device != "" { "-d " + device } else { "" } }}

# Run labar_admin on Chrome
run-admin:
    cd apps/labar_admin && flutter run "-d" chrome --dart-define-from-file=.env

# Run tests for all packages
test:
    melos run test

# Run tests for labar_app only
test-app:
    cd apps/labar_app && flutter test

# Run tests for labar_admin only
test-admin:
    cd apps/labar_admin && flutter test

# Full setup: bootstrap, build, generate assets and l10n
setup: bootstrap build assets l10n
    @echo "✅ Full setup complete!"

# Quick rebuild: clean, bootstrap, and build
rebuild: clean bootstrap build
    @echo "✅ Rebuild complete!"

# Fix Dart code issues
fix:
    melos run fix

# Upgrade all dependencies
upgrade:
    melos run upgrade

# List all Flutter devices
devices:
    flutter devices

# Check Flutter doctor
doctor:
    flutter doctor "-v"

# Run labar_app in release mode
release-app device="":
    cd apps/labar_app && flutter run --release --dart-define-from-file=.env {{ if device != "" { "-d " + device } else { "" } }}

# Build APK for Android
build-apk:
    cd apps/labar_app && flutter build apk --release --dart-define-from-file=.env

# Build App Bundle for Android
build-appbundle:
    cd apps/labar_app && flutter build appbundle --release --dart-define-from-file=.env

# Build iOS app
build-ios:
    cd apps/labar_app && flutter build ios --release --dart-define-from-file=.env

# Build web app for admin
build-web:
    cd apps/labar_admin && flutter build web --release --dart-define-from-file=.env

# Shorebird commands
shorebird-init:
    cd apps/labar_app && export PATH="$HOME/.shorebird/bin:$PATH" && shorebird init

shorebird-release-android:
    cd apps/labar_app && export PATH="$HOME/.shorebird/bin:$PATH" && shorebird release android -- --dart-define-from-file=.env

shorebird-patch-android:
    cd apps/labar_app && export PATH="$HOME/.shorebird/bin:$PATH" && shorebird patch android -- --dart-define-from-file=.env

# Watch mode for build_runner on labar_app
watch-app:
    cd apps/labar_app && dart run build_runner watch --delete-conflicting-outputs

# Watch mode for build_runner on labar_admin
watch-admin:
    cd apps/labar_admin && dart run build_runner watch --delete-conflicting-outputs

# Run supabase functions locally
supabase-serve:
    cd apps/labar_backend && supabase functions serve

# Deploy supabase functions
supabase-deploy:
    cd apps/labar_backend && supabase functions deploy

# Clean and rebuild everything from scratch
fresh: clean bootstrap build assets l10n
    @echo "✅ Fresh build complete!"

# Build admin web app (with envs) and deploy to Vercel production
deploy-admin:
    @echo "🏗️  Building admin web app..."
    cd apps/labar_admin && flutter build web --release --dart-define-from-file=.env
    @echo "📦  Copying to Vercel output..."
    mkdir -p .vercel/output/static
    rsync -a --delete apps/labar_admin/build/web/ .vercel/output/static/
    @echo "🚀  Deploying to Vercel production..."
    vercel deploy --prebuilt --yes
    @echo "✅  Admin dashboard deployed!"

# Build admin web app (with envs) and deploy to Vercel preview
deploy-admin-preview:
    @echo "🏗️  Building admin web app..."
    cd apps/labar_admin && flutter build web --release --dart-define-from-file=.env
    @echo "📦  Copying to Vercel output..."
    mkdir -p .vercel/output/static
    rsync -a --delete apps/labar_admin/build/web/ .vercel/output/static/
    @echo "🔍  Deploying to Vercel preview..."
    vercel deploy --prebuilt
    @echo "✅  Preview deployment done!"
