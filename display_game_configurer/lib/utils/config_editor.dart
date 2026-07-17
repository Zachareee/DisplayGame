class ConfigEditor {
  ConfigEditor._();

  static void addEntry(String name, String cover) {
    print("${name} ${cover} added");
  }

  static void saveConfig() {
    print("Config saved!");
  }
}
