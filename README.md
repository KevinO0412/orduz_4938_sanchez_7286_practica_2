# NeuroRuta - NEURO CIENCIA SC

Aplicación Flutter de optimización de secuencias desarrollada para la **Práctica II de Programación II**.

## Descripción

NeuroRuta permite ingresar una secuencia de números enteros positivos y calcular la transformación de menor costo para convertirla en:
- una secuencia ascendente,
- una secuencia descendente,
- una secuencia constante.

El proyecto usa lógica recursiva con memoización para buscar transformaciones óptimas sin permutar el orden original de los elementos.

## Funcionalidades principales

- Autenticación simulada con pantalla de login.
- Pantalla de carga antes de ingresar al dashboard.
- Ingreso de secuencias de números enteros positivos separados por espacios.
- Validación de entrada y límite de secuencia (máximo 6 elementos).
- Cálculo de la estrategia de menor costo para:
  - Orden ascendente.
  - Orden descendente.
  - Secuencia constante.
- Comparación de costos entre las tres estrategias.
- Visualización detallada de operaciones aplicadas.
- Historial local de las últimas transformaciones usando `shared_preferences`.

## Tecnologías utilizadas

- Flutter
- Dart
- Provider
- Shared Preferences

## Dependencias relevantes

- `provider: ^6.1.5+1`
- `shared_preferences: ^2.5.5`
- `cupertino_icons: ^1.0.8`

## Estructura principal del proyecto

- `lib/main.dart` - Punto de entrada de la aplicación.
- `lib/screens/login_screen.dart` - Pantalla de acceso.
- `lib/screens/loading_screen.dart` - Pantalla de carga.
- `lib/screens/dashboard_screen.dart` - Dashboard principal con secciones de análisis.
- `lib/providers/sequence_optimizer_provider.dart` - Provider que maneja estado, validación y resultados.
- `lib/services/sequence_optimizer_service.dart` - Lógica de optimización de secuencias.
- `lib/models/optimization_result.dart` - Modelo para resultados de optimización.
- `lib/models/operation_model.dart` - Modelo para operaciones individuales.
- `lib/widgets/result_card.dart` - Componente de tarjeta para resultados.
- `lib/widgets/operations_table.dart` - Tabla de operaciones aplicadas.
- `assets/images/neuro_ciencia_logo.png` - Logo usado en la UI.

## Reglas de entrada

- Solo números enteros positivos.
- Los valores deben ingresarse separados por espacios.
- Se admiten hasta 6 elementos.
- Si se ingresa `0`, se interpreta como salida / no aplicación.

### Formato de ejemplo

```text
10 2 5
```

## Operaciones permitidas

| Operación | Descripción | Costo |
|---|---|---|
| `+1` | Incrementar el valor en 1 | 1 |
| `-1` | Decrementar el valor en 1 | 1 |
| `*2` | Multiplicar el valor por 2 | 3 |
| `/2` | Dividir el valor por 2 (solo si es par) | 2 |

## Estrategias de optimización

- **Orden Ascendente**: busca una secuencia no decreciente.
- **Orden Descendente**: busca una secuencia no creciente.
- **Constante**: convierte todos los valores al mismo número.

El servicio calcula los costos mínimos para cada estrategia y luego selecciona la mejor basada en el costo total más bajo.

## Uso

### Preparar el proyecto

1. Asegúrate de tener instalado Flutter.
2. Abre la carpeta del proyecto.
3. Ejecuta:

```bash
flutter pub get
```

### Ejecutar la app

```bash
flutter run
```

Puedes especificar un dispositivo si lo deseas, por ejemplo:

```bash
flutter run -d linux
flutter run -d windows
flutter run -d macos
flutter run -d chrome
```

## Credenciales de acceso (por defecto)

- Usuario: `admin@neurociencia.com`
- Contraseña: `123456`

## Flujo de la aplicación

1. Ingresar en el login.
2. Esperar la pantalla de carga.
3. Acceder al dashboard.
4. Ingresar una secuencia en la sección `Ingresar secuencia`.
5. Procesar la secuencia.
6. Revisar los resultados individuales y la comparación.
7. Consultar el historial de análisis.

## Consideraciones técnicas

- El algoritmo usa memoización para evitar recalcular estados intermedios.
- La UI está construida con `MaterialApp` y `Provider` para administrar el estado global.
- Los resultados muestran cada operación individual aparte del costo total.

## Notas

- El historial guarda hasta 20 análisis recientes.
- Si se borra el historial, se limpia también del almacenamiento local.

## Autor

- Proyecto para la práctica de programación II, titulado **NeuroRuta**.
