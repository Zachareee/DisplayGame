namespace DisplayGame.Model;

using System.Text.Json;
using System.Text.Json.Serialization;
using System.Text.RegularExpressions;

public sealed record GameRecord(string Name, string Thumbnail);

public record Config(Dictionary<string, Regex> Patterns, Dictionary<string, GameRecord> Records)
{
    private static Config _instance;
    private static FileSystemWatcher watcher = new(Path.GetFullPath("."), "config.json") { EnableRaisingEvents = true, NotifyFilter = NotifyFilters.LastWrite };

    static Config()
    {
        _instance = OnChanged();
        watcher.Changed += OnChanged;
    }

    private static void OnChanged(object sender, FileSystemEventArgs e)
    {
        _instance = OnChanged();
    }

    private static Config OnChanged()
    {
        var i = JsonSerializer.Deserialize<Config>(
            File.Open(@"./config.json", FileMode.Open, FileAccess.Read, FileShare.ReadWrite),
            new JsonSerializerOptions()
            {
                PropertyNameCaseInsensitive = true,
                Converters = { new RegexConverter() }
            }
            );
        if (i is null) throw new FileLoadException("File not found: config.json");
        return i;
    }

    public static bool GetGame(string app, string cmdline, out GameRecord Game)
    {
        if (!_instance.Patterns.TryGetValue(app, out Regex? regex))
        {
            return _instance.Records.TryGetValue(app, out Game!);
        }
        var match = regex.Match(cmdline).Groups[1].Value;
        return _instance.Records.TryGetValue(match, out Game!);
    }
};

class RegexConverter : JsonConverter<Regex>
{
    public override Regex? Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
    {
        string? pattern = reader.GetString();
        return pattern is null ? null : new Regex(pattern, RegexOptions.Compiled);
    }

    public override void Write(Utf8JsonWriter writer, Regex value, JsonSerializerOptions options)
    {
        writer.WriteStringValue(value.ToString());
    }
}
