# ENTRENA SUB9 v3 — De GitHub al móvil y ordenador

## Los archivos que necesitas

- `index.html` — aplicación completa: mesociclos, gimnasio, carrera, piscina, Polar, báscula y nube.
- `config.js` — configuración pública del proyecto Supabase (se edita después de crearlo).
- `supabase_entrena_sub9.sql` — estructura y normas privadas de acceso de la base de datos.

La aplicación sigue funcionando **en local**, incluso sin Supabase; solo hay sincronización entre dispositivos cuando se completan los pasos siguientes.

## 1. Crea el proyecto Supabase

1. Abre <https://supabase.com/dashboard> e inicia sesión.
2. Pulsa **New project**. Elige nombre (por ejemplo `entrena-sub9`), una contraseña segura de base de datos y la región más cercana.
3. Cuando el proyecto esté listo, entra en **SQL Editor** > **New query**.
4. Abre `supabase_entrena_sub9.sql` con un editor de texto, copia todo el contenido, pégalo en SQL Editor y pulsa **Run**.
5. Comprueba en **Table Editor** que existe la tabla `entrena_items`.
6. En **Authentication** > **Providers**, comprueba que esté activado el proveedor **Email**. Dependiendo de la configuración, Supabase solicitará confirmar el correo al registrarte.

## 2. Copia la configuración de Supabase

1. En tu proyecto entra en **Connect** o **Project Settings** > **API Keys** (la etiqueta puede variar).
2. Localiza **Project URL**, que empieza por `https://` y termina en `.supabase.co`.
3. Copia la **publishable key** (`sb_publishable_...`) o la clave antigua **anon** (`eyJ...`).
4. Abre `config.js` y cambia `PEGA_AQUI_TU_PROJECT_URL` y `PEGA_AQUI_TU_PUBLISHABLE_KEY` por esos valores, sin borrar las comillas.
5. **Nunca pongas una `secret key` ni la clave `service_role` en `config.js` o GitHub.** Las claves publicables son aptas para páginas web cuando existe RLS, como en el SQL entregado.

Un ejemplo ilustrativo del contenido de `config.js`:

```javascript
window.ENTRENA_CLOUD = {
  url: 'https://TU-PROYECTO.supabase.co',
  publishableKey: 'sb_publishable_TU_CLAVE_PUBLICA'
};
```

## 3. Publica los archivos en tu repositorio GitHub

Repositorio: <https://github.com/psanpa/entrena-sub9>

- En **Code**, selecciona **Add file** > **Upload files** (si está vacío: **uploading an existing file**).
- Sube `index.html` y `config.js` juntos y confirma **Commit changes**.
- Si ya existe `index.html`, GitHub te permitirá **reemplazarlo** subiendo un archivo con el mismo nombre, o puedes abrir el archivo y usar el lápiz para editarlo.
- En **Settings** > **Pages**, usa **Deploy from a branch** > `main` > `/(root)` > **Save**.
- La dirección prevista será <https://psanpa.github.io/entrena-sub9/> cuando GitHub Pages termine de publicarla.

No es necesario publicar el archivo `.sql` si prefieres mantenerlo en el ordenador; solamente debes ejecutarlo una vez dentro de Supabase.

## 4. Configura la dirección de confirmación por correo

En Supabase, dentro de **Authentication** > **URL Configuration**, configura **Site URL** con `https://psanpa.github.io/entrena-sub9/`. En **Redirect URLs**, añade también `https://psanpa.github.io/entrena-sub9/**` cuando corresponda. Esto permite que los enlaces de confirmación vuelvan a tu aplicación publicada.

## 5. Inicia sesión desde ambos dispositivos

1. En el móvil, abre `https://psanpa.github.io/entrena-sub9/`.
2. Entra en la pestaña **☁ Nube**.
3. Pulsa **Crear cuenta** con tu correo y contraseña. Confirma el correo si se solicita. Después entra con esa misma cuenta.
4. Pulsa **Sincronizar ahora** y comprueba que el indicador muestra **✓ Sincronizado**.
5. En el ordenador, abre **esa misma web**, entra en **☁ Nube** con el **mismo correo y contraseña** y pulsa sincronizar.
6. Comprueba con una sesión de prueba: guarda `Press banca` con un peso y repeticiones en el móvil; desde el ordenador haz clic en **Sincronizar** o vuelve a enfocar la pestaña y verifica que aparece.

La sincronización opera en ambos sentidos. La aplicación reintenta los cambios pendientes al volver Internet y revisa cambios remotos periódicamente mientras está abierta.

## 6. Báscula y hueso

En la pestaña **⚖ Báscula** añade la fecha, peso (kg), grasa (%), músculo (kg o %), agua (%) y masa ósea / hueso (kg o %). Cada variable dispone de gráfico e historial. No se mezclan porcentajes y kilos en una misma curva.

Estos valores son estimaciones del aparato: mide en condiciones parecidas para observar tendencias; el valor de hueso no sirve para diagnosticar osteoporosis.

## 7. Si vienes de la v2

- Primero, **exporta un JSON** desde la v2 (pestaña Datos) para proteger tu historial.
- La v3 detecta las versiones locales guardadas en el mismo navegador y conserva una copia antigua cuando la encuentra.
- Desde **☁ Nube** puedes **Descargar copia v2** y **Fusionar v2 con la actual** si se detectó una copia en ese dispositivo.
- También puedes importar el JSON completo en **Datos**, pero recuerda que la importación general **sustituye la información local**, y al sincronizar puede sustituir datos cloud que ya existieran. Si ambos dispositivos tienen registros valiosos distintos, mejor fusiona la copia v2 en vez de reemplazar.

## 8. Seguridad, cambios simultáneos y copias

- Cada usuario ve solamente sus registros gracias a las políticas RLS.
- La página y los archivos HTML son públicos en GitHub Pages. Tus registros no se publican allí; permanecen en la base de datos privada y en caché de los dispositivos donde hayas iniciado sesión.
- Si editas **exactamente el mismo registro** en dos dispositivos sin sincronizar, la app avisa de conflicto y pide elegir qué versión conservar. No puedes fusionar automáticamente dos versiones distintas de una misma serie.
- Mientras haya registros pendientes o conflictos **no borres los datos del navegador**, no uses el modo incógnito como almacenamiento principal y no pulses «Cerrar sesión y borrar caché local».
- Exporta un JSON desde **Datos** con regularidad: la base de datos no sustituye un buen respaldo.
- Esta versión **no importa datos automáticamente de Polar ni de la báscula**. La introducción es manual.
