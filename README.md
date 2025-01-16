# To-Do List

In questo repository trovate il codice del progetto To-Do List del mio corso su Flutter e Dart. Questo programma ha le seguenti caratteristiche:
- Gestisce l’aggiunta e la rimozione di task (con setState);
- Salva lo stato localmente usando SharedPreferences (puoi usare anche altre soluzionicome hive o sqflite);
- Permette il riordino dei task usando un ReorderableListView e le Keys.

Assicurati di avere tra le dipendenze nel tuo file pubspec.yaml il pacchetto shared_preferences.
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.0.15  # o versione più recente

