# Brote - App de Finanzas Personales

Aplicación móvil completa de gestión financiera personal desarrollada con Flutter.

## 🆕 Versión 1.4.2 - Novedades

### 🤖 **Sistema de Ingresos y Pagos Automáticos**
- **Gestión Completa de Automáticos**: Nueva sección en ajustes para gestionar ingresos y pagos automáticos (como nómina, débitos automáticos del banco, etc.)
- **Creación y Edición**: Crea y edita automáticos con toda la información necesaria:
  - Título y monto
  - Categoría o fuente de ingreso según el tipo
  - Frecuencia configurable (semanal, quincenal, mensual, trimestral, anual)
  - Día específico del mes o semana según la frecuencia
  - Fecha de inicio y fin (opcional)
  - Descripción opcional
- **Vinculación con Finanzas**: Los automáticos pueden vincularse opcionalmente a:
  - **Gastos**: Vincular a deudas (préstamos recibidos) o metas de ahorro
  - **Ingresos**: Vincular a préstamos dados (que me deben)
- **Notificaciones Personalizadas**: Cada automático puede tener notificaciones activadas o desactivadas individualmente, con hora personalizada
- **Vista Organizada**: Los automáticos se muestran separados por tipo (Ingresos automáticos / Pagos automáticos) con indicadores visuales de estado y notificaciones
- **Integración en Ajustes**: Acceso rápido desde la sección "Automatización" en ajustes, ubicada estratégicamente antes de la configuración de moneda

### ✨ Otras Mejoras
- **Interfaz Intuitiva**: Diseño consistente con el resto de la aplicación
- **Gestión Simplificada**: Fácil creación, edición y eliminación de automáticos
- **Feedback Visual**: Indicadores claros del estado de cada automático (activo/inactivo, notificaciones activadas)

## 🆕 Versión 1.3.2 - Novedades

### 🎯 **Corrección en Ingresos y Gastos del Home**
- **Filtrado por Período Configurado**: Los ingresos y gastos mostrados en la parte inferior de la pantalla de inicio ahora respetan correctamente la configuración de período seleccionada en ajustes:
  - **Diario**: Muestra ingresos y gastos del día actual
  - **Semanal**: Muestra ingresos y gastos de la semana actual (según día configurado)
  - **Mensual**: Muestra ingresos y gastos del mes actual (según día configurado)
  - **Total**: Muestra todos los ingresos y gastos acumulados
- **Sincronización con Balance**: Los valores de ingresos y gastos ahora se actualizan automáticamente cuando cambias la configuración de período, manteniendo consistencia con el balance total mostrado
- **Cálculo Preciso**: Los períodos se calculan correctamente usando la misma lógica que el balance, asegurando coherencia en toda la interfaz

## 🆕 Versión 1.3.1 - Novedades

### 🎯 **Mejoras en Navegación y UX**
- **Navegación por Deslizamiento**: Ahora puedes deslizar entre las pestañas "Activas" e "Historial" en todos los módulos financieros (Ahorros, Inversiones, Préstamos)
- **Mensajes Personalizados en Historial**: Cada módulo muestra mensajes de estado vacío personalizados y contextuales:
  - **Ahorros**: "No tienes metas de ahorro completadas" con icono y descripción específica
  - **Inversiones**: "No tienes inversiones completadas" con icono y descripción específica
  - **Préstamos**: "No tienes préstamos completados" con icono y descripción específica
- **Corrección en Módulo de Ahorros**: Solucionado el problema que impedía deslizar entre pestañas cuando no había metas de ahorro
- **Consistencia de Navegación**: Todos los módulos financieros ahora tienen el mismo comportamiento de navegación por deslizamiento

### ✨ Otras Mejoras
- **Iconos Contextuales**: Los mensajes de estado vacío incluyen iconos circulares con el color del módulo correspondiente
- **Mejor Feedback Visual**: Descripciones más claras y específicas para guiar al usuario

