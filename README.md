# Magnojet App

Aplicación móvil desarrollada en Flutter para la gestión de inventario de recursos materiales de Magnojet, con herramientas de apoyo para aplicaciones agrícolas (cálculo de tasa de aplicación y selección de boquillas).

## Funcionalidades

- **Inventario en tiempo real**: sincroniza el stock de productos desde Google Sheets (Google Sheets API) y lo muestra filtrado por sede (Bogotá, Cereté, Villavicencio, Yopal).
- **Alertas de stock**: resalta automáticamente los productos con stock bajo o agotado.
- **Búsqueda de productos**: búsqueda rápida sobre el inventario cargado.
- **Calculadora de Tasa de Aplicación (Q)**: calcula el caudal requerido a partir de la dosis, velocidad y ancho de aplicación.
- **Calculadora de Selección de Boquilla (q)**: recomienda la boquilla más adecuada según los parámetros de aplicación.
- **Catálogo V40 Digital**: visor de PDF integrado para consultar el catálogo de productos.

## Stack técnico

- [Flutter](https://flutter.dev/) (Dart)
- `provider` para gestión de estado
- `http` para consumo de la Google Sheets API
- `flutter_pdfview` para el visor del catálogo
- `flutter_local_notifications` para notificaciones de alertas de stock
- `path_provider`, `intl`

## Estructura del proyecto

```
lib/
  app/            # Configuración raíz de la app (MaterialApp, rutas, tema)
  core/           # Constantes, tema y utilidades compartidas
  data/           # Modelos y repositorios (fuente de datos: Google Sheets)
  features/       # Pantallas y controladores por funcionalidad
    home/         # Pantalla principal / resumen de inventario
    inventory/    # Listado de inventario
    alerts/       # Alertas de stock bajo/agotado
    search/       # Búsqueda de productos
    calculators/  # Calculadoras Q y de boquillas
    catalog/      # Visor del catálogo PDF
  shared/         # Widgets reutilizables
```

## Cómo ejecutar el proyecto

1. Instala el [SDK de Flutter](https://docs.flutter.dev/get-started/install).
2. Instala las dependencias:
   ```
   flutter pub get
   ```
3. Coloca el archivo `catalogo_v40_digital.pdf` en `assets/docs/` (no se versiona en este repositorio por su tamaño).
4. Ejecuta la app:
   ```
   flutter run
   ```

## Ramas

- `main`: rama estable.
- `app_refactoring`: rama de desarrollo activo para refactorización y nuevas actualizaciones antes de integrarlas a `main`.
