# Animaciones Rive

Coloca tus archivos de animación Rive (`.riv`) en este directorio.

## Cómo obtener animaciones Rive

1. Visita [rive.app](https://rive.app)
2. Explora la comunidad de animaciones gratuitas
3. Descarga los archivos `.riv` que necesites
4. Colócalos en este directorio

## Ejemplo de uso

```dart
import 'package:brote/widgets/rive_animation_widget.dart';

// Animación simple
RiveAnimationWidget(
  assetPath: 'assets/animations/money.riv',
)

// Animación interactiva con state machine
InteractiveRiveAnimation(
  assetPath: 'assets/animations/loading.riv',
  stateMachineName: 'State Machine 1',
  initialInputs: {
    'isLoading': true,
  },
)
```

## Recursos recomendados

- [Rive Community](https://rive.app/community/) - Animaciones gratuitas
- [Rive Documentation](https://rive.app/community/files/file/35-rive-flutter-runtime-documentation/) - Documentación oficial
- [Rive Editor](https://rive.app/editor/) - Crea tus propias animaciones