## 🆕 Versión 1.3.0 - Novedades

### 🎨 **Mejoras en Modo Oscuro**
- **Correcciones de Contraste**: Mejoras en la legibilidad de textos y elementos en modo oscuro
- **Colores Adaptativos**: Todos los componentes ahora se adaptan correctamente al tema oscuro
- **Paleta de Colores Mejorada**: Verde menos brillante y más matte en modo oscuro para mejor experiencia visual
- **Consistencia Visual**: Correcciones en pantallas de finanzas, estadísticas, ajustes y categorías para una experiencia uniforme

### 📚 **Sistema de Historial Integrado**
- **Pestañas de Historial**: Cada módulo financiero (Ahorros, Inversiones, Préstamos) ahora incluye una pestaña dedicada de "Historial"
- **Gestión de Completados**: Los elementos completados se mueven automáticamente al historial
- **Opciones de Ordenamiento**: 
  - Ordenar por fecha (más recientes/más antiguos)
  - Ordenar por valor (mayor/menor)
  - Ordenar por ganancia (para inversiones)
- **Acciones en Historial**: 
  - Reactivar elementos completados
  - Eliminar elementos del historial
- **Resumen de Historial**: Vista resumida con totales y estadísticas de elementos completados

### 🔗 **Conexión de Pagos y Finanzas**
- **Vinculación de Transacciones**: Al agregar un ingreso o gasto, puedes vincularlo opcionalmente a:
  - **Gastos**: Vincular a deudas (préstamos recibidos) o metas de ahorro
  - **Ingresos**: Vincular a préstamos dados (que me deben)
- **Integración Automática**: Los pagos vinculados se registran automáticamente en el módulo correspondiente
- **Lógica Inteligente**: 
  - Las metas de ahorro solo se pueden vincular con gastos (para ahorrar dinero)
  - Los préstamos se pueden vincular tanto con ingresos como con gastos según corresponda
- **Seguimiento Unificado**: Mantén un registro coherente entre transacciones y módulos financieros

### ✨ Otras Mejoras
- **Limpieza de Interfaz**: Los préstamos completados ya no aparecen en las pestañas activas, solo en historial
- **Mejoras en UX**: Mejor organización y navegación entre módulos activos e historial

## 🆕 Versión 1.1.0 - Novedades

### 🔔 **Mejoras Destacadas en Notificaciones**

#### Sistema de Notificaciones Avanzado
- **Notificaciones Adaptativas por Frecuencia**: El sistema de notificaciones se adapta inteligentemente según la frecuencia de pago/retorno configurada:
  - **Frecuencia Semanal**: Permite seleccionar días específicos de la semana (Lunes, Martes, etc.)
  - **Frecuencia Quincenal**: Permite seleccionar días específicos del mes (ej: día 1 y 15)
  - **Frecuencia Mensual/Trimestral/Anual**: Permite seleccionar día específico del mes y hora personalizada
  - **Frecuencia Diaria**: Configuración de hora personalizada

#### Características de Notificaciones
- **Selección Múltiple de Días**: Para frecuencias mensuales/quincenales, puedes seleccionar múltiples días del mes
- **Hora Personalizada**: Configura la hora exacta para recibir recordatorios
- **Cancelación de Notificaciones**: Opción para cancelar notificaciones en cada módulo (Ahorros, Inversiones, Préstamos)
- **Permisos Inteligentes**: El diálogo de permisos solo aparece una vez al iniciar la app por primera vez
- **Switch Funcional**: Activación/desactivación global de notificaciones completamente funcional

#### Notificaciones por Módulo
- **Ahorros**: Recordatorios adaptados a la frecuencia de aportes (diario, semanal, quincenal, mensual)
- **Inversiones**: Recordatorios para seguimiento de valor y rentabilidad
- **Préstamos**: Recordatorios de pagos/cobros adaptados a la frecuencia de pago configurada

