# movieDB
Sencilla aplicación en Swift que permite buscar películas en The Open Movie Database.

## Información de interés
- Versión de Xcode usada: 11.3
- Versión de iOs soporta iOS 13.2

## Arquitectura
- Se ha seguido un patrón de arquitectura MVVM. Dada la sencillez del proyecto, no se han utilizado coordinators.
- Para la comunicación entre la vista y el VM, se ha utilizado Combine. No había tenido oportunidad de utilizarlo profesionalmente por la limitación de iOS 13, así que he aprovechado esta prueba para aprender y hacer la prueba mas divertida.

## Notas
- Para que el botón de compartir web esté activo, es necesario que la pelicula tenga una dirección web calida, he mirado decenas de peliculas y no he encontrado ninguna que la tuviera, aun así la funcionalidad está implementada.