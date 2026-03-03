# Labar Grains - Developer Documentation

Welcome to the Labar Grains Developer Documentation. This guide is designed to help new developers understand the project's architecture, tools, and workflows, ensuring a smooth onboarding process.

## 1. Project Overview

Labar Grains is a monorepo built to manage farming operations, inventory, and field agent applications.
The project is built using **Flutter** and is structured as a monorepo using **Melos**.

### Applications in the Workspace
- **`labar_app` (Mobile App):** Built for Android and iOS. Used primarily by field agents or farmers to submit applications via forms (KYC, Biometrics, Farm Details), track application status, and view allocated resources and warehouses.
- **`labar_admin` (Web Admin Dashboard):** A Flutter Web application used by administrators and office agents. Features include reviewing applications, managing users, inventory, warehouses, and generating PDF waybills.

### Shared Packages
- **`ui_library`:** Contains shared UI components, themes, and assets to ensure consistency across both apps.

## 2. Tech Stack & Architecture

Both applications strictly adhere to **Clean Architecture** principles to separate concerns and ensure maintainability.

- **Frontend Framework:** Flutter (>=3.24.0)
- **Language:** Dart (>=3.5.0)
- **State Management:** `flutter_bloc` and `hydrated_bloc` (Specifically using Cubits for most feature states).
- **Dependency Injection:** `get_it` along with `injectable` for code generation.
- **Routing:** `auto_route` for declarative and type-safe routing.
- **Backend/Database:** `supabase_flutter`.

## 3. Directory Structure

Inside any specific app (e.g., `apps/labar_app`), the code is organized by features:

```text
lib/
├── core/               # Shared utilities, extensions, network clients, etc.
├── features/
│   ├── auth/           # Authentication mechanisms (Sign In, etc.)
│   ├── dashboard/      # (Admin) Overviews and stats
│   ├── home/           # Main dashboards for the mobile app
│   └── ...             # Other feature modules (e.g. settings)
```

Each feature is further broken down conceptually:
- `data/`: Models, DTOs, Data Sources (Remote/Local), and Repositories implementations.
- `domain/`: Entities, Repository Interfaces, and Use Cases.
- `presentation/`: Pages, Widgets, and State Management (Bloc/Cubit).

## 4. Key Features & Workflows

### Labar App (Mobile)
- **Application Forms:** Complex multi-step forms handled by separate cubits (e.g., `kyc_details_cubit`, `biometrics_cubit`, `farm_details_state`).
- **Resource Tracking:** Views to show allocated resources and assigned warehouses.

### Labar Admin (Web)
- **Role-Based Dashboards:** Distinct views for `Admin` and `Agent` depending on the logged-in user's permissions.
- **Management Modules:** Comprehensive CRUD interfaces for Users, Inventory, Items, and Warehouses.
- **PDF Generation:** Capability to generate PDF Waybills natively in the web app for dispatched items.

## 5. Setup & Development Environment

### Prerequisites
1. Install Flutter SDK and Dart.
2. Install Melos globally: `dart pub global activate melos`
3. Install [Just](https://github.com/casey/just) command runner for convenience.

### Getting Started

Use the `just` command runner to quickly bootstrap and generate necessary files:

```bash
# Full setup including dependency fetching, code generation, and localization
just setup

# Run the mobile app
just run-app

# Run the web admin dashboard
just run-admin
```

If you prefer Melos native commands, `melos bootstrap` will resolve all dependencies across the monorepo.

### Code Generation
Many packages (`injectable`, `auto_route`, `freezed`, etc.) rely on `build_runner`.
- Use `just build` to run the build runner across all packages.
- Use `just l10n` to compile the app's localization files (supports En & Ha).

## 6. Coding Guidelines & Best Practices

1. **State Management:** Keep logic inside Cubits/Blocs. The UI should only listen to state changes and dispatch events.
2. **Localization:** Do not hardcode strings in the UI. Always use the localization extension (e.g., `context.l10n.login`).
3. **Dependency Injection:** Use `@injectable` annotations for your repositories and use cases. Remember to run `build_runner` after adding a new injected class.
4. **UI Components:** Before building a new widget, check the `ui_library` package. If it's a generic component, add it to `ui_library` so the other app can use it.

## 7. Deployment

- **Web Admin:** Automatically deployed to Vercel. Ensure environment variables (Supabase URL, API Keys) are properly configured in the Vercel dashboard.
- **Mobile App:** Built via CI/CD pipelines. Use `just build-apk` or `just build-ios` to build locally.