### ✨ Otras Mejoras

#### Gestión del Balance Total
- **Personalización del Ciclo de Reinicio**: Configura cómo se reinicia el balance en el home:
  - **Diario**: Se reinicia cada día
  - **Semanal**: Se reinicia en un día específico de la semana (configurable)
  - **Mensual**: Se reinicia en un día específico del mes (configurable, 1-28)
  - **Total**: Muestra el balance acumulado completo
- **Mini Título Dinámico**: El home muestra un indicador del tipo de historial que se está mostrando
- **Balance Histórico en Estadísticas**: El balance total acumulado siempre disponible en la sección de Estadísticas

#### Mejoras en Módulos Financieros
- **Funcionalidad de Edición**: Todos los módulos (Ahorros, Inversiones, Préstamos) ahora incluyen opción de edición con modal grande pre-llenado
- **Botones de Acción Rápida Mejorados**: Valores actualizados a 5,000, 10,000, 20,000, 50,000, 100,000 y opción "Personalizado"
- **Separadores de Miles en Inputs**: Todos los campos de entrada de montos muestran separadores de miles en tiempo real
- **Iconos y Colores Personalizables**: Selección de iconos y colores personalizados para cada meta de ahorro, inversión y préstamo

#### Correcciones y Ajustes
- **Filtrado de Fechas Preciso**: Corrección en el filtrado de transacciones por fecha única en estadísticas
- **Gestión de Etiquetas Predefinidas**: Las etiquetas de ingresos predefinidas ahora pueden ocultarse (no eliminarse) y restaurarse
- **Periodicidad de Tasas**: Especificación de periodicidad de tasa de interés para préstamos e inversiones (diaria, semanal, mensual, anual)
- **Fechas de Inicio**: Posibilidad de especificar fecha de inicio para préstamos e inversiones
- **Exportación con Rango de Fechas**: Selección de rango de fechas personalizado o períodos predefinidos al exportar

## Características

### 📊 Dashboard Principal
- Resumen financiero con balance total, ingresos y gastos
- Gráfico de tendencias de los últimos 7 días
- Transacciones recientes con filtro rápido
- Accesos directos para agregar ingresos/gastos

### 💰 Gestión de Transacciones
- Registro de ingresos y gastos con categorías
- Historial completo con búsqueda y filtros
- Edición y eliminación de transacciones
- Soporte para transacciones recurrentes
- **Vinculación a Finanzas**: Opción de vincular transacciones a módulos financieros (ahorros, préstamos)
- **Registro Automático**: Los pagos vinculados se registran automáticamente en el módulo correspondiente

### 🤖 Ingresos y Pagos Automáticos
- **Gestión Completa**: Crea y gestiona ingresos y pagos automáticos (nómina, débitos automáticos, etc.)
- **Configuración Flexible**: Define frecuencia (semanal, quincenal, mensual, trimestral, anual) y días específicos
- **Vinculación con Finanzas**: Opción de vincular automáticos a préstamos o metas de ahorro
- **Notificaciones Personalizadas**: Activa o desactiva notificaciones para cada automático con hora personalizada
- **Vista Organizada**: Separación clara entre ingresos automáticos y pagos automáticos
- **Fechas de Inicio y Fin**: Configura períodos específicos para cada automático

### 🏦 Hub Financiero
- Vista centralizada de todas las finanzas
- Resumen de ahorros, inversiones y préstamos
- Navegación rápida a cada sección

### 🐷 Bolsillos de Ahorro
- Creación de metas de ahorro con objetivo
- Iconos y colores personalizables por meta
- Seguimiento de progreso con barra visual
- Historial de aportaciones
- **Frecuencia de Aportes**: Configuración de frecuencia (diario, semanal, quincenal, mensual, personalizado)
- **Edición Completa**: Modal de edición con todos los campos pre-llenados
- Recordatorios configurables adaptados a la frecuencia de aportes
- **Pestaña de Historial**: Vista de metas completadas con ordenamiento y acciones
- **Vinculación con Gastos**: Los gastos pueden vincularse automáticamente a metas de ahorro

