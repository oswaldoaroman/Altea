# Altea

**Altea** es una aplicación móvil desarrollada en **Flutter** orientada a la evaluación preliminar del riesgo cardiovascular mediante Inteligencia Artificial Explicable (XAI).

El proyecto busca acercar herramientas de prevención a la población utilizando un modelo predictivo interpretable que permite estimar un porcentaje de riesgo cardiovascular a partir de información proporcionada por el usuario.

> **Este proyecto tiene fines educativos y de investigación.**
> No proporciona diagnósticos médicos ni sustituye la valoración realizada por un profesional de la salud.

---

# Características

- Evaluación rápida del riesgo cardiovascular.
- Modelo sustituto (Surrogate Model) basado en reglas de decisión.
- Inteligencia Artificial Explicable (XAI).
- Interfaz desarrollada con Flutter.
- Recomendaciones preventivas personalizadas.
- Arquitectura modular basada en Features.
- Preparado para integrar chatbot médico mediante Ollama.

---

# ¿Cómo funciona?

El usuario introduce información básica relacionada con su salud:

- Edad
- Sexo
- Peso
- Estatura
- Presión arterial (categorizada)
- Colesterol
- Glucosa
- Consumo de alcohol
- Consumo de tabaco
- Nivel de actividad física

La aplicación procesa estos datos mediante un **modelo predictivo sustituto**, el cual fue obtenido a partir de un modelo de aprendizaje automático más complejo.

Este enfoque permite mantener una buena capacidad predictiva mientras hace que las decisiones sean completamente interpretables.

Finalmente, el sistema:

- Calcula un porcentaje estimado de riesgo cardiovascular.
- Identifica factores de riesgo relevantes.
- Genera recomendaciones preventivas.

---

# Inteligencia Artificial Explicable (XAI)

Uno de los principales objetivos de Altea es evitar el uso de modelos completamente opacos ("caja negra").

En lugar de utilizar directamente un modelo complejo durante la inferencia, se emplea un **modelo sustituto** basado en árboles de decisión que transforma el conocimiento aprendido en reglas fácilmente interpretables.

Esto ofrece varias ventajas:

- Transparencia en las decisiones.
- Explicabilidad del resultado.
- Menor consumo de recursos.
- Mayor facilidad para auditar el modelo.
- Posibilidad de ejecutar el sistema completamente en el dispositivo.

---

# Tecnologías utilizadas

- Flutter
- Dart
- Python
- Scikit-Learn
- Decision Trees
- Explainable AI (XAI)
- Ollama (integración futura del chatbot)
- Git

---

# Arquitectura

El proyecto utiliza una arquitectura **Feature First**, donde cada funcionalidad mantiene organizados sus widgets, pantallas, modelos y servicios.

```
lib/
│
├── core/
│   ├── theme/
│   ├── services/
│   └── utils/
│
├── features/
│   ├── home/
│   ├── formulario/
│   ├── resultado/
│   ├── chatbot/
│   └── carga/
│
└── main.dart
```

---

# Instalación

## Clonar el repositorio

```bash
git clone https://github.com/usuario/altea.git
```

Entrar al proyecto

```bash
cd altea
```

Instalar dependencias

```bash
flutter pub get
```

Ejecutar

```bash
flutter run
```

---

# Estado del proyecto

Actualmente el proyecto incluye:

- Interfaz principal
- Formulario de evaluación
- Modelo sustituto implementado en Dart
- Pantalla de resultados
- Sistema de recomendaciones
- Navegación entre pantallas

En desarrollo:

- Historial de evaluaciones
- Base de datos
- Integración completa del chatbot
- Riesgo cardiovascular a 10 años
- Backend y sincronización de datos

---

# Descargo de responsabilidad

Altea **no es un dispositivo médico**.

Los resultados obtenidos corresponden únicamente a una **estimación estadística** basada en un modelo predictivo y **no deben utilizarse como diagnóstico clínico**.

Ante cualquier duda o síntoma, consulte siempre a un profesional de la salud.

---

# Licencia

Este proyecto fue desarrollado con fines académicos y de investigación.


No se autoriza su utilización como herramienta de diagnóstico médico.

No se autoriza su utilización como herramienta de diagnóstico médico.

