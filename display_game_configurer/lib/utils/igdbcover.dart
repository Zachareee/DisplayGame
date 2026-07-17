import "dart:convert";
import "package:http/http.dart";
import "package:dotenv/dotenv.dart";

var env = DotEnv()..load([".env"]);
var clientID = env["TTVclientID"]!;
var clientSecret = env["TTVclientS"]!;

typedef Game = ({
  String name,
  int? firstReleaseDate,
  List<String>? platforms,
  String cover,
});

class Igdbcover {
  String _authToken = "";

  Igdbcover._();

  static Igdbcover? _instance;

  static Future<Igdbcover> authenticate() async {
    if (_instance case final instance?) return instance;
    var res = await post(
      Uri.parse(
        "https://id.twitch.tv/oauth2/token?client_id=$clientID&client_secret=$clientSecret&grant_type=client_credentials",
      ),
    );
    return _instance = Igdbcover._().._authToken = jsonDecode(res.body)["access_token"];
  }

  Future<dynamic> authenticatedPost(String url, body) async {
    return jsonDecode(
      (await post(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $_authToken", "Client-ID": clientID},
        body: body,
      )).body,
    );
  }

  Future<List<Game>> search(String term, {int limit = 10}) async {
    List<dynamic> res = await authenticatedPost(
      "https://api.igdb.com/v4/games",
      "fields name, platforms.name, first_release_date, cover.url; limit $limit; search \"$term\";",
    );
    return res
        .where((e) => e["cover"]?["url"] != null)
        .map(
          (d) => (
            name: d["name"] as String,
            platforms: (d["platforms"] as List<dynamic>?)
                ?.map((e) => e["name"] as String)
                .toList(),
            firstReleaseDate: d["first_release_date"] as int?,
            cover:
                "https:${(d["cover"]?["url"] as String).replaceFirst("t_thumb", "t_cover_small_2x")}",
          ),
        )
        .toList();
  }
}