### 📈 Inversiones
- Registro de inversiones con valor inicial y actual
- Iconos y colores personalizables
- Fecha de compra/inicio
- **Periodicidad de Tasa de Rentabilidad**: Diaria, semanal, mensual o anual
- Historial de valoraciones
- Cálculo automático de rentabilidad
- Venta parcial o total
- **Edición Completa**: Modal de edición con todos los campos pre-llenados
- **Pestaña de Historial**: Vista de inversiones completadas con ordenamiento por fecha, valor o ganancia
- **Gestión de Completados**: Reactivar o eliminar inversiones del historial

### 💳 Préstamos
- Gestión de préstamos (por cobrar y por pagar)
- Iconos y colores personalizables
- Fecha de inicio del préstamo
- **Periodicidad de Tasa de Interés**: Diaria, semanal, mensual o anual
- Seguimiento de pagos realizados
- Recordatorios de cobro/pago adaptados a la frecuencia de pago
- **Edición Completa**: Modal de edición con todos los campos pre-llenados
- **Pestaña de Historial**: Vista de préstamos completados con ordenamiento y acciones
- **Vinculación con Transacciones**: Los ingresos y gastos pueden vincularse a préstamos para registro automático de pagos

### 📊 Estadísticas
- Gráficos circulares de distribución (ingresos/gastos)
- Análisis por período (semana, mes, año)
- Tendencias de balance
- Comparativas de categorías

### 📤 Exportación de Datos
- Exportar a Excel (.xlsx)
- Exportar a PDF
- Selección de rango de fechas personalizado
- Períodos predefinidos (Todo, Este año, Últimos 6 meses, etc.)

### 🔔 Notificaciones Avanzadas
- **Sistema Adaptativo**: Notificaciones que se adaptan según la frecuencia configurada
- **Selección Múltiple de Días**: Para frecuencias mensuales/quincenales
- **Hora Personalizada**: Configuración de hora exacta para recordatorios
- **Días de la Semana**: Selección específica para frecuencias semanales
- **Día del Mes**: Selección específica para frecuencias mensuales/trimestrales/anuales
- **Cancelación por Módulo**: Opción para cancelar notificaciones en cada sección
- **Permisos Inteligentes**: Diálogo de permisos solo aparece una vez
- **Switch Global Funcional**: Activación/desactivación completamente operativa

### ⚙️ Configuración
- Formato de moneda personalizable
- Separadores de miles y decimales
- **Personalización del Ciclo de Balance**: Configura cómo se reinicia el balance (diario, semanal, mensual, total)
- **Día de Reinicio Personalizado**: Para períodos semanales y mensuales
- Activar/desactivar notificaciones
- **Tema Claro y Oscuro**: Soporte completo para modo oscuro con mejoras en contraste y legibilidad

## Requisitos

- Flutter SDK 3.0.0 o superior
- Dart 3.0.0 o superior
- Android SDK 21+ / iOS 12+

## Instalación

1. Clona el repositorio:
```bash
git clone https://github.com/tu-usuario/brote.git
cd brote
```

2. Instala las dependencias:
```bash
flutter pub get
```

3. Genera los archivos de base de datos:
```bash
dart run build_runner build
```

4. Ejecuta la aplicación:
```bash
flutter run
```

## Estructura del Proyecto

