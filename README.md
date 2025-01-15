# To-Do List

Di seguito trovi un esempio completo di applicazione ToDo List in Flutter che:
- Gestisce l’aggiunta e la rimozione di task (con setState);
- Salva lo stato localmente usando SharedPreferences (puoi usare anche altre soluzioni come hive o sqflite);
- Permette il riordino dei task usando un ReorderableListView e le Keys.

Assicurati di avere tra le dipendenze nel tuo file pubspec.yaml il pacchetto shared_preferences.
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.0.15  # o versione più recente

