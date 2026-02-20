# IMDUMB

Una aplicación de películas en Flutter que demuestra **Clean Architecture**, **principios SOLID** y **prácticas de nivel de producción**.

---

## 📋 Descripción del Proyecto

**IMDUMB** es una app de descubrimiento de películas que exhibe diversas capacidades técnicas:
- **Arquitectura**: Clean Architecture estricta (Presentation, Domain, Data).
- **Manejo de Estado**: Implementación de BLoC con `bloc_concurrency` para transformación de eventos.
- **Networking**: Dio con Interceptors personalizados y manejo de errores.
- **Ambientes**: Flavors configurados para **QA** y **Producción**.
- **Integración con Firebase**: Remote Config para temas dinámicos, Analytics para comportamiento de usuario y Firestore para gestionar recomendaciones.

---

## 🏗️ Arquitectura

El proyecto sigue una rigurosa **Clean Architecture** para asegurar separación de responsabilidades, testabilidad y escalabilidad.

```
lib/
├── core/                    # Funcionalidades transversales
│   ├── bloc/                # BlocObserver Global
│   ├── config/              # Configuración de ambiente (Env)
│   ├── di/                  # Inyección de Dependencias (GetIt)
│   ├── network/             # Cliente Dio e Interceptors
│   ├── router/              # Navegación (GoRouter)
│   ├── services/            # Servicios de terceros (RemoteConfig, Theme)
│   └── theme/               # Sistema de Diseño de la App
│
├── features/
│   ├── home/                # Categorías de Películas (Géneros)
│   │   ├── presentation/    # HomeBloc, Páginas
│   │
│   ├── movie/               # Lógica Principal de Películas
│   │   ├── data/            # DTOs, DataSources (Remoto/Local), Impl de Repositorios
│   │   ├── domain/          # Entidades, Contratos de Repositorios, Casos de Uso
│   │   └── presentation/    # GenreMoviesBloc, MovieDetailsCubit, UI
│   │
│   └── splash/              # Inicialización de App y Precarga de Datos
```

### Responsabilidades de las Capas

1.  **Capa de Dominio (Núcleo Interno)**: Contiene código Dart puro. Entidades, Interfaces de Repositorios y Casos de Uso. Tiene **cero dependencias** de Flutter o librerías externas.
2.  **Capa de Datos**: Implementa las interfaces de Repositorios. Maneja la obtención de datos desde APIs (Dio) o Almacenamiento Local (Hive), y el mapeo a Entidades de Dominio.
3.  **Capa de Presentación**: UI (Widgets) y Manejo de Estado (BLoC/Cubit). Depende únicamente de la Capa de Dominio.

---

## ✨ Funcionalidades Clave y Detalles de Implementación

### 🔄 Manejo de Estado (BLoC)
Utilizamos el **patrón BLoC** para flujos complejos y **Cubit** para estados más simples.
- **Manejo Avanzado de Eventos**: Uso del transformador `droppable` de `bloc_concurrency` en `GenreMoviesBloc` para prevenir peticiones API duplicadas durante la paginación (throttling).
- **Monitoreo Global**: Implementación de `AppBlocObserver` para registrar todos los cambios de estado y errores para depuración.

### 🌍 Ambientes (Flavors)
La app está configurada con dos sabores distintos, cada uno con su propio proyecto de Firebase, bundle ID y variables de ambiente:
- **QA**: `com.example.imdumb.qa` (Banner Naranja, logs de debug habilitados)
- **Producción**: `com.example.imdumb` (UI Limpia, analíticas de producción)

Esto se logró usando `flutter_flavorizr` y puntos de entrada personalizados (`main_qa.dart`, `main_prod.dart`).

### 🔥 Integración con Firebase
- **Remote Config**: Obtiene colores de tema dinámicos (`primary_color`) al inicio de la app.
- **Analytics**: Rastrea eventos clave como `recommend_movie` y segmentación de usuarios por ambiente (propiedad de usuario `env`).
- **Firestore**: Implementa un **CRUD** completo para Recomendaciones de Usuario (Crear, Leer, Eliminar) directamente desde la vista detallada.

### 💾 Persistencia Local
- **Hive**: Usado para cachear datos críticos como Géneros de Películas para asegurar que la app funcione offline o cargue instantáneamente en lanzamientos subsiguientes.

---

## 🎥 Demo Preview

### 1. 🔄 Infinite Scroll & Concurrency
*Implementación del transformador `droppable` para prevenir llamadas duplicadas a la API.*

https://github.com/user-attachments/assets/ebdc4e79-2864-4c7a-9de2-4e136ba599aa

### 2. 🏠 Categorías y Listado de Películas
*Navegación fluida entre categorías y listados de películas.*