```
lib/
├── main.dart                    # Punto de entrada
├── database/
│   ├── app_database.dart        # Definición de tablas Drift
│   └── app_database.g.dart      # Código generado
├── models/
│   ├── transaction.dart         # Modelo de transacción
│   ├── savings_goal.dart        # Modelo de meta de ahorro
│   ├── investment.dart          # Modelo de inversión
│   ├── loan.dart                # Modelo de préstamo
│   ├── user_settings.dart       # Configuración del usuario
│   ├── budget.dart              # Modelo de presupuesto
│   └── alert.dart               # Modelo de alerta
├── screens/
│   ├── main_navigation.dart     # Navegación principal
│   ├── home_screen.dart         # Pantalla de inicio
│   ├── finance_hub_screen.dart  # Hub financiero central
│   ├── transactions_screen.dart # Historial de transacciones
│   ├── add_transaction_screen.dart
│   ├── savings_screen.dart      # Gestión de ahorros
│   ├── investments_screen.dart  # Gestión de inversiones
│   ├── loans_screen.dart        # Gestión de préstamos
│   ├── stats_screen.dart        # Estadísticas y gráficos
│   └── settings_screen.dart     # Configuración
├── services/
│   ├── finance_service.dart     # Lógica de negocio principal
│   ├── notification_service.dart # Servicio de notificaciones
│   └── export_service.dart      # Exportación Excel/PDF
├── widgets/                     # Widgets reutilizables
└── auth/                        # Autenticación (futuro)
```

## Dependencias Principales

| Paquete | Uso |
|---------|-----|
| `provider` | Gestión de estado |
| `drift` | Base de datos SQLite |
| `fl_chart` | Gráficos y visualizaciones |
| `intl` | Formateo de fechas y números |
| `excel` | Exportación a Excel |
| `pdf` / `printing` | Generación y exportación PDF |
| `flutter_local_notifications` | Notificaciones locales |
| `google_fonts` | Tipografías personalizadas |
| `path_provider` | Acceso al sistema de archivos |
| `share_plus` | Compartir archivos |

## Capturas de Pantalla

*Próximamente*

## Contribuir

1. Fork el proyecto
2. Crea tu rama de feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -m 'Agrega nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

## Historial de Versiones

### Versión 1.4.2 (Actual)
- 🤖 Sistema completo de ingresos y pagos automáticos
- 🔗 Vinculación de automáticos con finanzas (préstamos y ahorros)
- 🔔 Notificaciones personalizadas por automático
- 📍 Sección de automatización en ajustes, ubicada estratégicamente
- ✨ Interfaz intuitiva para gestión de automáticos

### Versión 1.3.2
- 🎯 Corrección en filtrado de ingresos y gastos del home según período configurado
- 🔄 Sincronización automática con la configuración de balance reset period
- ✨ Cálculo preciso de períodos diarios, semanales, mensuales y totales

### Versión 1.3.1
- 🎯 Navegación por deslizamiento entre pestañas en todos los módulos financieros
- 💬 Mensajes personalizados de estado vacío en historial para cada módulo
- 🐛 Corrección del swipe en módulo de ahorros
- ✨ Mejoras en consistencia de navegación y feedback visual

### Versión 1.3.0
- 🎨 Mejoras completas en modo oscuro con mejor contraste y legibilidad
- 📚 Sistema de historial integrado con ordenamiento y gestión de completados
- 🔗 Conexión de pagos y finanzas para vinculación de transacciones
- ✨ Mejoras en UX y organización de módulos

### Versión 1.2.0
- Mejoras y correcciones menores

### Versión 1.1.0
- 🔔 Sistema de notificaciones avanzado y adaptativo
- ⚙️ Personalización del ciclo de reinicio del balance
- ✏️ Funcionalidad de edición en todos los módulos financieros
- 🎨 Iconos y colores personalizables
- 🔧 Mejoras en botones de acción rápida
- 🐛 Correcciones en filtrado de fechas y gestión de etiquetas

### Versión 1.0.0
- 🎉 Lanzamiento inicial
- Funcionalidades básicas de gestión financiera
- Dashboard y estadísticas
- Exportación a Excel y PDF

## Licencia

Este proyecto es de código abierto bajo la licencia MIT.

---

Desarrollado usando Flutter

**Desarrollado por DRKDEV**