https://github.com/user-attachments/assets/36a3e12d-4525-4ec5-9659-13d7cf1b19ed



### 3. 🎬 Detalle de Película & Hero Animation
*Experiencia inmersiva con Hero Animations, carrusel de imágenes y lista de actores.*




https://github.com/user-attachments/assets/9db152f9-9b24-4a9b-80f5-b7737b022668




https://github.com/user-attachments/assets/1a60abbe-66df-46b8-ae40-86c92311e7ea







### 4. 📝 Recomendaciones (Firebase CRUD)
*Gestión completa de recomendaciones de usuario sincronizada en tiempo real con Firestore.*


https://github.com/user-attachments/assets/18ce6b46-cad9-466c-ab8e-c6bfd38b5922

<img width="2204" height="708" alt="Captura de pantalla 2026-02-17 a la(s) 3 24 52 p  m" src="https://github.com/user-attachments/assets/827738a1-2f8b-4966-ac87-e487dc18e9e0" />



https://github.com/user-attachments/assets/2cb59a24-4ce4-435d-b62d-7008f9e89454




### 5. 🎨 Dynamic Theming
*Personalización dinámica mediante Firebase Remote Config y soporte para Dark/Light mode.*


https://github.com/user-attachments/assets/01c3afc7-941b-46d8-8649-1a0feda5e3d0




### 6. 🌍 QA vs Prod Environments
*Separación total de ambientes. Cada entorno (QA/Prod) tiene su propio proyecto de Firebase, Bundle ID y configuración.*

**iOS Configuration**
<img width="799" height="284" alt="iOS Build Configuration" src="https://github.com/user-attachments/assets/ef634ab6-c074-417b-b963-0558dbe38543" />

<img width="300" alt="iOS Simulator" src="https://github.com/user-attachments/assets/8e15852a-2b53-4b27-bc98-45c2228b7639" />

**Android Configuration**
<img width="608" height="557" alt="Android Application ID" src="https://github.com/user-attachments/assets/73546f70-9f84-4d3e-82bc-4e0f4049fa3f" />

---

## 🏛️ Principios SOLID en Acción

Ejemplos específicos de principios SOLID documentados en el código:

1.  **Principio de Responsabilidad Única (SRP)**:
    - *Ejemplo*: `MovieRemoteDataSource` maneja **solo** la obtención de datos crudos, mientras que `MovieRepositoryImpl` mapea esos modelos a entidades de dominio.
2.  **Principio Abierto/Cerrado (OCP)**:
    - *Ejemplo*: El `DioClient` está abierto para extensión (añadir nuevos interceptors) pero cerrado para modificación. Añadimos `LoggingInterceptor` y `ErrorInterceptor` sin cambiar la lógica central del cliente.
3.  **Principio de Inversión de Dependencias (DIP)**:
    - *Ejemplo*: La capa de Presentación depende de abstracciones (`UseCases` e interfaces de `Repository` del Dominio), no de implementaciones concretas (Datos). Todas las dependencias se inyectan vía `GetIt` (`injection_container.dart`).

---

## 🚀 Instalación y Ejecución

### Prerrequisitos
- Flutter SDK: `>=3.10.8`
- Dart SDK: `>=3.0.0`
- Proyecto de Firebase Activo (se requiere google-services.json)

### Instalación
```bash
# Clonar el repositorio
git clone https://github.com/JosueLemus/IMDUMB.git
cd imdumb

# Instalar dependencias
flutter pub get
```

### Ejecutar la App
Dado que el proyecto usa sabores (flavors), **debes** especificar el sabor y el punto de entrada:

**Ejecutar Ambiente QA:**
```bash
flutter run --flavor qa --dart-define=appFlavor=qa  
```

**Ejecutar Ambiente Producción:**
```bash
flutter run --flavor prod --dart-define=appFlavor=prod
```

### Nota sobre Secretos
El proyecto requiere archivos `.env.qa` y `.env.prod` en el directorio raíz.
```env
# .env.qa / .env.prod
TMDB_BASE_URL=https://api.themoviedb.org/3
TMDB_ACCESS_TOKEN=tu_token_api_aqui
```

---

## 📦 Stack Tecnológico

- **Core**: Flutter, Dart
- **Estado**: `flutter_bloc`, `bloc_concurrency`, `equatable`
- **Navegación**: `go_router`
- **Networking**: `dio`
- **DI**: `get_it`
- **Almacenamiento**: `hive`, `hive_flutter`
- **Firebase**: `firebase_core`, `cloud_firestore`, `firebase_remote_config`, `firebase_analytics`
- **UI Tooling**: `cached_network_image`, `shimmer`, `carousel_slider_plus`

---
*Desarrollado por Josue Lemus - 2026*
